const { withSentryConfig } = require("@sentry/nextjs");

// "standalone" output produces a server.js entry point. Static assets
// will be copied into the standalone directory during deployment so
// that Next.js can serve them correctly in production.
const nextConfig = {
  output: "standalone",
  reactStrictMode: true,
  images: {
    domains: ["localhost"],
  },
  async headers() {
    return [
      {
        source: "/(.*)",
        headers: [
          {
            key: "Content-Security-Policy",
            value: "default-src 'self'; img-src 'self' data: https:; object-src 'none'",
          },
          {
            key: "Strict-Transport-Security",
            value: "max-age=63072000; includeSubDomains; preload",
          },
        ],
      },
    ];
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
