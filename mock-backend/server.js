const express = require('express');
const cors = require('cors');
const multer = require('multer');
const { Server } = require('socket.io');
const http = require('http');
const { v4: uuidv4 } = require('uuid');
const bodyParser = require('body-parser');
const path = require('path');
const fs = require('fs');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: ["http://localhost:8091", "http://localhost:8092"],
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true
  }
});

const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: ["http://localhost:8091", "http://localhost:8092"],
  credentials: true
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Create uploads directory if it doesn't exist
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadsDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB limit
  },
  fileFilter: (req, file, cb) => {
    // Accept images and PDFs
    if (file.mimetype.startsWith('image/') || file.mimetype === 'application/pdf') {
      cb(null, true);
    } else {
      cb(new Error('Only images and PDF files are allowed!'), false);
    }
  }
});

// In-memory storage for demo purposes
let registrations = [];
let registrationStats = {
  total: 0,
  pending: 0,
  approved: 0,
  rejected: 0
};

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('Client connected:', socket.id);
  
  // Join admin room for notifications
  socket.on('join-admin', () => {
    socket.join('admin-room');
    console.log('Admin joined room:', socket.id);
  });
  
  // Handle disconnection
  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

// Helper function to update stats
function updateStats() {
  registrationStats.total = registrations.length;
  registrationStats.pending = registrations.filter(r => r.status === 'pending').length;
  registrationStats.approved = registrations.filter(r => r.status === 'approved').length;
  registrationStats.rejected = registrations.filter(r => r.status === 'rejected').length;
}

// API Routes

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'KaziApp Mock Backend is running' });
});

// Service Provider Registration
app.post('/api/service-provider/register', upload.fields([
  { name: 'businessLicense', maxCount: 1 },
  { name: 'businessLogo', maxCount: 1 },
  { name: 'idCopy', maxCount: 1 }
]), (req, res) => {
  try {
    console.log('Registration request received:', req.body);
    console.log('Files uploaded:', req.files);
    
    const registrationData = {
      id: uuidv4(),
      businessName: req.body.businessName,
      ownerName: req.body.ownerName,
      email: req.body.email,
      phone: req.body.phone,
      location: req.body.location,
      serviceType: req.body.serviceType,
      description: req.body.description,
      status: 'pending',
      submittedAt: new Date().toISOString(),
      documents: []
    };
    
    // Process uploaded files
    if (req.files) {
      if (req.files.businessLicense) {
        registrationData.documents.push({
          id: uuidv4(),
          type: 'business_license',
          filename: req.files.businessLicense[0].filename,
          originalName: req.files.businessLicense[0].originalname,
          path: req.files.businessLicense[0].path,
          status: 'pending'
        });
      }
      
      if (req.files.businessLogo) {
        registrationData.documents.push({
          id: uuidv4(),
          type: 'business_logo',
          filename: req.files.businessLogo[0].filename,
          originalName: req.files.businessLogo[0].originalname,
          path: req.files.businessLogo[0].path,
          status: 'pending'
        });
      }
      
      if (req.files.idCopy) {
        registrationData.documents.push({
          id: uuidv4(),
          type: 'id_copy',
          filename: req.files.idCopy[0].filename,
          originalName: req.files.idCopy[0].originalname,
          path: req.files.idCopy[0].path,
          status: 'pending'
        });
      }
    }
    
    // Add to registrations
    registrations.push(registrationData);
    updateStats();
    
    // Send real-time notification to admin
    io.to('admin-room').emit('registration_submitted', {
      type: 'registration_submitted',
      data: registrationData
    });
    
    console.log('Registration created:', registrationData.id);
    
    res.status(201).json({
      success: true,
      message: 'Registration submitted successfully',
      data: {
        id: registrationData.id,
        status: registrationData.status,
        submittedAt: registrationData.submittedAt
      }
    });
    
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to submit registration',
      error: error.message
    });
  }
});

// Get all registrations (for admin)
app.get('/api/admin/registrations', (req, res) => {
  const { status, serviceType, search, page = 1, limit = 10 } = req.query;
  
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
  const endIndex = startIndex + parseInt(limit);
  const paginatedResults = filteredRegistrations.slice(startIndex, endIndex);
  
  res.json({
    success: true,
    data: paginatedResults,
    pagination: {
      page: parseInt(page),
      limit: parseInt(limit),
      total: filteredRegistrations.length,
      totalPages: Math.ceil(filteredRegistrations.length / limit)
    }
  });
});

// Get pending registrations
app.get('/api/admin/registrations/pending', (req, res) => {
  const pendingRegistrations = registrations.filter(r => r.status === 'pending');
  res.json({
    success: true,
    data: pendingRegistrations
  });
});

// Get registration statistics
app.get('/api/admin/registrations/statistics', (req, res) => {
  updateStats();
  res.json({
    success: true,
    data: registrationStats
  });
});

// Approve registration
app.post('/api/admin/registrations/:id/approve', (req, res) => {
  const { id } = req.params;
  const { notes } = req.body;
  
  const registration = registrations.find(r => r.id === id);
  if (!registration) {
    return res.status(404).json({
      success: false,
      message: 'Registration not found'
    });
  }
  
  registration.status = 'approved';
  registration.approvedAt = new Date().toISOString();
  registration.approvalNotes = notes;
  
  updateStats();
  
  // Send real-time notification
  io.to('admin-room').emit('registration_updated', {
    type: 'registration_approved',
    data: registration
  });
  
  res.json({
    success: true,
    message: 'Registration approved successfully',
    data: registration
  });
});

// Reject registration
app.post('/api/admin/registrations/:id/reject', (req, res) => {
  const { id } = req.params;
  const { reason } = req.body;
  
  const registration = registrations.find(r => r.id === id);
  if (!registration) {
    return res.status(404).json({
      success: false,
      message: 'Registration not found'
    });
  }
  
  registration.status = 'rejected';
  registration.rejectedAt = new Date().toISOString();
  registration.rejectionReason = reason;
  
  updateStats();
  
  // Send real-time notification
  io.to('admin-room').emit('registration_updated', {
    type: 'registration_rejected',
    data: registration
  });
  
  res.json({
    success: true,
    message: 'Registration rejected successfully',
    data: registration
  });
});

// Get registration by ID
app.get('/api/admin/registrations/:id', (req, res) => {
  const { id } = req.params;
  const registration = registrations.find(r => r.id === id);
  
  if (!registration) {
    return res.status(404).json({
      success: false,
      message: 'Registration not found'
    });
  }
  
  res.json({
    success: true,
    data: registration
  });
});

// Serve uploaded files
app.use('/uploads', express.static(uploadsDir));

// Error handling middleware
app.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        success: false,
        message: 'File too large. Maximum size is 10MB.'
      });
    }
  }
  
  console.error('Server error:', error);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: error.message
  });
});

// Start server
server.listen(PORT, () => {
  console.log(`🚀 KaziApp Mock Backend Server running on http://localhost:${PORT}`);
  console.log(`📁 File uploads directory: ${uploadsDir}`);
  console.log(`🔌 WebSocket server ready for real-time communication`);
  console.log(`📊 Admin dashboard: http://localhost:8092`);
  console.log(`📱 Service provider app: http://localhost:8091`);
});
