const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3151;

// Enable CORS for all origins
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(express.json());

// Simple health endpoint
app.get('/health', (req, res) => {
  console.log('Health check request received');
  res.json({
    status: 'OK',
    message: 'Test server is running',
    timestamp: new Date().toISOString(),
    port: PORT
  });
});

// Test SSO endpoint
app.get('/auth/sso/google/url', (req, res) => {
  console.log('Google SSO URL request received');
  res.json({
    success: true,
    data: {
      authUrl: 'https://accounts.google.com/oauth/authorize?test=true'
    }
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Test server running on port ${PORT}`);
  console.log(`Access via: http://localhost:${PORT}/health`);
  console.log(`Access via: http://127.0.0.1:${PORT}/health`);
});
