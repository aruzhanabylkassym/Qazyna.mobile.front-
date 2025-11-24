# Qazyna - Supplier Consumer Platform (Mobile App)

A Flutter mobile application for the Supplier Consumer Platform (SCP), facilitating B2B collaboration between food suppliers and institutional consumers (restaurants/hotels).

## Features

### Consumer Interface
- Link requests to suppliers
- Browse catalog from linked suppliers
- Shopping cart and order placement
- Order tracking and history
- Chat with suppliers
- Complaint management
- Profile management

### Supplier Interface (Sales Representative)
- Link request management (approve/reject)
- Order management (view, accept/reject)
- Product listing
- Chat with consumers
- Complaint handling
- Analytics dashboard
- Profile management

## Technology Stack

- **Framework**: Flutter
- **State Management**: Provider
- **HTTP Client**: http package
- **Secure Storage**: flutter_secure_storage
- **File Picking**: file_picker

## Setup

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Android Studio / Xcode
- Backend server running on `localhost:8088` (or configure in `lib/config/env.dart`)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure backend URL (if needed):
   - Edit `lib/config/env.dart`
   - For physical devices, replace localhost with your computer's IP address

4. Run the app:
   ```bash
   flutter run
   ```

## Platform Configuration

### Android
- Network security config allows HTTP for local development
- Uses `10.0.2.2:8088` for emulator (accesses host machine's localhost)
- For physical devices, update `baseUrl` in `lib/config/env.dart` with your computer's IP

### iOS
- Info.plist configured to allow HTTP traffic for localhost
- Uses `localhost:8088` for simulator
- For physical devices, update `baseUrl` in `lib/config/env.dart` with your computer's IP

## Backend Integration

The app is ready to connect to a Go backend server. All API endpoints are configured in `lib/config/env.dart`:

- POST /api/register/
- POST /api/login/
- POST /api/logout/
- POST /api/upload/pictures/
- GET /api/list/pictures/
- GET /api/list/suppliers/
- POST /api/request/link/
- GET /api/list/links/
- POST /api/request/issue/
- GET /api/list/issues/
- POST /api/request/order/
- GET /api/list/orders/
- POST /api/send/message/
- GET /api/load/message/

## Project Structure

```
lib/
├── app.dart                 # Main app widget and state
├── main.dart                # Entry point
├── config/
│   └── env.dart            # Backend URL and API routes
├── core/                   # Core utilities (HTTP client, cookie store)
├── models/                 # Data models
├── providers/              # State management
├── screens/                # UI screens
│   ├── auth/              # Authentication screens
│   ├── consumer/          # Consumer interface
│   └── supplier/          # Supplier interface
├── services/               # API services
└── widgets/               # Reusable widgets
```

## Development Notes

- The app uses localhost URLs for development. For production, update `lib/config/env.dart` to use your production backend URL.
- All sensitive data (cookies, passwords) are stored securely using `flutter_secure_storage`.


