import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.yourdomain.edugram',
  appName: 'Edugram',
  webDir: 'dist/client',  // <- This points to the correct folder
  bundledWebRuntime: false
};

export default config;
