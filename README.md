# Story Player

A **SwiftUI audio story player inspired by products like Yoto**, designed to explore production-quality iOS architecture for
media playback apps.

The app allows users to browse, favourite, and listen to classic stories
through a custom-designed interface featuring a persistent mini-player,
smooth navigation, and modern SwiftUI architecture.

## Highlights

• Audio playback powered by **AVFoundation (AVPlayer)**\
• **Swift Concurrency** (async/await) for asynchronous data loading\
• **MVVM architecture** with repository abstraction\
• **Persistent mini audio player** across navigation\
• **Custom SwiftUI UI components and theming system**\
• **Skeleton loading states** for improved UX\
• Protocol-driven design for testability

------------------------------------------------------------------------

# Demo

 ![Image](https://github.com/user-attachments/assets/a599d7cc-0047-4f5b-bd5a-2487b8fb34b2)

------------------------------------------------------------------------

# Motivation

This project explores how to build a **modern SwiftUI media
application** that balances clean architecture with polished user
experience.

The focus was on solving real-world concerns such as:

• Audio playback management\
• Asynchronous data loading\
• State management across multiple screens\
• Clean architecture and testability\
• Creating responsive and visually engaging UI components

The goal was to build something closer to a **real product experience
rather than a simple demo app**.

------------------------------------------------------------------------

# Features

### Browse Stories

Explore a collection of stories displayed in both **grid and horizontal
scrolling layouts**.

### Audio Playback

Full-featured audio player with:

• play / pause\
• scrubbing and progress tracking

### Mini Player

A **persistent mini audio player** that follows the user across tabs and
allows quick playback control.

### Favourites

Users can mark stories as favourites for quick access.

### Custom Navigation

A **custom tab bar** with animated transitions between sections.

### Theming

Support for **light and dark mode** with a custom colour palette system.

### Skeleton Loading

Story lists display **skeleton loading states** to simulate real network
behaviour and improve perceived performance.

------------------------------------------------------------------------

# Tech Stack

## Core Frameworks

• **SwiftUI** - UI framework\
• **AVFoundation** - audio playback (AVPlayer, AVPlayerItem)\
• **Combine** - reactive state updates\
• **Foundation** - JSON decoding, file management, utilities

## Swift Features

• **Swift 6.2**\
• **Swift Concurrency** (async/await, Task, @MainActor)\
• **Property wrappers**:
- `@State`
- `@Published`
- `@EnvironmentObject`
- `@Environment`
- `@AppStorage`

------------------------------------------------------------------------

# Architecture

The app follows an **MVVM architecture** with clear separation between
UI, business logic, and data access.

Key architectural goals:

• Maintain **separation of concerns**\
• Enable **testability** through protocol-driven design\
• Allow **data source flexibility** via repository abstraction\
• Keep SwiftUI views **lightweight and declarative**

## Layers

### Views (SwiftUI)

Views focus purely on presentation and user interaction.

Examples include:

- LibraryView
- StoryListView
- StoryCardView
- StoryDetailView
- AudioPlayerView
- MiniAudioPlayerView
- CustomTabBarView

Reusable UI components are extracted into smaller composable views.

------------------------------------------------------------------------

### ViewModels

ViewModels manage UI state and coordinate data between services and
views.

Examples:

**StoriesViewModel**\
Handles story fetching, filtering, and UI state.

**StoryDetailViewModel**\
Manages individual story actions such as favouriting.

**AudioViewModel**\
Controls playback state and communicates with the audio service.

All ViewModels are annotated with **@MainActor** and use **@Published**
properties to drive reactive updates.

------------------------------------------------------------------------

### Models

**Story**

Represents story metadata including:

- title
- author
- description
- image
- audioURL
- favourite status

------------------------------------------------------------------------

### Repository Layer

The repository pattern abstracts data access and enables future backend
integration.

Protocol:

    protocol StoriesRepositoryProtocol {
        func fetchStories() async throws -> [Story]
        func fetchFavoriteStories() async throws -> [Story]
        func favorite(_ story: Story) async throws
        func unfavorite(_ story: Story) async throws
    }

Implementations:

**StoriesRepository**\
Local JSON-based data source simulating backend responses.

**StoriesRepositoryStub**\
Used for previews and testing.

------------------------------------------------------------------------

### Services

**AudioPlayer**

A dedicated service responsible for audio playback using
**AVFoundation**.

Responsibilities include:

• Managing AVPlayer lifecycle\
• Tracking playback time and progress\
• Updating playback state via delegate callbacks

This keeps audio logic separate from UI and ViewModels.

------------------------------------------------------------------------

# Key Patterns Used

**MVVM architecture**

Clear separation between UI, state management, and business logic.

**Repository Pattern**

Decouples the data layer from UI logic and allows future backend
integration.

#### Delegate Pattern
`AudioPlayer` uses delegates for state updates without tight coupling

**Dependency Injection**

ViewModels receive dependencies through their initializers.


**Protocol-Oriented Design**

Protocols enable testability and flexible implementations.

**Swift Concurrency**

Async operations handled using modern async/await patterns.

**Environment Objects**

Shared state across views using `@EnvironmentObject`.

------------------------------------------------------------------------

# Testing

Tests are written using **Swift Testing**, the modern macro-based
testing framework.

Testing focuses on:

• repository behaviour\
• ViewModel logic\
• state transitions

------------------------------------------------------------------------

# Running the Project

1.  Clone the repository
2.  Open the project in **Xcode**
3.  Build and run on an **iOS simulator (iOS 17+)**

The project uses bundled **JSON data** to simulate backend responses.

------------------------------------------------------------------------

# Future Improvements

## Platform Features

• Background audio playback\
• Lock screen media controls\
• Control Center integration

## User Experience

• Search and filtering\
• Playback speed controls\
• Sleep timer

## Technical Enhancements

• Replace local JSON storage with **network API**\
• Offline downloads for stories\
• Widget support\
• iPad layout optimization\
• Accessibility improvements

## Advanced Features

• Content recommendations\
• Localization\
• AirPlay / Chromecast support

------------------------------------------------------------------------

# Author

Adam Regan\
February 2026
