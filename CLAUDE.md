# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RickCardsMorty is a SwiftUI iOS app that demonstrates **The Composable Architecture (TCA)** with real-world API integration. The app allows users to browse Rick and Morty characters from the public API (https://rickandmortyapi.com/), authenticate via Google Sign-In, and view detailed character information.

**Tech Stack:**
- SwiftUI + Combine for UI and reactive programming
- Swift concurrency (async/await)
- Usage of new Swift Test library
- TCA (The Composable Architecture) for state management
- Firebase Auth + Google Sign-In for authentication
- Minimum deployment target: iOS 17.6

## Build & Test Commands

### Building
```bash
# Build the app for simulator
xcodebuild -project RickCardsMorty.xcodeproj -scheme RickCardsMorty -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' build

# Build for device
xcodebuild -project RickCardsMorty.xcodeproj -scheme RickCardsMorty -destination generic/platform=iOS build
```

### Testing
```bash
# Run all tests
xcodebuild test -project RickCardsMorty.xcodeproj -scheme RickCardsMorty -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0'

# Run tests using test plan
xcodebuild test -project RickCardsMorty.xcodeproj -scheme RickCardsMorty -testPlan CICDTool -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0'

# Run specific test
xcodebuild test -project RickCardsMorty.xcodeproj -scheme RickCardsMorty -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' -only-testing:RickCardsMortyTests/HomeFeatureTests/testHomeFeatureBasic
```

### Linting
```bash
# Run SwiftLint (configuration in .swiftlint.yml)
swiftlint lint

# Auto-fix violations where possible
swiftlint --fix
```

Note: SwiftLint is integrated as a build tool plugin and runs automatically during builds.

## Architecture

### The Composable Architecture (TCA) Pattern

This project strictly follows TCA principles:

1. **Feature Structure:** Each feature is a `@Reducer` struct containing:
   - `State`: Observable state with `@ObservableState` macro
   - `Action`: All possible actions (user interactions, API responses, etc.)
   - `body`: Reducer logic that processes actions and updates state

2. **Navigation:**
   - `EntryViewFeature` is the root coordinator that manages login/home navigation
   - Uses enum-based state: `.login(LoginFeature.State)` or `.home(HomeFeature.State)`
   - Child features are composed using `Scope` reducers

3. **Dependencies:**
   - Services are injected via `@Dependency` property wrapper
   - Live implementations for production, mock implementations for testing
   - Register dependencies by conforming to `DependencyKey` protocol

### Key Architectural Components

**Feature Files (State + Logic):**
- `EntryViewFeature.swift` - Root coordinator managing login/home transitions
- `LoginFeature.swift` - Authentication state and logic (RickCardsMorty/Login/View/)
- `HomeFeature.swift` - Character browsing with pagination and search (RickCardsMorty/Home/View/)
- `CharacterDetailFeature.swift` - Individual character details (RickCardsMorty/Home/View/)

**View Files (UI Layer):**
- `EntryView.swift` - Root view that switches between login and home
- `LoginView.swift` - Google Sign-In button and UI
- `HomeView.swift` - Character list with infinite scroll
- `CharacterDetailView.swift` - Character details presentation

**Service Layer:**
- `CharacterService.swift` - TCA dependency for Rick & Morty API
- `AuthenticationManager.swift` - TCA dependency for Google Auth
- `RequestDispatcher.swift` - Generic networking layer using Combine

**Networking:**
- `Request.swift` - Protocol defining API request structure
- `RequestDispatcher.swift` - Executes requests and handles responses using Combine publishers
- Uses `NetworkingEnvironment` for host/baseURL configuration

### State Management Flow

1. User interaction triggers an `Action` in the View
2. Action is sent to the Store
3. Reducer processes the Action and updates State
4. For side effects (API calls), reducer returns `.run { send in ... }`
5. Side effect completion sends another Action back to the Reducer
6. State update triggers View re-render

Example from HomeFeature.swift:77:
```swift
return .run { send in
    if queryString.isEmpty {
        let response = try await characterService.fetchCharacters(currentPage)
        await send(.processResponse(response: response))
    }
}
```

## Testing

### TCA Testing Pattern

TCA tests use `TestStore` which provides exhaustive runtime checks:

```swift
let store = await TestStore(
    initialState: HomeFeature.State(),
    reducer: HomeFeature.init
)

await store.send(.loadCharacters) {
    $0.isLoadingPage = true  // Assert state changes
}

await store.receive(\.processResponse) {
    $0.isLoadingPage = false
    $0.characters = responseMock.results
}
```

**Important:** TestStore requires you to assert ALL state changes. Missing assertions cause test failures.

**Important:** Use swift test framework always

**Mock Data:** Create new  `[SERVICE OR DEPDENCY]*Mocks.swift` in Utils/Mocks/ for test fixtures.

### Test Location

Tests are in `RickCardsMortyTests/` directory, organized by feature:
- `RickCardsMortyTests/Home/HomeFeatureTests.swift`

## Service Implementation Pattern

Services follow a specific TCA dependency pattern:

1. Define as struct with closures for each operation:
   ```swift
   public struct CharacterService {
       var fetchCharacters: (_ index: Int) async throws -> CharacterResponse
   }
   ```

2. Conform to `DependencyKey` with `liveValue` and `testValue`
3. Register in `DependencyValues` extension
4. Provide `.live` implementation (production) and `.mock` implementation (testing/previews)
5. `.mock` implementation must be always inside `#if DEBUG` statement

See CharacterService.swift for the complete pattern understanding.

### Test Coverage
- It is important to maintain coverage over 80%
- The coverage excludes SwiftUI View files `*View.swit`

## Important Implementation Details

### Pagination in HomeFeature

- `currentPage` and `canLoadMorePages` use `@ObservationStateIgnored` to prevent UI updates
- Infinite scroll triggers when user reaches 5 items from the end (HomeFeature.swift:52)
- Search uses `.debounce` with 0.5s delay to avoid excessive API calls (HomeFeature.swift:99)

### Authentication Flow

1. `LoginFeature` handles sign-in/sign-out actions
2. `EntryViewFeature` listens for `.login(.signInSuccess)` and transitions to `.home` state
3. `AuthenticationManager` wraps Google Sign-In SDK as a TCA dependency
4. Firebase is configured in `RickCardsMortyApp.init()` (RickCardsMortyApp.swift:22)

### Testing Exclusion

`RickCardsMortyApp` checks `!_XCTIsTesting` to prevent app initialization during tests (RickCardsMortyApp.swift:27). This allows TCA's `TestStore` to control the entire app state.

## Code Style & Linting

SwiftLint configuration (`.swiftlint.yml`):
- Line length: 180 characters (warning)
- Type body length: 300 lines warning, 400 error
- File length: 500 lines warning, 1200 error
- Disabled rules: `control_statement`, `trailing_whitespace`, `empty_parentheses_with_trailing_closure`

## Firebase Configuration

Requires `GoogleService-Info.plist` in project root for Firebase/Google Sign-In to work. This file contains API keys and is excluded from git.

## Dependencies (Swift Package Manager)

- **ComposableArchitecture** (v1.22.3) - State management
- **Firebase iOS SDK** (v11.3.0) - Auth, Core
- **GoogleSignIn-iOS** (v8.0.0) - Google authentication
- **SwiftUIX** (v0.2.3) - Extended SwiftUI components
- **SwiftLintPlugins** (v0.57.0+) - Build-time linting

All dependencies are managed via SPM and defined in project.pbxproj.

## Common Patterns

### Adding a New TCA Feature

1. Create `[Feature]Feature.swift` with State, Action, and Reducer body
2. Create corresponding View file that takes `Store<[Feature]Feature.State, [Feature]Feature.Action>`
3. If feature needs API/services, create dependency struct following CharacterService pattern
4. Add test file in `RickCardsMortyTests/[Feature]/[Feature]FeatureTests.swift`

### Working with API Services

1. Define `Request` enum conforming to `Request` protocol (see CharacterService.swift:13)
2. Specify `path`, `method`, `parameters`, and `headers`
3. Use `RequestDispatcher` to execute requests with `responseObject` type
4. Wrap in TCA dependency for testability

### Handling Asynchronous Operations

Always use `.run` effect for async operations:
```swift
return .run { send in
    let result = try await someAsyncOperation()
    await send(.operationComplete(result))
}
```

For error handling, use the `catch:` parameter:
```swift
return .run { send in
    try await riskyOperation()
    await send(.success)
} catch: { error, send in
    await send(.failure(error))
}
```
