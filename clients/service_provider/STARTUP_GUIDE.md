# KaziApp Service Provider - Startup Guide

## Prerequisites
Make sure you have Flutter installed and configured on your system.

## Quick Start Steps

### 1. Install Dependencies
```bash
cd clients/service_provider
flutter pub get
```

### 2. Test the App (Simple Version)
First, test with the simple test app to ensure everything is working:
```bash
flutter run test_app.dart
```

### 3. Run the Full App
Once the test works, run the main app:
```bash
flutter run
```

## Troubleshooting

### If you get dependency errors:
1. Make sure you have Flutter SDK installed
2. Run `flutter doctor` to check your setup
3. Try `flutter clean` then `flutter pub get`

### If you get compilation errors:
1. Check that all imports are correct
2. Make sure you're in the correct directory: `clients/service_provider`
3. Try running the test app first: `flutter run test_app.dart`

### Common Issues:

**Issue: "Target of URI doesn't exist"**
- Solution: Run `flutter pub get` to install dependencies

**Issue: "No connected devices"**
- Solution: 
  - For web: `flutter run -d chrome`
  - For mobile: Connect a device or start an emulator
  - Check available devices: `flutter devices`

**Issue: "Gradle build failed"**
- Solution: 
  - Run `flutter clean`
  - Run `flutter pub get`
  - Try again

## App Features

The app includes:
- ✅ Login/Register screens
- ✅ Dashboard with real data integration
- ✅ Profile setup wizard
- 🚧 Services management (placeholder)
- 🚧 Bookings management (placeholder)
- 🚧 Customer management (placeholder)
- 🚧 Analytics (placeholder)

## Development Notes

- The app uses Material Design 3
- Main color scheme: Green (#2E7D32)
- All models and services are implemented
- Navigation is set up between main screens
- Some advanced features show "coming soon" messages

## Next Steps

1. Test the basic app functionality
2. Implement backend API integration
3. Add real data to replace mock data
4. Complete the placeholder screens
5. Add proper error handling and loading states

## Support

If you encounter issues:
1. Check the console output for specific error messages
2. Ensure all dependencies are installed
3. Try the test app first to isolate issues
4. Check Flutter version compatibility
