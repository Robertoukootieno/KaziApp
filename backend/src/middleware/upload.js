const multer = require('multer');
const path = require('path');
const fs = require('fs');
const sharp = require('sharp');
const { v4: uuidv4 } = require('uuid');
const logger = require('../config/logger');

// Create uploads directory if it doesn't exist
const uploadsDir = path.join(__dirname, '../../uploads');
const documentsDir = path.join(uploadsDir, 'documents');
const imagesDir = path.join(uploadsDir, 'images');

[uploadsDir, documentsDir, imagesDir].forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

// Configure storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Determine destination based on file type
    const isImage = file.mimetype.startsWith('image/');
    const destination = isImage ? imagesDir : documentsDir;
    cb(null, destination);
  },
  filename: (req, file, cb) => {
    // Generate unique filename
    const uniqueSuffix = `${Date.now()}-${uuidv4()}`;
    const extension = path.extname(file.originalname);
    const filename = `${file.fieldname}-${uniqueSuffix}${extension}`;
    cb(null, filename);
  }
});

// File filter function
const fileFilter = (req, file, cb) => {
  // Allowed file types
  const allowedTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'image/webp',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ];
  
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error(`File type ${file.mimetype} is not allowed`), false);
  }
};

// Configure multer
const upload = multer({
  storage: storage,
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 10 * 1024 * 1024, // 10MB default
    files: 10 // Maximum 10 files per request
  },
  fileFilter: fileFilter
});

// Middleware for handling registration documents
const uploadRegistrationDocuments = upload.fields([
  { name: 'businessLicense', maxCount: 1 },
  { name: 'businessLogo', maxCount: 1 },
  { name: 'idCopy', maxCount: 1 },
  { name: 'taxCertificate', maxCount: 1 },
  { name: 'insuranceCertificate', maxCount: 1 },
  { name: 'bankStatement', maxCount: 1 }
]);

// Middleware for processing uploaded images
const processImages = async (req, res, next) => {
  try {
    if (!req.files) {
      return next();
    }
    
    const processedFiles = {};
    
    for (const [fieldName, files] of Object.entries(req.files)) {
      processedFiles[fieldName] = [];
      
      for (const file of files) {
        if (file.mimetype.startsWith('image/')) {
          try {
            // Process image with Sharp
            const processedPath = path.join(
              path.dirname(file.path),
              `processed-${path.basename(file.path, path.extname(file.path))}.webp`
            );
            
            await sharp(file.path)
              .resize(1920, 1080, { 
                fit: 'inside',
                withoutEnlargement: true 
              })
              .webp({ quality: 85 })
              .toFile(processedPath);
            
            // Update file info
            file.processedPath = processedPath;
            file.processedMimeType = 'image/webp';
            
            logger.info(`Image processed: ${file.originalname}`);
          } catch (error) {
            logger.error(`Image processing failed for ${file.originalname}:`, error);
            // Continue without processing if Sharp fails
          }
        }
        
        processedFiles[fieldName].push(file);
      }
    }
    
    req.files = processedFiles;
    next();
  } catch (error) {
    logger.error('Image processing middleware error:', error);
    next(error);
  }
};

// Error handling middleware for multer
const handleUploadError = (error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    switch (error.code) {
      case 'LIMIT_FILE_SIZE':
        return res.status(400).json({
          success: false,
          message: `File too large. Maximum size is ${Math.round((parseInt(process.env.MAX_FILE_SIZE) || 10485760) / 1024 / 1024)}MB.`
        });
      
      case 'LIMIT_FILE_COUNT':
        return res.status(400).json({
          success: false,
          message: 'Too many files uploaded.'
        });
      
      case 'LIMIT_UNEXPECTED_FILE':
        return res.status(400).json({
          success: false,
          message: 'Unexpected file field.'
        });
      
      default:
        return res.status(400).json({
          success: false,
          message: 'File upload error.',
          error: error.message
        });
    }
  }
  
  if (error.message.includes('File type') && error.message.includes('not allowed')) {
    return res.status(400).json({
      success: false,
      message: error.message
    });
  }
  
  next(error);
};

// Utility function to delete uploaded files
const deleteUploadedFiles = (files) => {
  if (!files) return;
  
  const filesToDelete = [];
  
  if (Array.isArray(files)) {
    filesToDelete.push(...files);
  } else if (typeof files === 'object') {
    Object.values(files).forEach(fileArray => {
      if (Array.isArray(fileArray)) {
        filesToDelete.push(...fileArray);
      }
    });
  }
  
  filesToDelete.forEach(file => {
    try {
      if (fs.existsSync(file.path)) {
        fs.unlinkSync(file.path);
      }
      if (file.processedPath && fs.existsSync(file.processedPath)) {
        fs.unlinkSync(file.processedPath);
      }
    } catch (error) {
      logger.error(`Failed to delete file ${file.path}:`, error);
    }
  });
};

// Middleware to clean up files on error
const cleanupOnError = (req, res, next) => {
  const originalSend = res.send;
  
  res.send = function(data) {
    if (res.statusCode >= 400 && req.files) {
      deleteUploadedFiles(req.files);
    }
    originalSend.call(this, data);
  };
  
  next();
};

module.exports = {
  upload,
  uploadRegistrationDocuments,
  processImages,
  handleUploadError,
  deleteUploadedFiles,
  cleanupOnError,
  uploadsDir,
  documentsDir,
  imagesDir
};
