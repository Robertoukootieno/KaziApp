// KaziApp MongoDB Initialization Script

// Switch to the kaziapp database
db = db.getSiblingDB('kaziapp');

// Create collections with validation schemas
db.createCollection('users', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['email', 'userType', 'createdAt'],
      properties: {
        email: {
          bsonType: 'string',
          pattern: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        },
        userType: {
          bsonType: 'string',
          enum: ['farmer', 'veterinarian', 'buyer', 'vendor', 'admin']
        },
        status: {
          bsonType: 'string',
          enum: ['active', 'inactive', 'suspended', 'pending_verification']
        },
        createdAt: {
          bsonType: 'date'
        },
        updatedAt: {
          bsonType: 'date'
        }
      }
    }
  }
});

db.createCollection('messages', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['senderId', 'recipientId', 'content', 'createdAt'],
      properties: {
        senderId: {
          bsonType: 'objectId'
        },
        recipientId: {
          bsonType: 'objectId'
        },
        content: {
          bsonType: 'string',
          minLength: 1,
          maxLength: 5000
        },
        messageType: {
          bsonType: 'string',
          enum: ['text', 'image', 'document', 'voice', 'video']
        },
        status: {
          bsonType: 'string',
          enum: ['sent', 'delivered', 'read']
        },
        createdAt: {
          bsonType: 'date'
        }
      }
    }
  }
});

db.createCollection('notifications', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['userId', 'title', 'message', 'createdAt'],
      properties: {
        userId: {
          bsonType: 'objectId'
        },
        title: {
          bsonType: 'string',
          minLength: 1,
          maxLength: 200
        },
        message: {
          bsonType: 'string',
          minLength: 1,
          maxLength: 1000
        },
        type: {
          bsonType: 'string',
          enum: ['info', 'warning', 'error', 'success']
        },
        isRead: {
          bsonType: 'bool'
        },
        createdAt: {
          bsonType: 'date'
        }
      }
    }
  }
});

db.createCollection('ai_diagnoses', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['userId', 'imageUrl', 'diagnosis', 'confidence', 'createdAt'],
      properties: {
        userId: {
          bsonType: 'objectId'
        },
        imageUrl: {
          bsonType: 'string'
        },
        diagnosis: {
          bsonType: 'string'
        },
        confidence: {
          bsonType: 'double',
          minimum: 0,
          maximum: 1
        },
        recommendations: {
          bsonType: 'array',
          items: {
            bsonType: 'string'
          }
        },
        createdAt: {
          bsonType: 'date'
        }
      }
    }
  }
});

db.createCollection('community_posts', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['authorId', 'title', 'content', 'createdAt'],
      properties: {
        authorId: {
          bsonType: 'objectId'
        },
        title: {
          bsonType: 'string',
          minLength: 1,
          maxLength: 200
        },
        content: {
          bsonType: 'string',
          minLength: 1,
          maxLength: 10000
        },
        tags: {
          bsonType: 'array',
          items: {
            bsonType: 'string'
          }
        },
        likes: {
          bsonType: 'int',
          minimum: 0
        },
        comments: {
          bsonType: 'int',
          minimum: 0
        },
        createdAt: {
          bsonType: 'date'
        },
        updatedAt: {
          bsonType: 'date'
        }
      }
    }
  }
});

// Create indexes for better performance
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ userType: 1 });
db.users.createIndex({ status: 1 });
db.users.createIndex({ createdAt: -1 });

db.messages.createIndex({ senderId: 1, recipientId: 1 });
db.messages.createIndex({ createdAt: -1 });
db.messages.createIndex({ status: 1 });

db.notifications.createIndex({ userId: 1 });
db.notifications.createIndex({ isRead: 1 });
db.notifications.createIndex({ createdAt: -1 });

db.ai_diagnoses.createIndex({ userId: 1 });
db.ai_diagnoses.createIndex({ createdAt: -1 });
db.ai_diagnoses.createIndex({ confidence: -1 });

db.community_posts.createIndex({ authorId: 1 });
db.community_posts.createIndex({ tags: 1 });
db.community_posts.createIndex({ createdAt: -1 });
db.community_posts.createIndex({ likes: -1 });

// Create text indexes for search functionality
db.community_posts.createIndex({ 
  title: 'text', 
  content: 'text', 
  tags: 'text' 
});

db.users.createIndex({ 
  'profile.firstName': 'text', 
  'profile.lastName': 'text',
  'profile.businessName': 'text'
});

print('MongoDB initialization completed successfully');
print('Collections created: users, messages, notifications, ai_diagnoses, community_posts');
print('Indexes created for optimal performance');
print('Text search indexes enabled for users and community posts');
