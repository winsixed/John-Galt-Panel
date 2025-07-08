const { withSentryConfig } = require("@sentry/nextjs");

const nextConfig = {
  output: "standalone",
  reactStrictMode: true,
  // CSP is configured via nginx. Remove header from Next.js to avoid conflict.
  images: {
    unoptimized: true,
  },
  webpack(config) {
    config.module.rules.push({
      test: /\.svg$/,
      use: ["@svgr/webpack"],
    });
    return config;
  },
};

module.exports = process.env.SENTRY_DSN
  ? withSentryConfig(nextConfig)
  : nextConfig;
