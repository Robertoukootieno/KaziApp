const request = require('supertest');
const app = require('../src/app');
const { describe, it, expect, beforeAll, afterAll, beforeEach } = require('@jest/globals');

describe('Authentication API Integration Tests', () => {
  let server;
  let testUser;

  beforeAll(async () => {
    // Start test server
    server = app.listen(0);
    
    // Test user data
    testUser = {
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+254712345678',
      email: 'john.doe.test@example.com',
      password: 'TestPassword123!@#',
      confirmPassword: 'TestPassword123!@#',
      county: 'Nairobi',
      subCounty: 'Westlands',
      ward: 'Parklands',
      farmSize: '2',
      primaryCrop: 'Maize',
      farmingExperience: '5',
      clientType: 'farmer'
    };
  });

  afterAll(async () => {
    if (server) {
      await new Promise((resolve) => server.close(resolve));
    }
  });

  describe('POST /auth/register', () => {
    it('should register a new user successfully', async () => {
      const response = await request(app)
        .post('/auth/register')
        .send(testUser)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data.user).toBeDefined();
      expect(response.body.data.user.firstName).toBe(testUser.firstName);
      expect(response.body.data.user.email).toBe(testUser.email);
      expect(response.body.data.user.emailVerified).toBe(false);
    });

    it('should fail registration with weak password', async () => {
      const weakPasswordUser = {
        ...testUser,
        email: 'weak.password@example.com',
        password: 'weak',
        confirmPassword: 'weak'
      };

      const response = await request(app)
        .post('/auth/register')
        .send(weakPasswordUser)
        .expect(400);

      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('14 characters');
    });

    it('should fail registration with mismatched passwords', async () => {
      const mismatchedUser = {
        ...testUser,
        email: 'mismatched@example.com',
        confirmPassword: 'DifferentPassword123!@#'
      };

      const response = await request(app)
        .post('/auth/register')
        .send(mismatchedUser)
        .expect(400);

      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('match');
    });

    it('should fail registration with invalid email', async () => {
      const invalidEmailUser = {
        ...testUser,
        email: 'invalid-email'
      };

      const response = await request(app)
        .post('/auth/register')
        .send(invalidEmailUser)
        .expect(400);

      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('email');
    });

    it('should fail registration with duplicate phone number', async () => {
      // First registration should succeed
      await request(app)
        .post('/auth/register')
        .send({
          ...testUser,
          email: 'first@example.com'
        })
        .expect(201);

      // Second registration with same phone should fail
      const response = await request(app)
        .post('/auth/register')
        .send({
          ...testUser,
          email: 'second@example.com'
        })
        .expect(409);

      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('already exists');
    });
  });

  describe('POST /auth/login', () => {
    beforeEach(async () => {
      // Register a test user before each login test
      await request(app)
        .post('/auth/register')
        .send({
          ...testUser,
          email: `login.test.${Date.now()}@example.com`
        });
    });

    it('should login successfully with valid credentials', async () => {
      const response = await request(app)
        .post('/auth/login')
        .send({
          username: testUser.phoneNumber,
          password: testUser.password,
          clientType: 'farmer'
        })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.tokens).toBeDefined();
      expect(response.body.data.tokens.access_token).toBeDefined();
      expect(response.body.data.tokens.refresh_token).toBeDefined();
      expect(response.body.data.user).toBeDefined();
    });

    it('should fail login with invalid password', async () => {
      const response = await request(app)
        .post('/auth/login')
        .send({
          username: testUser.phoneNumber,
          password: 'WrongPassword123!@#',
          clientType: 'farmer'
        })
        .expect(401);

      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('Invalid');
    });

    it('should fail login with non-existent user', async () => {
      const response = await request(app)
        .post('/auth/login')
        .send({
          username: '+254700000000',
          password: testUser.password,
          clientType: 'farmer'
        })
        .expect(401);

      expect(response.body.success).toBe(false);
    });

    it('should validate required fields', async () => {
      const response = await request(app)
        .post('/auth/login')
        .send({
          username: testUser.phoneNumber
          // Missing password
        })
        .expect(400);

      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('required');
    });
  });

  describe('POST /auth/forgot-password', () => {
    it('should send forgot password email for existing user', async () => {
      // Register user first
      await request(app)
        .post('/auth/register')
        .send({
          ...testUser,
          email: 'forgot.password@example.com'
        });

      const response = await request(app)
        .post('/auth/forgot-password')
        .send({
          username: testUser.phoneNumber,
          clientType: 'farmer'
        })
        .expect(200);

      expect(response.body.success).toBe(true);
    });

    it('should handle non-existent user gracefully', async () => {
      const response = await request(app)
        .post('/auth/forgot-password')
        .send({
          username: '+254700000000',
          clientType: 'farmer'
        })
        .expect(200); // Should still return success for security

      expect(response.body.success).toBe(true);
    });
  });

  describe('POST /auth/verify-email', () => {
    it('should verify email with valid code', async () => {
      // This would require mocking the verification code generation
      // For now, test the endpoint structure
      const response = await request(app)
        .post('/auth/verify-email')
        .send({
          username: testUser.phoneNumber,
          verificationCode: '123456'
        });

      // Should return either success or failure, not server error
      expect([200, 400, 401]).toContain(response.status);
      expect(response.body.success).toBeDefined();
    });
  });

  describe('POST /auth/refresh', () => {
    let refreshToken;

    beforeEach(async () => {
      // Register and login to get refresh token
      await request(app)
        .post('/auth/register')
        .send({
          ...testUser,
          email: `refresh.test.${Date.now()}@example.com`
        });

      const loginResponse = await request(app)
        .post('/auth/login')
        .send({
          username: testUser.phoneNumber,
          password: testUser.password,
          clientType: 'farmer'
        });

      refreshToken = loginResponse.body.data.tokens.refresh_token;
    });

    it('should refresh tokens with valid refresh token', async () => {
      const response = await request(app)
        .post('/auth/refresh')
        .send({
          refreshToken: refreshToken
        })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.tokens).toBeDefined();
      expect(response.body.data.tokens.access_token).toBeDefined();
    });

    it('should fail with invalid refresh token', async () => {
      const response = await request(app)
        .post('/auth/refresh')
        .send({
          refreshToken: 'invalid_token'
        })
        .expect(401);

      expect(response.body.success).toBe(false);
    });
  });

  describe('SSO Endpoints', () => {
    it('should return Google OAuth URL', async () => {
      const response = await request(app)
        .get('/auth/sso/google/url')
        .query({ clientType: 'farmer' })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.authUrl).toBeDefined();
      expect(response.body.data.authUrl).toContain('google');
    });

    it('should return Facebook OAuth URL', async () => {
      const response = await request(app)
        .get('/auth/sso/facebook/url')
        .query({ clientType: 'farmer' })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.authUrl).toBeDefined();
      expect(response.body.data.authUrl).toContain('facebook');
    });

    it('should return Microsoft OAuth URL', async () => {
      const response = await request(app)
        .get('/auth/sso/microsoft/url')
        .query({ clientType: 'farmer' })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.authUrl).toBeDefined();
      expect(response.body.data.authUrl).toContain('microsoft');
    });
  });

  describe('Security Tests', () => {
    it('should rate limit login attempts', async () => {
      const loginData = {
        username: '+254700000000',
        password: 'WrongPassword123!@#',
        clientType: 'farmer'
      };

      // Make multiple failed login attempts
      const promises = Array(10).fill().map(() =>
        request(app)
          .post('/auth/login')
          .send(loginData)
      );

      const responses = await Promise.all(promises);
      
      // Some requests should be rate limited
      const rateLimitedResponses = responses.filter(r => r.status === 429);
      expect(rateLimitedResponses.length).toBeGreaterThan(0);
    });

    it('should validate input sanitization', async () => {
      const maliciousData = {
        firstName: '<script>alert("xss")</script>',
        lastName: 'DROP TABLE users;',
        phoneNumber: '+254712345678',
        email: 'test@example.com',
        password: 'TestPassword123!@#',
        confirmPassword: 'TestPassword123!@#',
        county: 'Nairobi',
        subCounty: 'Westlands',
        ward: 'Parklands',
        farmSize: '2',
        primaryCrop: 'Maize',
        farmingExperience: '5',
        clientType: 'farmer'
      };

      const response = await request(app)
        .post('/auth/register')
        .send(maliciousData);

      // Should either sanitize or reject malicious input
      if (response.status === 201) {
        expect(response.body.data.user.firstName).not.toContain('<script>');
        expect(response.body.data.user.lastName).not.toContain('DROP TABLE');
      } else {
        expect(response.status).toBe(400);
      }
    });
  });
});
