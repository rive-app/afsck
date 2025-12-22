const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const projectRoot = __dirname;
const workspaceRoot = path.resolve(projectRoot, '../../..');

const config = getDefaultConfig(projectRoot);

// Watch the rive-react-native folder for changes
config.watchFolders = [
  path.resolve(workspaceRoot, 'rive-react-native'),
];

// Make sure Metro can resolve modules from the workspace root
config.resolver.nodeModulesPaths = [
  path.resolve(projectRoot, 'node_modules'),
  path.resolve(workspaceRoot, 'rive-react-native', 'node_modules'),
];

// Ensure symlinks are followed
config.resolver.unstable_enableSymlinks = true;

module.exports = config;
