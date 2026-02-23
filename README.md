# Story Player
An iOS audio story player app built with SwiftUI that lets users browse, favorite, and listen to classic stories with a beautiful, custom-designed interface.

[Project Board](https://github.com/users/adam-regan/projects/1)

![Image](https://github.com/user-attachments/assets/a599d7cc-0047-4f5b-bd5a-2487b8fb34b2)

## Features

- **Browse Stories**: Explore a collection of stories in grid and horizontal scrolling layouts
- **Audio Playback**: Full-featured audio player with play/pause, scrubbing, and progress tracking
- **Favorites**: Mark stories as favorites for quick access
- **Custom Tab Bar**: Beautiful custom tab navigation with animated transitions
- **Mini Player**: Persistent mini audio player that follows you across tabs
- **Dark Mode Support**: Full support for light and dark color schemes
- **Custom Theming**: Rich color palette system with custom theme support
- **Fake Backend**: Repository class emulating interaction with a real backend following appropriate architecture
- **Skeleton Screen**: Skeleton screen behavour for slow loading story lists

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture pattern with a clear separation of concerns:

### Layers

#### 1. **Views (SwiftUI)**
- **Tab Views**: `LibraryView`, `SettingsView`
- **Story Views**: `StoryListView`, `StoryCardView`, `StoryDetailView`
- **Audio Player Views**: `AudioPlayerView`, `MiniAudioPlayerView`, `HeaderPlayerView`, `MainPlayerButtonsView`, `ScrubbingBarView`
- **Shared Components**: `TabContent`, `CustomTabBarView`, `StoryListContent`

#### 2. **ViewModels**
- **StoriesViewModel**: Manages story list state, filtering (all/favorites), and data fetching
- **StoryDetailViewModel**: Handles individual story actions (favoriting/unfavoriting)
- **AudioViewModel**: Manages audio playback state and controls

All ViewModels are marked `@MainActor` for safe UI updates and use `@Published` properties for reactive state management.

#### 3. **Models**
- **Story**: Core data model representing a story (title, author, description, image, audio URL, favorite status)


#### 4. **Repository Layer**
- **StoriesRepositoryProtocol**: Protocol defining data access interface
- **StoriesRepository**: Production implementation using local JSON file storage to emulate real JSON fetches and updates with Codables
- **StoriesRepositoryStub**: Test/preview implementation for development

The repository pattern abstracts data access, making it easy to swap between local storage, network APIs, or test data.

#### 5. **Services**
- **AudioPlayer**: AVFoundation-based audio playback service with delegate pattern for state updates and time tracking

### Key Patterns

#### Dependency Injection
ViewModels receive dependencies through their initializers:
```swift
StoriesViewModel(filter: .all, storiesRepository: storiesRepository)
```

#### Protocol-Oriented Design
Repository layer uses protocols for testability and flexibility:
```swift
protocol StoriesRepositoryProtocol {
    func fetchStories() async throws -> [Story]
    func fetchFavoriteStories() async throws -> [Story]
    func favorite(_ story: Story) async throws
    func unfavorite(_ story: Story) async throws
}
```

#### Environment Objects & Environment Values
- `@EnvironmentObject` for shared state (ViewModels, AudioViewModel)
- Custom `@Environment(\.storyListType)` for configuration

#### Delegate Pattern
`AudioPlayer` uses delegates for state updates without tight coupling

#### Async/Await
Modern Swift Concurrency for asynchronous operations:
```swift
Task {
    stories = try .loaded(await storiesRepository.fetchStories())
}
```

## Tech Stack

### Core Frameworks
- **SwiftUI**
- **AVFoundation**: Audio playback (`AVPlayer`, `AVPlayerItem`)
- **Combine**: Reactive programming (`@Published`, `ObservableObject`)
- **Foundation**: Core utilities, JSON encoding/decoding, file management

### Language Features
- **Swift 6.2**: Latest Swift language features
- **Swift Concurrency**: `async/await`, `Task`, `@MainActor`
- **Property Wrappers**: `@State`, `@Published`, `@EnvironmentObject`, `@Environment`, `@AppStorage`

### Testing
- **Swift Testing**: Modern macro-based testing framework

### Design Patterns
- MVVM (Model-View-ViewModel)
- Repository Pattern
- Delegate Pattern
- Protocol-Oriented Programming
- Dependency Injection

### Custom Components
- Custom Tab Bar with animations
- Custom audio player UI
- Environment Keys for view configuration
- Loadable state wrapper


## Future Improvements

### High Priority
-  **Network Layer**: Replace local JSON storage with REST API integration
-  **Download Management**: Allow downloading stories for offline listening
-  **Background Playback**: Enable audio to continue when app is backgrounded
-  **Remote Control**: Lock screen and Control Center integration

### User Experience
-  **Search & Filtering**: Add search functionality
-  **Playback Speed**: Variable playback speed controls (0.5x - 2x)
-  **Sleep Timer**: Auto-stop playback after a set duration

### Technical Enhancements
-  **Widget Support**: Home screen widget showing currently playing story
-  **iPad Optimization**: Responsive layout for larger screens
-  **Accessibility**: Enhanced VoiceOver support and Dynamic Type
-  **Error Handling**: Unified error handling for all lists within Library page

### Design & Polish
-  **Animations**: Enhanced transition animations between views
-  **Haptics**: Tactile feedback for interactions

### Advanced Features
-  **Content Recommendations**: Personalized story suggestions
-  **Social Features**: Comments, ratings, and reviews
-  **Multi-language**: Localization support
-  **Chromecast/AirPlay**: Cast to external speakers/screens

## Author

Adam Regan - February 2026

---

**Note**: This app currently uses local JSON file storage for demo purposes.


