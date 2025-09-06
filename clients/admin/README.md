# KaziApp Admin Dashboard

A comprehensive administrative dashboard for managing the KaziApp agricultural platform. Built with Flutter Web for responsive design and optimal performance across all devices.

## 🌟 Features

### ✅ Implemented
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices
- **Modern UI**: Material Design 3 with custom KaziApp branding
- **Dashboard Overview**: Key metrics, charts, and recent activity
- **User Management**: View and manage farmers, service providers, veterinarians, buyers, and vendors
- **Analytics Dashboard**: Traffic overview, user analytics, and performance metrics
- **Navigation**: Adaptive navigation (rail for desktop, drawer for mobile)
- **Authentication UI**: Secure login interface

### 🚧 In Development
- **Authentication & Authorization**: Role-based access control
- **Real-time Data**: Live updates and notifications
- **Advanced Analytics**: Detailed reporting and insights
- **Content Management**: App content and notification management
- **System Monitoring**: Health checks and performance monitoring
- **API Integration**: Backend service integration

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Web browser (Chrome, Firefox, Safari, or Edge)
- Dart SDK (included with Flutter)

### Installation

1. **Navigate to the admin directory**:
   ```bash
   cd clients/admin
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run -d web-server --web-port=3002
   ```

4. **Access the dashboard**:
   Open your browser and navigate to `http://localhost:3002`

## 📱 Responsive Design

The admin dashboard adapts to different screen sizes:

- **Desktop (≥1440px)**: Extended navigation rail with full sidebar
- **Tablet (≥1024px)**: Collapsed navigation rail
- **Mobile (<1024px)**: Bottom navigation bar with drawer menu

## 🎨 UI Components

### Core Components
- **StatCard**: Displays key metrics with trend indicators
- **ChartCard**: Container for charts and data visualizations
- **AdminLayout**: Responsive layout wrapper with navigation
- **DataTable2**: Advanced data tables with sorting and filtering

### Navigation
- **Desktop**: Extended navigation rail with logo and user menu
- **Tablet**: Collapsed navigation rail
- **Mobile**: Bottom navigation bar with hamburger menu

## 📊 Dashboard Sections

### 1. Overview Dashboard
- Platform statistics (users, farmers, service providers)
- User growth charts
- User type distribution
- Recent activity feed

### 2. User Management
- Tabbed interface for different user types
- Advanced search and filtering
- User status management
- Bulk operations and export functionality

### 3. Analytics
- Traffic overview with line charts
- Device usage pie charts
- Engagement metrics
- Performance indicators

## 🔧 Configuration

### Theme Customization
The app uses a custom theme defined in `lib/core/theme/app_theme.dart`:
- Primary color: Agricultural green (#2E7D32)
- Secondary color: Technology blue (#1976D2)
- Material Design 3 components
- Dark mode support

### Constants
App-wide constants are defined in `lib/core/constants/app_constants.dart`:
- API endpoints
- UI dimensions
- Color schemes
- Kenyan counties list

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/     # App-wide constants
│   ├── router/        # Navigation and routing
│   └── theme/         # UI theme and styling
├── features/
│   ├── auth/          # Authentication screens
│   ├── dashboard/     # Main dashboard
│   ├── users/         # User management
│   └── analytics/     # Analytics and reporting
└── shared/
    ├── models/        # Data models
    ├── services/      # API services
    └── widgets/       # Reusable UI components
```

## 🔐 Authentication

The admin dashboard includes a secure login interface with:
- Email/password authentication
- Form validation
- Loading states
- Error handling
- Responsive design

**Note**: Authentication is currently UI-only. Backend integration is in development.

## 📈 Analytics Features

- **Traffic Overview**: Line charts showing user engagement
- **Device Usage**: Pie charts for device type distribution
- **Key Metrics**: Page views, unique visitors, bounce rate, session duration
- **Time Period Selection**: 24h, 7d, 30d, 90d, 1y views
- **Export Functionality**: Report generation (coming soon)

## 🛠️ Development

### Project Structure
- **Flutter Web**: Single-page application
- **Riverpod**: State management
- **GoRouter**: Navigation and routing
- **FL Chart**: Data visualization
- **Data Table 2**: Advanced table components
- **Hive**: Local storage

### Adding New Features
1. Create feature directory in `lib/features/`
2. Add screens in `presentation/screens/`
3. Update router in `lib/core/router/app_router.dart`
4. Add navigation items in `lib/shared/widgets/admin_layout.dart`

## 🌐 Browser Support

- ✅ Chrome (recommended)
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ⚠️ Internet Explorer (limited support)

## 📝 TODO

- [ ] Implement real authentication with JWT
- [ ] Add role-based access control
- [ ] Integrate with backend APIs
- [ ] Add real-time notifications
- [ ] Implement data export functionality
- [ ] Add system health monitoring
- [ ] Create content management system
- [ ] Add audit logging
- [ ] Implement advanced search
- [ ] Add bulk user operations

## 🤝 Contributing

1. Follow Flutter/Dart style guidelines
2. Use meaningful commit messages
3. Test on multiple screen sizes
4. Update documentation for new features

## 📄 License

This project is part of the KaziApp ecosystem and follows the same licensing terms.
