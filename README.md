# Nostalgia

AI-powered time machine app that generates personalized childhood memories based on your era and country. Features include daily nostalgic stories with ambient audio, interactive AI chat to explore memories deeper, history of past generations, and social sharing. Built with Flutter & Riverpod.

## Features

- **Daily Memories** - AI-generated nostalgic stories personalized to your childhood era and country
- **Ambient Audio** - Immersive background sounds that complement each memory
- **AI Chat** - Interactive conversations to explore and relive memories deeper
- **History** - Browse all your previously generated memories
- **Sharing** - Share your favorite memories on social media and messengers
- **Multi-language** - Supports Russian and English

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Riverpod** - State management
- **Go Router** - Navigation
- **Dio** - HTTP client
- **SSE** - Server-Sent Events for streaming chat responses
- **just_audio** - Audio playback
- **cached_network_image** - Image caching
- **share_plus** - Social sharing

## Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+
- iOS Simulator or Android Emulator

### Installation

```bash
# Clone the repository
git clone git@github.com:Moder443/Nostalgia.git

# Navigate to project directory
cd Nostalgia

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── localization/    # Multi-language support
│   ├── network/         # API client
│   ├── router/          # Navigation routes
│   └── theme/           # App theme and colors
├── features/
│   ├── home/            # Home screen
│   ├── nostalgia/       # Memory generation & display
│   ├── onboarding/      # User onboarding flow
│   ├── settings/        # Settings & about screens
│   └── splash/          # Splash screen
└── main.dart
```

## License

This project is proprietary software. All rights reserved.

## Contact

For support or inquiries: support@retrovibe.app
