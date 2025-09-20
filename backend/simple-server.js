const http = require('http');
const url = require('url');
const querystring = require('querystring');
const fs = require('fs');
const path = require('path');

// In-memory storage
let registrations = [];
let registrationStats = {
  total: 0,
  pending: 0,
  approved: 0,
  rejected: 0
};

// Helper function to generate UUID
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// Helper function to update stats
function updateStats() {
  registrationStats.total = registrations.length;
  registrationStats.pending = registrations.filter(r => r.status === 'pending').length;
  registrationStats.approved = registrations.filter(r => r.status === 'approved').length;
  registrationStats.rejected = registrations.filter(r => r.status === 'rejected').length;
}

// Helper function to send JSON response
function sendJSON(res, statusCode, data) {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization'
  });
  res.end(JSON.stringify(data));
}

// Helper function to parse JSON body
function parseJSONBody(req, callback) {
  let body = '';
  req.on('data', chunk => {
    body += chunk.toString();
  });
  req.on('end', () => {
    try {
      const data = JSON.parse(body);
      callback(null, data);
    } catch (error) {
      callback(error, null);
    }
  });
}

// Helper function to parse form data body
function parseFormData(req, callback) {
  let body = '';
  req.on('data', chunk => {
    body += chunk.toString();
  });
  req.on('end', () => {
    try {
      // Simple form data parsing for multipart/form-data
      const contentType = req.headers['content-type'] || '';

      if (contentType.includes('application/json')) {
        const data = JSON.parse(body);
        callback(null, data);
      } else if (contentType.includes('multipart/form-data')) {
        // Extract boundary
        const boundary = contentType.split('boundary=')[1];
        if (!boundary) {
          callback(new Error('No boundary found'), null);
          return;
        }

        // Parse multipart data
        const parts = body.split(`--${boundary}`);
        const formData = {};

        for (const part of parts) {
          if (part.includes('Content-Disposition: form-data')) {
            const nameMatch = part.match(/name="([^"]+)"/);
            if (nameMatch) {
              const fieldName = nameMatch[1];
              const valueStart = part.indexOf('\r\n\r\n') + 4;
              const valueEnd = part.lastIndexOf('\r\n');
              let value = part.substring(valueStart, valueEnd);

              // If it's registrationData, parse as JSON
              if (fieldName === 'registrationData') {
                try {
                  value = JSON.parse(value);
                } catch (e) {
                  // Keep as string if not valid JSON
                }
              }

              formData[fieldName] = value;
            }
          }
        }

        callback(null, formData);
      } else {
        // Try to parse as JSON
        const data = JSON.parse(body);
        callback(null, data);
      }
    } catch (error) {
      callback(error, null);
    }
  });
}

// Create HTTP server
const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const pathname = parsedUrl.pathname;
  const method = req.method;

  console.log(`${method} ${pathname}`);

  // Handle CORS preflight
  if (method === 'OPTIONS') {
    res.writeHead(200, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    });
    res.end();
    return;
  }

  // Health check
  if (pathname === '/api/health' && method === 'GET') {
    sendJSON(res, 200, {
      success: true,
      message: 'KaziApp Backend is running',
      timestamp: new Date().toISOString()
    });
    return;
  }

  // Service Provider Registration
  if (pathname === '/api/service-provider/register' && method === 'POST') {
    parseFormData(req, (error, data) => {
      if (error) {
        console.error('Parse error:', error);
        sendJSON(res, 400, {
          success: false,
          message: 'Invalid request data: ' + error.message
        });
        return;
      }

      try {
        // Extract registration data (could be nested in registrationData field for FormData)
        let regData = data;
        if (data.registrationData && typeof data.registrationData === 'object') {
          regData = data.registrationData;
        }

        const registrationData = {
          id: generateUUID(),
          email: regData.email || '',
          firstName: regData.firstName || regData.ownerName?.split(' ')[0] || '',
          lastName: regData.lastName || regData.ownerName?.split(' ').slice(1).join(' ') || '',
          phoneNumber: regData.phone || regData.phoneNumber || '',
          serviceType: regData.serviceType || '',
          businessName: regData.businessName || '',
          businessDescription: regData.description || regData.businessDescription || '',
          businessAddress: regData.location || regData.businessAddress || '',
          county: regData.county || 'Not specified',
          subCounty: regData.subCounty || 'Not specified',
          ward: regData.ward || 'Not specified',
          hasBusinessLicense: regData.hasBusinessLicense || false,
          isRegisteredBusiness: regData.isRegisteredBusiness || false,
          businessLicense: regData.businessLicense || null,
          taxPin: regData.taxPin || null,
          businessLicenseImageUrl: regData.businessLicenseImageUrl || null,
          businessLogoImageUrl: regData.businessLogoImageUrl || null,
          idCopyImageUrl: regData.idCopyImageUrl || null,
          status: 'pending',
          rejectionReason: null,
          adminNotes: null,
          submittedAt: new Date().toISOString(),
          reviewedAt: null,
          reviewedBy: null,
          additionalData: regData.additionalData || {},
          documents: []
        };

        registrations.push(registrationData);
        updateStats();

        console.log('Registration created:', registrationData.id);
        console.log('Registration data:', JSON.stringify(registrationData, null, 2));

        sendJSON(res, 201, {
          success: true,
          message: 'Registration submitted successfully. You will be notified within 24-48 hours.',
          data: {
            id: registrationData.id,
            status: registrationData.status,
            submittedAt: registrationData.submittedAt
          }
        });
      } catch (error) {
        console.error('Registration error:', error);
        sendJSON(res, 500, {
          success: false,
          message: 'Failed to submit registration',
          error: error.message
        });
      }
    });
    return;
  }

  // Get all registrations (for admin)
  if (pathname === '/api/admin/registrations' && method === 'GET') {
    const query = parsedUrl.query;
    const status = query.status;
    const serviceType = query.serviceType;
    const search = query.search;
    const page = parseInt(query.page) || 1;
    const limit = parseInt(query.limit) || 10;

    let filteredRegistrations = [...registrations];

    // Apply filters
    if (status && status !== 'all') {
      filteredRegistrations = filteredRegistrations.filter(r => r.status === status);
    }

    if (serviceType) {
      filteredRegistrations = filteredRegistrations.filter(r => 
        r.serviceType.toLowerCase().includes(serviceType.toLowerCase())
      );
    }

    if (search) {
      filteredRegistrations = filteredRegistrations.filter(r => 
        r.businessName.toLowerCase().includes(search.toLowerCase()) ||
        r.ownerName.toLowerCase().includes(search.toLowerCase()) ||
        r.email.toLowerCase().includes(search.toLowerCase())
      );
    }

    // Pagination
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;
    const paginatedResults = filteredRegistrations.slice(startIndex, endIndex);

    sendJSON(res, 200, {
      success: true,
      data: paginatedResults,
      pagination: {
        page: page,
        limit: limit,
        total: filteredRegistrations.length,
        totalPages: Math.ceil(filteredRegistrations.length / limit)
      }
    });
    return;
  }

  // Get pending registrations
  if (pathname === '/api/admin/registrations/pending' && method === 'GET') {
    const pendingRegistrations = registrations.filter(r => r.status === 'pending');
    sendJSON(res, 200, {
      success: true,
      data: pendingRegistrations
    });
    return;
  }

  // Get registration statistics
  if (pathname === '/api/admin/registrations/statistics' && method === 'GET') {
    updateStats();
    sendJSON(res, 200, {
      success: true,
      data: registrationStats
    });
    return;
  }

  // Approve registration
  if (pathname.match(/^\/api\/admin\/registrations\/[^\/]+\/approve$/) && method === 'POST') {
    const id = pathname.split('/')[4];
    
    parseJSONBody(req, (error, data) => {
      if (error) {
        sendJSON(res, 400, {
          success: false,
          message: 'Invalid JSON data'
        });
        return;
      }

      const registration = registrations.find(r => r.id === id);
      if (!registration) {
        sendJSON(res, 404, {
          success: false,
          message: 'Registration not found'
        });
        return;
      }

      registration.status = 'approved';
      registration.approvedAt = new Date().toISOString();
      registration.approvalNotes = data.notes;

      updateStats();

      sendJSON(res, 200, {
        success: true,
        message: 'Registration approved successfully',
        data: registration
      });
    });
    return;
  }

  // Reject registration
  if (pathname.match(/^\/api\/admin\/registrations\/[^\/]+\/reject$/) && method === 'POST') {
    const id = pathname.split('/')[4];
    
    parseJSONBody(req, (error, data) => {
      if (error) {
        sendJSON(res, 400, {
          success: false,
          message: 'Invalid JSON data'
        });
        return;
      }

      const registration = registrations.find(r => r.id === id);
      if (!registration) {
        sendJSON(res, 404, {
          success: false,
          message: 'Registration not found'
        });
        return;
      }

      registration.status = 'rejected';
      registration.rejectedAt = new Date().toISOString();
      registration.rejectionReason = data.reason;

      updateStats();

      sendJSON(res, 200, {
        success: true,
        message: 'Registration rejected successfully',
        data: registration
      });
    });
    return;
  }

  // Get registration by ID
  if (pathname.match(/^\/api\/admin\/registrations\/[^\/]+$/) && method === 'GET') {
    const id = pathname.split('/')[4];
    const registration = registrations.find(r => r.id === id);

    if (!registration) {
      sendJSON(res, 404, {
        success: false,
        message: 'Registration not found'
      });
      return;
    }

    sendJSON(res, 200, {
      success: true,
      data: registration
    });
    return;
  }

  // 404 handler
  sendJSON(res, 404, {
    success: false,
    message: 'API endpoint not found',
    path: pathname,
    method: method
  });
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`🚀 KaziApp Backend Server running on http://localhost:${PORT}`);
  console.log(`📊 Admin dashboard: http://localhost:8092`);
  console.log(`📱 Service provider app: http://localhost:8091`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📋 Available endpoints:`);
  console.log(`   GET  /api/health`);
  console.log(`   POST /api/service-provider/register`);
  console.log(`   GET  /api/admin/registrations`);
  console.log(`   GET  /api/admin/registrations/pending`);
  console.log(`   GET  /api/admin/registrations/statistics`);
  console.log(`   POST /api/admin/registrations/:id/approve`);
  console.log(`   POST /api/admin/registrations/:id/reject`);
  console.log(`   GET  /api/admin/registrations/:id`);
  console.log(`\n✅ Backend is ready to handle registration requests!`);
});
