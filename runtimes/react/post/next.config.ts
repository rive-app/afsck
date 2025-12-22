import type { NextConfig } from "next";
import path from "path";

const nextConfig: NextConfig = {
  output: "standalone",

  // Handle symlinked packages
  transpilePackages: ["@rive-app/react-canvas", "@rive-app/canvas"],

  webpack: (config) => {
    // Ensure webpack follows symlinks
    config.resolve.symlinks = true;

    // Add the rive-react directory to the module resolution
    config.resolve.modules = [
      ...(config.resolve.modules || []),
      path.resolve(__dirname, "../../../rive-react/npm/react-canvas/node_modules"),
      path.resolve(__dirname, "../../../rive/packages/runtime_wasm/js/npm/canvas"),
    ];

    return config;
  },
};

export default nextConfig;
