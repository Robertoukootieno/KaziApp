import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Real-time Communication Service for SMS and Email
class CommunicationService {
  static final CommunicationService _instance = CommunicationService._internal();
  factory CommunicationService() => _instance;
  CommunicationService._internal();

  late Dio _dio;
  bool _isInitialized = false;

  // Configuration
  static const String _baseUrl = 'https://api.kaziapp.com'; // Replace with your API
  static const String _smsApiKey = 'your_sms_api_key'; // Replace with actual API key
  static const String _emailApiKey = 'your_email_api_key'; // Replace with actual API key
  
  // SMS Provider Configuration (using Africa's Talking as example)
  static const String _smsProvider = 'africas_talking';
  static const String _smsUsername = 'kaziapp'; // Replace with your username
  static const String _smsSender = 'KAZIAPP'; // Replace with your sender ID
  
  // Email Provider Configuration (using SendGrid as example)
  static const String _emailProvider = 'sendgrid';
  static const String _emailFrom = 'noreply@kaziapp.com'; // Replace with your email
  static const String _emailFromName = 'KaziApp Mkulima';

  /// Initialize the communication service
  Future<void> initialize() async {
    try {
      _dio = Dio();
      _dio.options.baseUrl = _baseUrl;
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);
      
      // Add interceptors for logging and error handling
      _dio.interceptors.add(LogInterceptor(
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        logPrint: (obj) => debugPrint('📡 Communication API: $obj'),
      ));
      
      _isInitialized = true;
      debugPrint('📱 Communication Service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Communication Service: $e');
      throw Exception('Failed to initialize communication service: $e');
    }
  }

  /// Send SMS verification code
  Future<SmsResult> sendSmsVerification({
    required String phoneNumber,
    required String verificationCode,
    String? userName,
  }) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Format phone number for international sending
      final formattedPhone = _formatPhoneNumber(phoneNumber);
      
      // Create personalized message
      final message = _buildSmsMessage(verificationCode, userName);
      
      debugPrint('📱 Sending SMS to $formattedPhone: $message');
      
      // Send via your preferred SMS provider
      final result = await _sendViaSmsProvider(formattedPhone, message);
      
      if (result.success) {
        debugPrint('✅ SMS sent successfully to $formattedPhone');
        return SmsResult.success(
          messageId: result.messageId ?? 'unknown_sms_id',
          message: 'Verification code sent successfully',
        );
      } else {
        debugPrint('❌ SMS sending failed: ${result.error}');
        return SmsResult.failure(result.error ?? 'Failed to send SMS');
      }
    } catch (e) {
      debugPrint('❌ SMS sending error: $e');
      return SmsResult.failure('SMS sending error: $e');
    }
  }

  /// Send email verification
  Future<EmailResult> sendEmailVerification({
    required String email,
    required String verificationCode,
    String? userName,
  }) async {
    if (!_isInitialized) await initialize();
    
    try {
      debugPrint('📧 Sending email verification to $email');
      
      // Create personalized email content
      final emailContent = _buildEmailContent(verificationCode, userName);
      
      // Send via your preferred email provider
      final result = await _sendViaEmailProvider(
        email,
        'KaziApp Registration - Verify Your Email',
        emailContent,
      );
      
      if (result.success) {
        debugPrint('✅ Email sent successfully to $email');
        return EmailResult.success(
          messageId: result.messageId ?? 'unknown_email_id',
          message: 'Verification email sent successfully',
        );
      } else {
        debugPrint('❌ Email sending failed: ${result.error}');
        return EmailResult.failure(result.error ?? 'Failed to send email');
      }
    } catch (e) {
      debugPrint('❌ Email sending error: $e');
      return EmailResult.failure('Email sending error: $e');
    }
  }

  /// Send welcome SMS after successful registration
  Future<SmsResult> sendWelcomeSms({
    required String phoneNumber,
    required String userName,
  }) async {
    if (!_isInitialized) await initialize();
    
    try {
      final formattedPhone = _formatPhoneNumber(phoneNumber);
      final message = _buildWelcomeSmsMessage(userName);
      
      debugPrint('📱 Sending welcome SMS to $formattedPhone');
      
      final result = await _sendViaSmsProvider(formattedPhone, message);
      
      if (result.success) {
        debugPrint('✅ Welcome SMS sent successfully');
        return SmsResult.success(
          messageId: result.messageId ?? 'unknown_welcome_sms_id',
          message: 'Welcome SMS sent successfully',
        );
      } else {
        return SmsResult.failure(result.error ?? 'Failed to send welcome SMS');
      }
    } catch (e) {
      debugPrint('❌ Welcome SMS error: $e');
      return SmsResult.failure('Welcome SMS error: $e');
    }
  }

  /// Send welcome email after successful registration
  Future<EmailResult> sendWelcomeEmail({
    required String email,
    required String userName,
  }) async {
    if (!_isInitialized) await initialize();
    
    try {
      debugPrint('📧 Sending welcome email to $email');
      
      final emailContent = _buildWelcomeEmailContent(userName);
      
      final result = await _sendViaEmailProvider(
        email,
        'Welcome to KaziApp Mkulima! 🌱',
        emailContent,
      );
      
      if (result.success) {
        debugPrint('✅ Welcome email sent successfully');
        return EmailResult.success(
          messageId: result.messageId ?? 'unknown_welcome_email_id',
          message: 'Welcome email sent successfully',
        );
      } else {
        return EmailResult.failure(result.error ?? 'Failed to send welcome email');
      }
    } catch (e) {
      debugPrint('❌ Welcome email error: $e');
      return EmailResult.failure('Welcome email error: $e');
    }
  }

  // Private helper methods
  String _formatPhoneNumber(String phoneNumber) {
    // Ensure phone number is in international format
    if (phoneNumber.startsWith('+')) {
      return phoneNumber;
    } else if (phoneNumber.startsWith('0')) {
      return '+254${phoneNumber.substring(1)}';
    } else if (phoneNumber.startsWith('254')) {
      return '+$phoneNumber';
    } else {
      return '+254$phoneNumber';
    }
  }

  String _buildSmsMessage(String code, String? userName) {
    final greeting = userName != null ? 'Hi $userName, ' : 'Hello, ';
    return '$greeting'
           'Your KaziApp verification code is: $code. '
           'This code expires in 10 minutes. '
           'Do not share this code with anyone. - KaziApp Team';
  }

  String _buildWelcomeSmsMessage(String userName) {
    return 'Welcome to KaziApp Mkulima, $userName! 🌱 '
           'Your account is now active with enterprise-grade security. '
           'Start connecting with farmers, experts, and grow your agricultural business. '
           'Download our app: https://kaziapp.com/download';
  }

  EmailContent _buildEmailContent(String code, String? userName) {
    final greeting = userName != null ? 'Hi $userName' : 'Hello';
    
    final htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>KaziApp Email Verification</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: linear-gradient(135deg, #2E7D32, #4CAF50); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
            .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
            .code-box { background: #fff; border: 2px solid #4CAF50; border-radius: 8px; padding: 20px; text-align: center; margin: 20px 0; }
            .code { font-size: 32px; font-weight: bold; color: #2E7D32; letter-spacing: 5px; }
            .footer { text-align: center; margin-top: 20px; color: #666; font-size: 14px; }
            .security-badge { background: #E3F2FD; border-left: 4px solid #2196F3; padding: 15px; margin: 20px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🌱 KaziApp Mkulima</h1>
                <p>Email Verification Required</p>
            </div>
            <div class="content">
                <h2>$greeting,</h2>
                <p>Thank you for registering with KaziApp Mkulima! To complete your registration and activate your account, please verify your email address.</p>
                
                <div class="code-box">
                    <p>Your verification code is:</p>
                    <div class="code">$code</div>
                    <p><small>This code expires in 10 minutes</small></p>
                </div>
                
                <div class="security-badge">
                    <strong>🔐 Enterprise Security Active</strong><br>
                    Your account is protected with advanced encryption, behavioral biometrics, and zero-trust authentication.
                </div>
                
                <p><strong>Important Security Notes:</strong></p>
                <ul>
                    <li>Never share this verification code with anyone</li>
                    <li>KaziApp will never ask for your code via phone or email</li>
                    <li>If you didn't request this verification, please ignore this email</li>
                </ul>
                
                <p>Once verified, you'll have access to:</p>
                <ul>
                    <li>🌾 Connect with agricultural experts</li>
                    <li>🚜 Book machinery and equipment</li>
                    <li>📊 AI-powered crop diagnosis</li>
                    <li>💰 Access to agricultural marketplace</li>
                    <li>🔒 Enterprise-grade security protection</li>
                </ul>
            </div>
            <div class="footer">
                <p>Best regards,<br>The KaziApp Team</p>
                <p><small>This is an automated message. Please do not reply to this email.</small></p>
            </div>
        </div>
    </body>
    </html>
    ''';

    final textContent = '''
    $greeting,
    
    Thank you for registering with KaziApp Mkulima!
    
    Your verification code is: $code
    This code expires in 10 minutes.
    
    🔐 Enterprise Security Active
    Your account is protected with advanced encryption, behavioral biometrics, and zero-trust authentication.
    
    Important Security Notes:
    - Never share this verification code with anyone
    - KaziApp will never ask for your code via phone or email
    - If you didn't request this verification, please ignore this email
    
    Best regards,
    The KaziApp Team
    ''';

    return EmailContent(
      htmlContent: htmlContent,
      textContent: textContent,
    );
  }

  // SMS Provider Implementation
  Future<ProviderResult> _sendViaSmsProvider(String phoneNumber, String message) async {
    // In development mode, skip real API calls and go directly to simulation
    if (kDebugMode) {
      debugPrint('🔧 Development Mode: Simulating real-time SMS sending...');
      debugPrint('📱 Sending SMS to: $phoneNumber');
      debugPrint('💬 Message: $message');

      // Simulate realistic network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Simulate 95% success rate for better testing experience
      final random = Random();
      if (random.nextDouble() < 0.95) {
        final messageId = 'sim_sms_${DateTime.now().millisecondsSinceEpoch}';
        debugPrint('✅ [SIMULATED] SMS sent successfully!');
        debugPrint('📋 Message ID: $messageId');
        return ProviderResult.success(messageId: messageId);
      } else {
        debugPrint('❌ [SIMULATED] SMS sending failed (5% failure rate for testing)');
        return ProviderResult.failure('Simulated SMS failure for testing');
      }
    }

    // Production mode: Real API implementation
    try {
      // Example implementation for Africa's Talking SMS API
      final response = await _dio.post(
        '/sms/send',
        data: {
          'provider': _smsProvider,
          'username': _smsUsername,
          'apiKey': _smsApiKey,
          'to': phoneNumber,
          'message': message,
          'from': _smsSender,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return ProviderResult.success(
          messageId: response.data['data']['messageId'] ?? 'sms_${DateTime.now().millisecondsSinceEpoch}',
        );
      } else {
        return ProviderResult.failure(
          response.data['error'] ?? 'SMS provider error',
        );
      }
    } catch (e) {
      debugPrint('❌ SMS Provider Error: $e');

      // Fallback to simulation for development
      if (kDebugMode) {
        debugPrint('🔧 Development Mode: Simulating real-time SMS sending...');
        debugPrint('📱 Sending SMS to: $phoneNumber');
        debugPrint('💬 Message: $message');

        // Simulate realistic network delay
        await Future.delayed(const Duration(milliseconds: 1500));

        // Simulate 95% success rate for better testing experience
        final random = Random();
        if (random.nextDouble() < 0.95) {
          final messageId = 'sim_sms_${DateTime.now().millisecondsSinceEpoch}';
          debugPrint('✅ [SIMULATED] SMS sent successfully!');
          debugPrint('📋 Message ID: $messageId');
          return ProviderResult.success(messageId: messageId);
        } else {
          debugPrint('❌ [SIMULATED] SMS sending failed (simulated network error)');
          return ProviderResult.failure('Simulated network error');
        }
      }

      return ProviderResult.failure('SMS sending failed: $e');
    }
  }

  // Email Provider Implementation
  Future<ProviderResult> _sendViaEmailProvider(
    String email,
    String subject,
    EmailContent content,
  ) async {
    // In development mode, skip real API calls and go directly to simulation
    if (kDebugMode) {
      debugPrint('🔧 Development Mode: Simulating real-time email sending...');
      debugPrint('📧 Sending email to: $email');
      debugPrint('📋 Subject: $subject');
      debugPrint('💌 Content preview: ${content.textContent.substring(0, 100)}...');

      // Simulate realistic network delay
      await Future.delayed(const Duration(milliseconds: 2000));

      // Simulate 97% success rate for better testing experience
      final random = Random();
      if (random.nextDouble() < 0.97) {
        final messageId = 'sim_email_${DateTime.now().millisecondsSinceEpoch}';
        debugPrint('✅ [SIMULATED] Email sent successfully!');
        debugPrint('📋 Message ID: $messageId');
        return ProviderResult.success(messageId: messageId);
      } else {
        debugPrint('❌ [SIMULATED] Email sending failed (3% failure rate for testing)');
        return ProviderResult.failure('Simulated email failure for testing');
      }
    }

    // Production mode: Real API implementation
    try {
      // Example implementation for SendGrid Email API
      final response = await _dio.post(
        '/email/send',
        data: {
          'provider': _emailProvider,
          'apiKey': _emailApiKey,
          'from': {
            'email': _emailFrom,
            'name': _emailFromName,
          },
          'to': [
            {'email': email}
          ],
          'subject': subject,
          'content': [
            {
              'type': 'text/plain',
              'value': content.textContent,
            },
            {
              'type': 'text/html',
              'value': content.htmlContent,
            },
          ],
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return ProviderResult.success(
          messageId: response.data['data']['messageId'] ?? 'email_${DateTime.now().millisecondsSinceEpoch}',
        );
      } else {
        return ProviderResult.failure(
          response.data['error'] ?? 'Email provider error',
        );
      }
    } catch (e) {
      debugPrint('❌ Email Provider Error: $e');

      // Fallback to simulation for development
      if (kDebugMode) {
        debugPrint('🔧 Development Mode: Simulating real-time email sending...');
        debugPrint('📧 Sending email to: $email');
        debugPrint('📋 Subject: $subject');
        debugPrint('💌 Content preview: ${content.textContent.substring(0, 100)}...');

        // Simulate realistic network delay
        await Future.delayed(const Duration(milliseconds: 2000));

        // Simulate 97% success rate for better testing experience
        final random = Random();
        if (random.nextDouble() < 0.97) {
          final messageId = 'sim_email_${DateTime.now().millisecondsSinceEpoch}';
          debugPrint('✅ [SIMULATED] Email sent successfully!');
          debugPrint('📋 Message ID: $messageId');
          return ProviderResult.success(messageId: messageId);
        } else {
          debugPrint('❌ [SIMULATED] Email sending failed (simulated network error)');
          return ProviderResult.failure('Simulated network error');
        }
      }

      return ProviderResult.failure('Email sending failed: $e');
    }
  }
}

// Result classes
class SmsResult {
  final bool success;
  final String? messageId;
  final String? message;
  final String? error;

  SmsResult._({
    required this.success,
    this.messageId,
    this.message,
    this.error,
  });

  factory SmsResult.success({
    required String messageId,
    required String message,
  }) {
    return SmsResult._(
      success: true,
      messageId: messageId,
      message: message,
    );
  }

  factory SmsResult.failure(String error) {
    return SmsResult._(
      success: false,
      error: error,
    );
  }
}

class EmailResult {
  final bool success;
  final String? messageId;
  final String? message;
  final String? error;

  EmailResult._({
    required this.success,
    this.messageId,
    this.message,
    this.error,
  });

  factory EmailResult.success({
    required String messageId,
    required String message,
  }) {
    return EmailResult._(
      success: true,
      messageId: messageId,
      message: message,
    );
  }

  factory EmailResult.failure(String error) {
    return EmailResult._(
      success: false,
      error: error,
    );
  }
}

class ProviderResult {
  final bool success;
  final String? messageId;
  final String? error;

  ProviderResult._({
    required this.success,
    this.messageId,
    this.error,
  });

  factory ProviderResult.success({required String messageId}) {
    return ProviderResult._(success: true, messageId: messageId);
  }

  factory ProviderResult.failure(String error) {
    return ProviderResult._(success: false, error: error);
  }
}

class EmailContent {
  final String htmlContent;
  final String textContent;

  EmailContent({
    required this.htmlContent,
    required this.textContent,
  });
}

  EmailContent _buildWelcomeEmailContent(String userName) {
    final htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Welcome to KaziApp Mkulima</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: linear-gradient(135deg, #2E7D32, #4CAF50); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
            .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
            .feature-box { background: #fff; border-radius: 8px; padding: 20px; margin: 15px 0; border-left: 4px solid #4CAF50; }
            .cta-button { background: #4CAF50; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; display: inline-block; margin: 20px 0; }
            .footer { text-align: center; margin-top: 20px; color: #666; font-size: 14px; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🌱 Welcome to KaziApp Mkulima!</h1>
                <p>Your Agricultural Journey Starts Here</p>
            </div>
            <div class="content">
                <h2>Hi $userName,</h2>
                <p>Congratulations! Your KaziApp Mkulima account is now active with enterprise-grade security protection.</p>
                
                <div class="feature-box">
                    <h3>🔒 Your Security Level: 95%</h3>
                    <p>Your account is protected with advanced encryption, behavioral biometrics, and zero-trust authentication.</p>
                </div>
                
                <h3>What's Next?</h3>
                <div class="feature-box">
                    <h4>🌾 Connect with Experts</h4>
                    <p>Get advice from agricultural professionals and experienced farmers.</p>
                </div>
                
                <div class="feature-box">
                    <h4>🚜 Book Equipment</h4>
                    <p>Access modern farming machinery and equipment when you need it.</p>
                </div>
                
                <div class="feature-box">
                    <h4>📊 AI Diagnosis</h4>
                    <p>Use our AI-powered tools to diagnose crop and livestock issues.</p>
                </div>
                
                <div class="feature-box">
                    <h4>💰 Marketplace Access</h4>
                    <p>Buy and sell agricultural products in our secure marketplace.</p>
                </div>
                
                <a href="https://kaziapp.com/dashboard" class="cta-button">Start Your Journey</a>
                
                <p>Need help? Our support team is here for you 24/7 at support@kaziapp.com</p>
            </div>
            <div class="footer">
                <p>Happy Farming!<br>The KaziApp Team 🌱</p>
            </div>
        </div>
    </body>
    </html>
    ''';

    final textContent = '''
    Welcome to KaziApp Mkulima, $userName! 🌱
    
    Congratulations! Your account is now active with enterprise-grade security protection.
    
    🔒 Your Security Level: 95%
    Your account is protected with advanced encryption, behavioral biometrics, and zero-trust authentication.
    
    What's Next?
    🌾 Connect with agricultural experts and experienced farmers
    🚜 Access modern farming machinery and equipment
    📊 Use AI-powered crop and livestock diagnosis
    💰 Buy and sell in our secure marketplace
    
    Start your journey: https://kaziapp.com/dashboard
    
    Need help? Contact us at support@kaziapp.com
    
    Happy Farming!
    The KaziApp Team 🌱
    ''';

    return EmailContent(
      htmlContent: htmlContent,
      textContent: textContent,
    );
  }
