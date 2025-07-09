import * as Sentry from "@sentry/nextjs";

if (!process.env.SENTRY_DSN) {
  throw new Error("SENTRY_DSN is required for Sentry integration");
}

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  tracesSampleRate: 1.0,
});
