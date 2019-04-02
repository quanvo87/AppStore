# App Store

- Search apps just like the Apple App Store
- View app details and screen shots
- View apps by category, popularity, and recent searches

## Installation Instructions

- Clone repo and `cd` into it
- Open `AppStore.xcodeproj`
- `⌘ + r` to run simulator

> Note: Backend is cloud functions. Please allow ~5 seconds to wake up.

## Features

- Search apps with live suggestions via `UISearchController`

  - Each keystroke in search bar cancels pending work item
  - Only make request after 250 ms delay
  - Reduces unnecessary requests

- Smooth scrolling via async loading and (in memory) caching of images

- `AppDetailViewController` features vertical and horizontal scrolling `UICollectionViewCell`s to emulate real App Store

- Dependency injection:

  - Network layer consists of several single responsibility service protocols
  - Controllers depend on these abstractions
  - Production code uses `URLSession` implementation of these protocols by default

- Implementation details hidden from classes using factories

- Profiled in Instruments

- Frontend has zero dependencies

- Backend is Express cloud functions
