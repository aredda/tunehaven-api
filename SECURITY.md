# Security Policy

## Supported versions

Tunehaven API is under active development. Security fixes are applied to the `main` branch.
There are no maintained release branches at this time.

| Version | Supported |
| --- | --- |
| `main` | :white_check_mark: |

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues, discussions or
pull requests.**

Instead, report them privately using GitHub's
[private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
feature on this repository (**Security** tab → **Report a vulnerability**), or contact the
maintainer directly: [INSERT CONTACT METHOD].

Please include as much of the following as you can:

- The type of issue and the affected component (endpoint, operation, model, job…).
- Steps to reproduce, including any required authentication or configuration.
- The potential impact and any suggested remediation.
- Whether the issue is already publicly known.

You can expect an acknowledgement within a few days. We will keep you informed as the issue is
triaged and fixed, and we will credit you in the advisory unless you prefer otherwise.

## Handling secrets

This application is configured entirely through environment variables and must never contain
committed secrets. When working with the project:

- **Never commit** `.env`, `.env.dev`, `config/master.key`, Google service‑account JSON, or any
  filled‑in copy of `.example.env`. These are covered by `.gitignore` and `.dockerignore`.
- Treat the following as secrets and generate strong, unique values per environment:
  `SECRET_KEY_BASE`, `DEVISE_JWT_SECRET`, `POSTGRES_PASSWORD`, `MAILER_PASSWORD`,
  `MUSICBRAINZ_PASSWORD`, `GOOGLE_CLOUD_CREDENTIALS`, `SENTRY_DSN`, `RAILS_MASTER_KEY` and
  `ADMIN_PASSWORD`.
- Uploaded audio and artwork are stored in a **private** bucket and shared via expiring
  presigned URLs. Do not make the bucket public.
- If a secret is ever committed, **rotate it immediately** — removing it from the working tree
  is not sufficient, since it remains in Git history.

## Secure deployment checklist

- Serve the API behind TLS (the bundled Caddy service issues certificates automatically).
- Restrict `ALLOWED_ORIGINS` to your client applications; do not use a wildcard in production.
- Keep the database bound to localhost / the private network (the default production compose
  binds Postgres to `127.0.0.1` only).
- Protect the GoodJob dashboard (`/good_job`) — do not expose it publicly without access
  controls.
- Run `bin/brakeman` before releases; it is also executed in CI on every change.
