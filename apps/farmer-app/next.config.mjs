import withPWAInit from 'next-pwa';

const withPWA = withPWAInit({
  dest: 'public',
  register: true,
  skipWaiting: true,
  disable: process.env.NODE_ENV === 'development',
  runtimeCaching: [
    {
      urlPattern: /^https:\/\/api\.farmy\.in\/api\/products/,
      handler: 'StaleWhileRevalidate',
      options: { cacheName: 'product-catalog', expiration: { maxEntries: 200, maxAgeSeconds: 3600 } }
    },
    {
      urlPattern: /^https:\/\/api\.farmy\.in\/api\/farmer\/dashboard/,
      handler: 'NetworkFirst',
      options: { cacheName: 'farmer-dashboard', networkTimeoutSeconds: 5 }
    }
  ]
});

/** @type {import('next').NextConfig} */
const nextConfig = {
    // Other Next.js config options
};

export default withPWA(nextConfig);
