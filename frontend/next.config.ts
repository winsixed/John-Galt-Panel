import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  async headers() {
    return [{
      source: "/:path*",
      headers: [{ key: "Content-Security-Policy", value: "default-src 'self'" }]
    }];
  },
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

export default nextConfig;
