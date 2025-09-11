import 'package:flutter_test/flutter_test.dart';
import 'package:kaziapp_mkulima/services/keycloak_auth_service.dart';

void main() {
  group('KeycloakAuthService Data Models Tests', () {
    group('UserRegistration Tests', () {
      test('should create UserRegistration with all required fields', () {
        // Arrange & Act
        final registration = UserRegistration(
          firstName: 'John',
          lastName: 'Doe',
          phoneNumber: '+254712345678',
          email: 'john.doe@example.com',
          password: 'TestPassword123!@#',
          confirmPassword: 'TestPassword123!@#',
          county: 'Nairobi',
          preferredLanguage: 'en',
          clientType: 'farmer',
          acceptTerms: true,
        );

        // Assert
        expect(registration.firstName, 'John');
        expect(registration.lastName, 'Doe');
        expect(registration.phoneNumber, '+254712345678');
        expect(registration.email, 'john.doe@example.com');
        expect(registration.password, 'TestPassword123!@#');
        expect(registration.confirmPassword, 'TestPassword123!@#');
        expect(registration.county, 'Nairobi');
        expect(registration.preferredLanguage, 'en');
        expect(registration.clientType, 'farmer');
        expect(registration.acceptTerms, true);
      });

      test('should create UserRegistration with optional email as null', () {
        // Arrange & Act
        final registration = UserRegistration(
          firstName: 'Jane',
          lastName: 'Smith',
          phoneNumber: '+254712345679',
          email: null,
          password: 'TestPassword123!@#',
          confirmPassword: 'TestPassword123!@#',
          county: 'Mombasa',
        );

        // Assert
        expect(registration.firstName, 'Jane');
        expect(registration.lastName, 'Smith');
        expect(registration.email, null);
        expect(registration.county, 'Mombasa');
        expect(registration.preferredLanguage, 'en'); // default value
        expect(registration.clientType, 'farmer'); // default value
        expect(registration.acceptTerms, true); // default value
      });

      test('should convert UserRegistration to JSON', () {
        // Arrange
        final registration = UserRegistration(
          firstName: 'John',
          lastName: 'Doe',
          phoneNumber: '+254712345678',
          email: 'john.doe@example.com',
          password: 'TestPassword123!@#',
          confirmPassword: 'TestPassword123!@#',
          county: 'Nairobi',
        );

        // Act
        final json = registration.toJson();

        // Assert
        expect(json['firstName'], 'John');
        expect(json['lastName'], 'Doe');
        expect(json['phoneNumber'], '+254712345678');
        expect(json['email'], 'john.doe@example.com');
        expect(json['password'], 'TestPassword123!@#');
        expect(json['confirmPassword'], 'TestPassword123!@#');
        expect(json['county'], 'Nairobi');
        expect(json['preferredLanguage'], 'en');
        expect(json['clientType'], 'farmer');
        expect(json['acceptTerms'], true);
      });
    });

    group('AuthResult Tests', () {
      test('should create successful AuthResult', () {
        // Arrange
        final user = User(
          id: 'user123',
          username: '+254712345678',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          emailVerified: true,
        );

        final tokens = AuthTokens(
          accessToken: 'access_token_123',
          refreshToken: 'refresh_token_123',
          idToken: 'id_token_123',
          tokenType: 'Bearer',
          expiresIn: 3600,
        );

        // Act
        final result = AuthResult.success(user, tokens);

        // Assert
        expect(result.success, true);
        expect(result.user?.id, 'user123');
        expect(result.tokens?.accessToken, 'access_token_123');
        expect(result.error, null);
      });

      test('should create error AuthResult', () {
        // Act
        final result = AuthResult.error('Login failed');

        // Assert
        expect(result.success, false);
        expect(result.user, null);
        expect(result.tokens, null);
        expect(result.error, 'Login failed');
      });
    });

    group('KeycloakAuthService Basic Tests', () {
      late KeycloakAuthService authService;

      setUp(() {
        authService = KeycloakAuthService();
      });

      test('should create KeycloakAuthService instance', () {
        // Assert
        expect(authService, isNotNull);
        expect(authService, isA<KeycloakAuthService>());
      });

      test('should have correct base URL', () {
        // This test would require exposing the base URL or making it testable
        // For now, just verify the service can be instantiated
        expect(authService, isNotNull);
      });
    });
  });
}
