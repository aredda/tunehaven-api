# Contributing to Tunehaven API

Thanks for your interest in contributing! This document explains how to set up the project,
the conventions we follow, and how to get a change merged.

By participating in this project you agree to abide by our
[Code of Conduct](CODE_OF_CONDUCT.md).

## Ways to contribute

- Report bugs and request features using the
  [issue templates](https://github.com/aredda/tunehaven-api/issues/new/choose).
- Improve documentation (the [README](README.md) is the primary reference).
- Submit pull requests for fixes, features or tests.
- Triage issues and review pull requests.

## Development setup

See [Getting started](README.md#getting-started) in the README. In short:

```bash
bundle install
cp .example.env .env        # then fill in the values
bin/rails db:create db:migrate db:seed
bin/dev
```

Some features (ingestion, transcoding, metadata enrichment, email) require external services —
Google Cloud Storage/Pub/Sub, MusicBrainz and SMTP. See
[External services](README.md#external-services). You do **not** need them to work on the API
surface or the test suite.

## Running the checks

Every pull request must pass the same checks that CI runs:

```bash
bin/rails db:test:prepare test   # test suite
bin/rubocop                      # style (rubocop-rails-omakase)
bin/brakeman --no-pager          # static security analysis
```

The test suite requires **FFmpeg** and **ImageMagick** to be installed. Run the focused test
file(s) while developing, e.g.:

```bash
bin/rails test test/integration/user/tracks_controller_test.rb
```

## Architecture conventions

The application deliberately keeps controllers and models thin and puts use‑case logic in
**concepts** under `app/concepts` (Trailblazer operations, views, forms and finders). When
adding or changing behaviour, follow the existing patterns:

- **Operations** (`app/concepts/**/operation/`) orchestrate a use case and set `ctx[:model]`.
  Extend `ApplicationOperation`; use its `fail_error` / `fail_not_found` helpers so failures
  surface consistently as `{ success: false, errors: ... }`.
- **Forms** (`.../form/`) define the input schema and validations. Extend `ApplicationForm`.
- **Views** (`.../view/`) serialise responses. Extend `ApplicationView`; collection views are
  used with `View.for_collection`.
- **Finders** (`.../finder/`) handle querying, filtering and pagination. Extend
  `ApplicationFinder` (10 per page, max 50) and reuse `Concerns::SearchSanitizer` for
  user‑supplied search input.
- **Controllers** stay thin: `run Some::Operation` and render a view. Namespaced controllers
  inherit from `User::Controller` / `Admin::Controller`, which enforce authentication.
- **Native/formatting helpers** live under `lib/` (e.g. `Helpers::TitleFormatter`,
  `Musicbrainz::ReleaseGroup`).

Guidelines:

- Add or update tests for any behaviour change (Minitest integration/controller/model tests).
  Fabricators live in `test/fabricators`.
- Keep queries safe: never interpolate user input into SQL; sanitize search terms.
- Follow the existing namespacing (`Platform::`, `User::`, `Admin::`, `PubSub::`).
- Match the surrounding style — RuboCop (`rubocop-rails-omakase`) is enforced.

## Commit and branch conventions

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: <short description>
```

Common types: `feat`, `fix`, `refactor`, `chore`, `build`, `test`, `docs`, `perf`.

Examples:

```
feat: added followers & following GET endpoints
fix: ordered search results by likes count
chore: update outdated gems
```

Branch names should be descriptive, e.g. `feat/track-lyrics`, `fix/playlist-counter`.

## Pull request process

1. Fork the repository and create a branch from `main`.
2. Make your change, add tests, and ensure all checks pass locally.
3. Keep pull requests focused — one logical change per PR.
4. Update the README (and this file, if relevant) when behaviour or configuration changes.
5. Open the PR and fill in the template. Link any related issue.

A maintainer will review as soon as possible. Please be responsive to review comments; PRs
with failing checks or unresolved conversations will not be merged.

## Reporting security issues

**Do not open a public issue for security vulnerabilities.** Follow the process in
[SECURITY.md](SECURITY.md).

## Secrets

Never commit secrets. `.env`, `config/master.key`, service‑account JSON and any credentials
must stay out of the repository. This project reads all configuration from environment
variables — see `.example.env` for the full list, and never commit a filled‑in copy.
