# RickCardsMorty

A SwiftUI learning project that demonstrates modern iOS development practices by building a Rick and Morty character browser app. This project serves as a comprehensive example of implementing **The Composable Architecture (TCA)** with real-world API integration, authentication, and advanced SwiftUI features.

## What This Project Does

RickCardsMorty is a native iOS app that allows users to:
- Browse characters from the Rick and Morty animated series
- View detailed information about each character
- Search through the character database
- Authenticate using Google Sign-In
- Experience a fully responsive interface that adapts to Dark/Light mode

The app fetches data from the free **Rick and Morty API** (https://rickandmortyapi.com/) and presents it in a clean, modern SwiftUI interface.

## Technologies Used

### **Core Frameworks**
- **SwiftUI** - Apple's declarative UI framework for building modern interfaces
- **Combine** - Apple's reactive programming framework for data flow and asynchronous operations
- **Firebase** - Backend services for authentication and configuration
- **TCA (The Composable Architecture)** - Point-Free's architecture library for state management and app composition

### **Authentication**
- **Google Sign-In SDK** - Secure user authentication with Google accounts
- **Firebase Auth** - Authentication backend integration

### **Platform Features**
- **Dark/Light Mode** - Automatic adaptation to system appearance settings
- **Search Functionality** - Real-time character search capabilities
- **Image Loading & Caching** - Optimized image handling for character portraits

## Project Architecture

This project follows **The Composable Architecture (TCA)** pattern, providing:
- **Unidirectional Data Flow** - Predictable state management
- **Composable Features** - Modular, reusable components
- **Comprehensive Testing** - Built-in testability for business logic
- **Side Effect Management** - Clean handling of API calls and external dependencies

## Folder Structure

```
RickCardsMorty/
├── App/
│   └── RickCardsMortyApp.swift          # Main app entry point & configuration
├── Features/                            # TCA Features (State + Logic)
│   ├── EntryViewFeature.swift          # App entry point feature
│   ├── HomeFeature.swift               # Main home screen logic
│   └── LoginFeature.swift              # Authentication feature
├── Views/                              # SwiftUI Views (UI Layer)
│   ├── HomeView.swift                  # Main character browsing interface
│   └── CharacterDetailView.swift      # Individual character details
├── Services/                           # Network & External Services
│   ├── CharacterService.swift          # Rick & Morty API integration
│   ├── RequestDispatcher.swift         # Network request handling
│   └── AuthenticationManager.swift     # Google Auth management
├── Utilities/
│   └── ImageLoader.swift               # Image loading & caching utility
└── Tests/
    └── HomeFeatureTests.swift          # Unit tests for home feature
```

### Architecture Highlights
- **Features** contain business logic and state management using TCA
- **Views** handle UI presentation with SwiftUI
- **Services** manage external dependencies (API calls, authentication)
- **Clear separation** between state management and UI components
- **Testable design** with isolated, composable features

## Testing & Quality Assurance

This project implements comprehensive testing strategies to ensure code reliability and UI consistency:

### **Testing Framework**
- **Swift Testing** - Modern Swift testing framework for unit tests
- **TCA TestStore** - Built-in testing utilities for verifying state changes and side effects
- **Snapshot Testing** - Visual regression testing tool integrated for validating UI consistency across changes and also entity structure consistency (Json evaluated)

### **Test Coverage**
- Maintains 80%+ test coverage across business logic
- Focuses on feature testing (reducers, state management, side effects)
- View files are excluded from coverage metrics

### **Test Organization**
Tests are organized in the `RickCardsMortyTests/` directory by feature:
- `HomeFeatureTests.swift` - Tests for character browsing and search logic
- `SnapshotTests/` - Snapshot tests for UI components ensuring visual consistency

## Demo

<img src="rickandmortydemo.gif" width="200" height="400" /> 
