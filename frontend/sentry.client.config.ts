import * as Sentry from "@sentry/nextjs";

if (!process.env.NEXT_PUBLIC_SENTRY_DSN) {
  throw new Error("NEXT_PUBLIC_SENTRY_DSN is required for Sentry integration");
}

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: 1.0,
});
