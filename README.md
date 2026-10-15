# Tunehaven API

[![CI](https://github.com/aredda/tunehaven-api/actions/workflows/ci.yml/badge.svg)](https://github.com/aredda/tunehaven-api/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A REST API backend for a music streaming platform. Tunehaven manages a music catalogue
(artists, albums, tracks), user accounts with a social layer (playlists, likes, saves and
follows), on‑demand audio streaming with multiple quality tiers, and an automated ingestion
pipeline that turns audio files dropped into cloud storage into a browsable, transcoded
catalogue.

It is a JSON API only — no server‑rendered views — designed to be consumed by a separate
client application.

---

## Table of contents

- [Features](#features)
- [Tech stack](#tech-stack)
- [Architecture](#architecture)
  - [High‑level overview](#high-level-overview)
  - [Application structure (Trailblazer concepts)](#application-structure-trailblazer-concepts)
  - [Request lifecycle](#request-lifecycle)
  - [Domain model](#domain-model)
  - [Media ingestion pipeline](#media-ingestion-pipeline)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Configuration](#configuration)
  - [Running natively](#running-natively)
  - [Running with Docker](#running-with-docker)
  - [Seeding data](#seeding-data)
  - [External services](#external-services)
- [API reference](#api-reference)
  - [Authentication](#authentication)
  - [Conventions](#conventions)
  - [Authentication endpoints](#authentication-endpoints)
  - [User endpoints](#user-endpoints)
  - [Admin endpoints](#admin-endpoints)
  - [Operational endpoints](#operational-endpoints)
- [Testing and code quality](#testing-and-code-quality)
- [Deployment](#deployment)
- [Project structure](#project-structure)
- [Known limitations](#known-limitations)
- [Contributing](#contributing)
- [License](#license)
- [Security](#security)

---

## Features

- **Catalogue management** — artists, albums, tracks and genres, with slugs, ordering,
  cover art and genre relationships (admin‑managed).
- **Audio streaming** — per‑track audio variants streamed inline, with user‑selectable
  quality tiers.
- **Downloads** — presigned cloud storage URLs for direct, client‑side downloads.
- **Authentication** — Devise + JWT with separate `user` and `admin` scopes, token
  revocation via a denylist.
- **Social layer** — public/private playlists, likes/saves on albums and playlists,
  followers/following, and a personalised home feed.
- **Search** — type‑scoped search across tracks, albums, artists and playlists.
- **Automated ingestion** — a Google Cloud Storage → Pub/Sub subscriber creates catalogue
  records automatically and transcodes uploaded audio in the background.
- **Metadata enrichment** — album release dates and genres fetched from the MusicBrainz API.
- **Background jobs** — GoodJob (Postgres‑backed Active Job) with a mounted dashboard.
- **Observability** — structured ingest logging and optional Sentry error reporting.

## Tech stack

| Layer | Technology |
| --- | --- |
| Language | Ruby 4.0.7 |
| Framework | Rails 8.1 (API‑only) |
| Database | PostgreSQL 17 (`citext`, `pgcrypto`/`gen_random_uuid`, good_job tables) |
| Web server | Puma |
| Application pattern | Trailblazer (operation / view / form / finder) with Reform, Representable, dry‑validation |
| Authentication | Devise + devise‑jwt / warden‑jwt_auth |
| Background jobs | GoodJob |
| File storage | CarrierWave + `fog-google` (Google Cloud Storage) |
| Media processing | FFmpeg (`streamio-ffmpeg`), MiniMagick |
| Messaging | Google Cloud Pub/Sub |
| External APIs | MusicBrainz (release group metadata) |
| Reverse proxy | Caddy (automatic TLS) |
| Error tracking | Sentry (optional) |
| Testing | Minitest, Shoulda, Fabrication, Timecop |

## Architecture

### High-level overview

```
                      ┌─────────────────────────────────────────────┐
   client app ──HTTPS─▶│ Caddy (TLS termination, reverse proxy)      │
   (web/mobile)        └───────────────┬─────────────────────────────┘
                                       │ :3000
                        ┌──────────────▼──────────────┐
                        │  api  (Rails + Puma)        │
                        │  JSON API, JWT auth         │
                        └───┬─────────┬───────────┬───┘
                            │         │           │
              ┌─────────────▼─┐  ┌────▼──────┐  ┌─▼──────────────────┐
              │  PostgreSQL   │  │  jobber   │  │ storage_subscriber │
              │  (all data +  │  │  GoodJob  │  │ Google Pub/Sub     │
              │   job queue)  │  │  workers  │  │ consumer           │
              └───────────────┘  └───────────┘  └─────────┬──────────┘
                                                          │ pull
                                              ┌───────────▼───────────┐
                                              │ Google Cloud Storage  │
                                              │  (bucket + Pub/Sub)   │
                                              └───────────────────────┘
   External: MusicBrainz API (metadata) · SMTP (email) · Sentry (errors)
```

The production stack is defined in `docker-compose.prod.yml` and consists of five services:
`database` (Postgres 17), `api`, `jobber` (GoodJob workers), `storage_subscriber`
(Pub/Sub consumer) and `caddy` (reverse proxy). The API, jobber and subscriber all run the
same image built from `prod.Dockerfile`.

### Application structure (Trailblazer concepts)

Business logic does **not** live in controllers or fat models. It lives in **concepts**
under `app/concepts`, following the Trailblazer layout. Each concept is a folder containing
up to four kinds of class:

| Type | Base class | Responsibility |
| --- | --- | --- |
| `operation/` | `ApplicationOperation < Trailblazer::Operation` | Orchestrates a use case as a pipeline of steps: load models, validate, persist, trigger side effects. |
| `form/` | `ApplicationForm < Reform::Form` | Input schema and validation rules (dry‑validation contracts, type coercion). |
| `view/` | `ApplicationView < Representable::Decorator` | Serialises models/collections into the JSON response shape. |
| `finder/` | `ApplicationFinder < Trailblazer::Finder` | Query objects with filtering and Kaminari pagination (10/page, max 50). |

Controllers are deliberately thin: `Trailblazer::Rails::Controller` wires `run Some::Operation`
and assigns `@operation`, `@model` and `@form`. On success the controller renders a view; on
failure `ApplicationOperation` collects errors into the form so the controller can respond
with `{ success: false, errors: ... }`.

### Request lifecycle

```
GET /api/user/tracks/:id/stream
  └─ User::TracksController#stream
       └─ run Platform::Track::Operation::Stream        # operation
            ├─ Model::Find(Platform::Track, find_by: :id)
            ├─ find_quality_setting                     # reads current_user setting
            └─ find_audio                               # selects matching Platform::Track::Audio
       └─ send_data(open(audio.file_url).read, ...)     # inline audio bytes
```

Other representative flows:

- **Sign in** — `POST /api/user/sign_in` → `User::SessionsController#create` →
  `User::Operation::SignIn` (validate via `User::Form::SignIn`, find user, check password);
  the JWT is read back from `request.env["warden-jwt_auth.token"]` and returned.
- **Paginated listing** — an operation runs `Finder(Some::Finder::Base, :all, scope)`; the
  controller renders `View.for_collection.new(result)` together with `MetaView.new(result)`
  for pagination metadata.

### Domain model

```
User ──1:N──▶ User::Playlist ──1:N──▶ User::PlaylistTrack ──N:1──▶ Platform::Track
 │                 │                                                    ▲
 │                 └──1:N──▶ User::Like (polymorphic)                   │
 ├──1:N──▶ User::Like  (→ Platform::Album | User::Playlist)             │
 ├──1:N──▶ User::Setting                                               │
 └──1:N──▶ User::Follow (follower ↔ following)                         │
                                                                       │
Platform::Artist ──1:N──▶ Platform::Album ──1:N──▶ Platform::Track ────┘
                               │                          │
                               │                          └──1:N──▶ Platform::Track::Audio
                               └──N:M──▶ Platform::Genre  (also N:M with Artist & Track)
```

Key models:

| Model | Purpose |
| --- | --- |
| `User` | Account (UUID PK, `citext` email/username). Owns playlists, likes, settings and follows. Gets a default "Liked" playlist and quality settings on create. |
| `AdminUser` | Separate back‑office account scope. |
| `User::JwtDenylist` / `AdminUser::JwtDenyList` | Revoked JWT registry. |
| `User::Playlist` | Playlist with `private`/`public` visibility state machine, `is_default` flag, counters. |
| `User::PlaylistTrack` | Ordered playlist ↔ track join (`acts_as_list`‑style `position`). |
| `User::Like` | Polymorphic like/save for albums and playlists. |
| `User::Follow` | Self‑referential follow graph with counter caches. |
| `User::Setting` | Per‑user key/value settings (notably stream/download quality). |
| `Platform::Artist` | Artist with slug, bio and genres. |
| `Platform::Album` | Album with cover art, release date, slug (`<artist>-<title>`), likes counter. |
| `Platform::Track` | Track, ordered within its album, with a master audio and derived variants. |
| `Platform::Track::Audio` | A concrete audio file: `quality` (`original`/`low`/`mid`/`high`) and `method` (`uploaded`/`loaded`/`coded`). |
| `Platform::Genre` | Genre with optional parent/child hierarchy and a `featured` flag. |
| `Platform::TrackGenre` / `AlbumGenre` / `ArtistGenre` | Genre join tables. |
| `Platform::Log::StorageSubEvent` | Audit log of ingestion events (state machine: processed → succeeded/failed). |

### Media ingestion pipeline

Audio enters the platform in one of two ways: **automatically** from Google Cloud Storage via
Pub/Sub, or **manually** through the admin track API.

**1. Automatic (cloud storage notification).** A `bin/storage_subscriber` process runs a
Pub/Sub subscriber (`GCS_SUBSCRIPTION`) with an 8‑thread listener:

```
GCS object created
  └─▶ Pub/Sub message { attributes.eventType, data.name }
        └─▶ PubSub::Operation::Create        (accepts audio/flac, image/jpeg, image/png
             │                                 under a /library/<artist>/<album>/<file> path)
             ├─ process_audio   → find/create Artist, Album, Track (+ master audio record)
             │                    title parsed from filename (e.g. "01 - Song.flac")
             │                    album enriched via Musicbrainz::ReleaseGroup (date + genres)
             ├─ transcode_audio → enqueues Platform::Track::Audio::TranscodeJob
             └─ process_image   → attaches the album cover from the bucket
        └─▶ writes a Platform::Log::StorageSubEvent and acknowledges the message
```

**2. Manual (admin upload).** `POST /api/admin/tracks` (or the nested audios endpoint) stores
the file with CarrierWave and enqueues the same transcode job.

**3. Transcoding.** `Platform::Track::Audio::TranscodeJob` downloads the master (a FLAC
"original") and produces MP3 variants via FFmpeg:

| Quality | Bitrate |
| --- | --- |
| `low` | 128 kbps |
| `mid` | 192 kbps |
| `high` | 320 kbps |
| `original` | master (FLAC) |

Each variant is stored as a `Platform::Track::Audio` with its own metadata (size, duration,
bitrate, sample rate, channels, format). Streaming serves the variant matching the user's
quality setting; downloads return a **presigned GCS URL** so clients fetch directly from the
bucket. Audio objects are private, so URLs are signed and expire.

## Getting started

### Prerequisites

- **Ruby 4.0.7** (see `.ruby-version` / `.tool-versions`)
- **PostgreSQL 17** (running locally or via Docker)
- **FFmpeg** — required for audio probing and transcoding
- **ImageMagick** — required by MiniMagick for cover art variants
- **Bundler**
- PostgreSQL client library headers (`libpq-dev` on Debian/Ubuntu) to build the `pg` gem

### Configuration

All configuration is provided through environment variables and read at boot with
`ENV.fetch`, so the app will **not start** until the required ones are set. Copy the template
and fill it in:

```bash
cp .example.env .env
```

| Variable | Required | Description |
| --- | --- | --- |
| `POSTGRES_HOST` | yes | Database host (e.g. `localhost`). |
| `POSTGRES_PORT` | yes | Database port (e.g. `5432`). |
| `POSTGRES_USER` | yes | Database role. |
| `POSTGRES_PASSWORD` | yes | Database password. |
| `POSTGRES_DATABASE` | yes | Database name used to initialise the Postgres container. |
| `SECRET_KEY_BASE` | production | Rails key for signing/encrypting; generate with `bin/rails secret`. |
| `DEVISE_JWT_SECRET` | yes | Secret used to sign JWTs; generate with a strong random value. |
| `ADMIN_EMAIL` / `ADMIN_PASSWORD` | seeding | Credentials for the admin created by `db:seed`. |
| `GCS_PROJECT_NAME` | yes | Google Cloud project ID. |
| `GOOGLE_CLOUD_CREDENTIALS` | yes | Service account JSON **as a single line**. |
| `GCS_BUCKET_NAME` | yes | Storage bucket for audio and artwork. |
| `GCS_SUBSCRIPTION` | subscriber | Pub/Sub subscription name for bucket notifications. |
| `ALLOWED_ORIGINS` | yes | Comma‑separated CORS origins. |
| `GOOD_JOB_QUEUES` | no | Queue selection for GoodJob (e.g. `"default:1;"`). |
| `MAILER_ADDRESS` / `MAILER_PORT` / `MAILER_USER` / `MAILER_PASSWORD` | yes | SMTP settings for transactional email. |
| `MUSICBRAINZ_USERNAME` / `MUSICBRAINZ_PASSWORD` | metadata | Credentials for the MusicBrainz WS/2 API. |
| `SENTRY_DSN` | no | Sentry DSN. Leave blank to disable error reporting. |
| `RAILS_MASTER_KEY` | no | Only needed if you use Rails encrypted credentials. |

> `POSTGRES_DATABASE` initialises the database **container**. Rails itself connects to
> fixed names per environment: `tunehaven_db_dev`, `tunehaven_db_test` and
> `tunehaven_db_prod` (see `config/database.yml`).

### Running natively

```bash
# 1. Install dependencies
bundle install

# 2. Configure the environment
cp .example.env .env   # then edit .env

# 3. Create and prepare the database
bin/rails db:create db:migrate db:seed

# 4. Run the API
bin/dev                # or: bin/rails server

# 5. (optional) Run background workers in another terminal
bundle exec good_job start

# 6. (optional) Run the storage subscriber in another terminal
bundle exec rails runner bin/storage_subscriber
```

The API listens on `http://localhost:3000`.

### Running with Docker

A development stack (`docker-compose.dev.yml`) runs Postgres, the API and the storage
subscriber, with the source mounted for live reload. The API and subscriber read **`.env.dev`**,
while the database service reads **`.env`**.

```bash
cp .example.env .env
cp .example.env .env.dev          # docker-compose.dev.yml reads this for api/subscriber

docker compose -f docker-compose.dev.yml up --build

# In another terminal, prepare the database inside the api container:
docker compose -f docker-compose.dev.yml exec api bin/rails db:create db:migrate db:seed
```

For a lightweight local database only (useful when running Rails natively against a
containerised Postgres), use `docker-compose.yml`:

```bash
docker compose up -d
```

### Seeding data

`bin/rails db:seed` creates the platform admin from `ADMIN_EMAIL`/`ADMIN_PASSWORD` and loads
a small sample catalogue baked into `db/seed/*.json` (genres, artists, albums) via the
`seed:artists` and `seed:albums` rake tasks. It is safe to re‑run for albums (idempotent via
`find_or_initialize_by`).

### External services

To exercise the full pipeline you need a Google Cloud project with:

1. **A Cloud Storage bucket** (`GCS_BUCKET_NAME`) for audio and artwork.
2. **A service account** with Storage + Pub/Sub permissions, exported as JSON and embedded
   in `GOOGLE_CLOUD_CREDENTIALS` (single line).
3. **A Pub/Sub topic + subscription** wired to the bucket's object‑notification events; the
   subscription name goes in `GCS_SUBSCRIPTION`.

Audio uploaded under `library/<artist>/<album>/<NN - title>.flac` is picked up automatically.
MusicBrainz credentials are only needed for metadata enrichment; Sentry and SMTP are optional
but required at boot if referenced (see the table above).

## API reference

All routes are prefixed with `/api`, respond as JSON, and never take a `.:format` suffix.

### Authentication

Two independent Devise scopes exist, `user` and `admin`. Obtain a token from the sign‑in
endpoints and send it on every authenticated request:

```
Authorization: Bearer <jwt>
```

- Tokens are signed with `DEVISE_JWT_SECRET` and expire after **1 month**.
- `POST /api/user/sign_in`, `POST /api/admin/sign_in` and `POST /api/user/sign_up` dispatch
  tokens; `DELETE /api/user/sign_out` and `DELETE /api/admin/sign_out` revoke them via a
  denylist.
- Everything under the `user` namespace requires a user token; everything under `admin`
  requires an admin token. The endpoints listed as _Public_ below do not.

### Conventions

**Pagination.** Paginated endpoints accept `page` (default `1`) and `per_page` (default `10`,
capped at `50`) and return a `meta` block:

```json
{
  "success": true,
  "data": [ /* ... */ ],
  "meta": { "total_pages": 5, "current_page": 2, "next_page": 3, "prev_page": 1 }
}
```

**Success and error envelopes.**

```json
{ "success": true,  "data": { /* ... */ } }
{ "success": false, "errors": { "base": ["Audio is not found!"] } }
```

Error responses use `422`, `404` or `401` as appropriate. A few endpoints return a slightly
different shape (noted inline), e.g. sign‑in returns `{ "success": true, "token": "..." }`.

### Authentication endpoints

| Method | Path | Auth | Description |
| --- | --- | --- | --- |
| `POST` | `/api/user/sign_in` | Public | Sign in; returns `{ success, token }`. |
| `DELETE` | `/api/user/sign_out` | User | Revoke the current user token. |
| `POST` | `/api/user/sign_up` | Public | Register; returns `{ success, data: { token } }`. |
| `POST` | `/api/user/password/forget` | Public | Email a 6‑character reset code. |
| `GET` | `/api/user/password/verify` | Public | Verify a reset code (`?token=`). |
| `POST` | `/api/user/password/reset` | Public | Reset the password (`{ token, password }`). |
| `POST` | `/api/admin/sign_in` | Public | Admin sign in; returns `{ success, token }`. |
| `DELETE` | `/api/admin/sign_out` | Admin | Revoke the current admin token. |

### User endpoints

All require a user JWT.

**Account, profile & social**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/user/me` | Current user (`{ success, user }`). |
| `GET` | `/api/user/me/followers` | Users following me. |
| `GET` | `/api/user/me/following` | Users I follow. |
| `GET` | `/api/user/users/:id` | Public profile (email only for self). |
| `POST` | `/api/user/users/:id/follow` | Follow a user. |
| `DELETE` | `/api/user/users/:id/unfollow` | Unfollow a user. |
| `GET` | `/api/user/settings` | List settings (creates defaults if none exist). |
| `POST` | `/api/user/settings` | Upsert settings (`{ settings: [{ key, value }] }`). |
| `GET` | `/api/user/library/recent` | Five most recent library saves. |

**Home & search**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/home` | Home feed: recent saves, most‑saved albums, recently added albums. |
| `GET` | `/api/user/search` | Search; `?type=track|album|artist|playlist`, `?query=...`; paginated. |

**Tracks**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/user/tracks` | Liked tracks (the default playlist); paginated. |
| `GET` | `/api/user/tracks/:id` | Track detail (includes `download_url`). |
| `GET` | `/api/user/tracks/:id/stream` | Stream the audio inline (bytes are proxied by the API). |
| `GET` | `/api/user/tracks/:id/download` | Get a presigned download URL (`{ data }`). |
| `PUT` | `/api/user/tracks/:id/toggle_like` | Like/unlike the track. |
| `GET` | `/api/user/tracks/:id/playlists` | My playlists containing this track. |

**Playlists**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/user/playlists` | Owned + saved playlists; filter `?title=`. |
| `GET` | `/api/user/playlists/:id` | Playlist detail (owned or public). |
| `POST` | `/api/user/playlists` | Create (`{ playlist: { title, description } }`). |
| `PUT` | `/api/user/playlists/:id` | Update an owned playlist. |
| `DELETE` | `/api/user/playlists/:id` | Delete (the default "Liked" playlist cannot be deleted). |
| `PUT` | `/api/user/playlists/:id/toggle_visibility` | Toggle public/private. |
| `POST` | `/api/user/playlists/:id/toggle_save` | Save/unsave a public playlist. |
| `GET` | `/api/user/playlists/:playlist_id/tracks` | Tracks in a playlist; paginated. |
| `POST` | `/api/user/playlists/:playlist_id/tracks` | Add a track (`{ relationship: { track_id, playlist_id } }`). |
| `DELETE` | `/api/user/playlists/:playlist_id/tracks/:id` | Remove a track (`:id` is the track id). |

**Albums, artists & genres**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/user/albums` | Saved albums, most recent first. |
| `GET` | `/api/user/albums/:id` | Album detail (tracks, genres, per‑track `download_url`). |
| `POST` | `/api/user/albums/:id/toggle_save` | Save/unsave an album. |
| `GET` | `/api/user/artists` | List artists; paginated. |
| `GET` | `/api/user/artists/:id` | Artist detail (genres + albums). |
| `GET` | `/api/user/genres` | List genres; filter `?q=`. |
| `GET` | `/api/user/genres/featured` | Featured genres. |
| `GET` | `/api/user/genres/:id` | Genre detail. |
| `GET` | `/api/user/genres/:id/albums` | Albums in a genre; paginated. |

### Admin endpoints

All require an admin JWT.

**Account, dashboard & logs**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/admin/me` | Current admin. |
| `GET` | `/api/admin/dashboard/stats` | Counts of genres, artists, albums, tracks, users and audios. |
| `GET` | `/api/admin/logs/storage_sub_events` | Paginated ingestion events. |

**Genres**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/admin/genres` | List; filter `?name=`; paginated. |
| `GET` | `/api/admin/genres/autocomplete` | Autocomplete `?q=` → `{ id, name }`. |
| `GET` | `/api/admin/genres/:id` | Detail. |
| `POST` | `/api/admin/genres` | Create (`{ genre: { name, description, parent_id } }`). |
| `PUT` | `/api/admin/genres/:id` | Update. |
| `DELETE` | `/api/admin/genres/:id` | Delete. |

**Artists**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/admin/artists` | List; filter `?name=`; paginated. |
| `GET` | `/api/admin/artists/autocomplete` | Autocomplete `?q=`. |
| `GET` | `/api/admin/artists/:id` | Detail; accepts id **or slug**. |
| `POST` | `/api/admin/artists` | Create (`{ artist: { name, about, genre_ids[] } }`). |
| `PUT` | `/api/admin/artists/:id` | Update. |
| `DELETE` | `/api/admin/artists/:id` | Delete. |
| `GET` | `/api/admin/artists/:artist_id/genres` | Artist's genres. |
| `POST` | `/api/admin/artists/:artist_id/genres` | Attach genres. |
| `DELETE` | `/api/admin/artists/:artist_id/genres/:id` | Detach a genre. |

**Albums**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/admin/albums` | List; filters `?title=`, `?artist_name=`; paginated. |
| `GET` | `/api/admin/albums/autocomplete` | Autocomplete `?q=`. |
| `GET` | `/api/admin/albums/:id` | Detail; accepts id **or slug**. |
| `POST` | `/api/admin/albums` | Create, multipart (`cover`, `genre_ids[]` accepted). |
| `PUT` | `/api/admin/albums/:id` | Update. |
| `PUT` | `/api/admin/albums/:id/metadata` | Fetch release date + genres from MusicBrainz. |
| `DELETE` | `/api/admin/albums/:id` | Delete. |
| `GET` | `/api/admin/albums/:album_id/genres` | Album's genres. |
| `POST` | `/api/admin/albums/:album_id/genres` | Attach genres. |
| `DELETE` | `/api/admin/albums/:album_id/genres/:id` | Detach a genre. |

**Tracks**

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/admin/tracks` | List; filters `?title=`, `?album_title=`, `?artist_name=`; paginated. |
| `GET` | `/api/admin/tracks/:id` | Detail. |
| `GET` | `/api/admin/tracks/:id/stream` | Stream the audio inline. |
| `POST` | `/api/admin/tracks` | Create, multipart (`audio`); triggers transcoding. |
| `PUT` | `/api/admin/tracks/:id` | Update. |
| `PUT` | `/api/admin/tracks/:id/move/:position` | Reorder within the album. |
| `PUT` | `/api/admin/tracks/:id/transcode` | Re‑enqueue transcoding for the master audio. |
| `DELETE` | `/api/admin/tracks/:id` | Delete. |
| `DELETE` | `/api/admin/tracks` | Bulk delete (`{ track_ids: [...] }`). |
| `GET` | `/api/admin/tracks/:track_id/genres` | Track's genres. |
| `POST` | `/api/admin/tracks/:track_id/genres` | Attach genres. |
| `DELETE` | `/api/admin/tracks/:track_id/genres/:id` | Detach a genre. |
| `GET` | `/api/admin/tracks/:track_id/audios` | List audio variants. |
| `POST` | `/api/admin/tracks/:track_id/audios` | Upload an audio variant; triggers transcoding. |
| `DELETE` | `/api/admin/tracks/:track_id/audios/:id` | Delete a non‑master audio variant. |

### Operational endpoints

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/up` | Health check (200 when the app boots cleanly, otherwise 500). |
| `ANY` | `/good_job` | GoodJob web dashboard. |

## Testing and code quality

The suite uses Minitest with Shoulda matchers, Fabrication factories and Timecop, and runs in
parallel. FFmpeg and ImageMagick must be installed.

```bash
bin/rails db:test:prepare test   # run the test suite
bin/brakeman --no-pager          # static security analysis
bin/rubocop                      # style (rubocop-rails-omakase)
```

CI (`.github/workflows/ci.yml`) runs all three jobs on every push and pull request against a
Postgres service container:

- `scan_ruby` — Brakeman
- `lint` — RuboCop
- `test` — the Minitest suite

## Deployment

The production stack is a single‑host Docker Compose deployment.

```bash
# On the server, with the repository cloned and .env populated:
docker compose -f docker-compose.prod.yml up -d --build
```

What happens on boot:

1. **`api`** runs `entrypoint.sh`: installs any missing gems, runs `rails db:migrate`, then
   `exec`s the Puma server as a **non‑root user** (`app`).
2. **`jobber`** runs `bundle exec good_job start` to process background jobs.
3. **`storage_subscriber`** runs `bin/storage_subscriber` to consume Pub/Sub notifications.
4. **`caddy`** terminates TLS (automatically issued via Let's Encrypt) and proxies to `api:3000`.
5. **`database`** is Postgres 17, persisted on the host at `./db-data` and bound to
   `127.0.0.1:5432` only. Other containers reach it over the Compose network.

Configuration notes:

- All containers run with `RAILS_ENV=production` (baked into the image) and read secrets from
  the server's `.env`.
- Set your real domain in `Caddyfile` (the repository ships `tunehaven.example.com` as a
  placeholder) and CORS origins in `ALLOWED_ORIGINS`.
- Health checks gate startup: dependent services wait for Postgres to report ready, and all
  services use `restart: unless-stopped`.
- The image is built from `prod.Dockerfile`; `dev.Dockerfile` is for local development.

## Project structure

```
app/
├── concepts/            # Trailblazer operations, views, forms and finders (the core logic)
│   ├── application_*.rb # base operation / view / form / finder
│   ├── user/            # account, playlist, like, follow, library, search, settings
│   ├── platform/        # catalogue: album, artist, track, audio, genre (+ admin namespaces)
│   ├── pub_sub/         # ingestion operations driven by storage events
│   └── admin_user/      # dashboard + admin sign in
├── controllers/         # thin HTTP layer; user/ and admin/ base controllers enforce auth
├── jobs/                # Active Job workers (audio transcoding)
├── mailers/             # welcome + password reset emails
├── models/              # ActiveRecord models (user/, platform/)
└── uploaders/           # CarrierWave uploaders for audio and cover art
bin/
├── storage_subscriber   # Pub/Sub consumer entrypoint
├── dev, rails, rake     # standard binstubs
config/
├── routes.rb            # mounts Devise, draws config/routes/{user,admin}.rb
├── routes/              # user and admin route files
└── initializers/        # devise (JWT), cors, carrierwave, sentry, filtering
db/
├── schema.rb, migrate/  # schema and migrations
└── seed/                # sample catalogue JSON
lib/
├── helpers/             # storage manager, title formatter
├── musicbrainz/         # MusicBrainz release group client
└── tasks/               # seed rake tasks
test/                    # Minitest integration/controller/model tests + fabricators
Dockerfile(s)            # dev.Dockerfile, prod.Dockerfile
docker-compose*.yml      # prod / dev / local database
Caddyfile                # reverse proxy + TLS
```

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for the development
workflow, coding conventions and how to run the checks before opening a pull request. By
participating you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).

- Bug reports and feature requests: use the
  [issue templates](https://github.com/aredda/tunehaven-api/issues/new/choose).
- Security vulnerabilities: **do not** open a public issue — see [SECURITY.md](SECURITY.md).

## License

Released under the [MIT License](LICENSE).

## Security

Please review [SECURITY.md](SECURITY.md) for how to report vulnerabilities and which
configuration values must be treated as secrets.
