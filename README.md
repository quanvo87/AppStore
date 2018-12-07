# App Store

Quan Vo

## Installation Instructions

- clone the repo and `cd` into it
- run `AppStore.xcworkspace`
- run the simulator

> Note: The backend consists of 8 REST APIs deployed as serverless cloud functions. They go to sleep after inactivity, so each API could take ~5 seconds to start up. Things should be snappy after that though.

## Notable Features

- 3 ways to search a term:
    - touch a `Recent Search`
    - type in the search bar and tap `Search` on the keyboard
    - type in the search bar and tap one of the suggestions that appear

- Async loading and caching of images provides fast, smooth scrolling. Even while scrolling extremely quickly through a large amount of images.

- Dependency injection

- SearchServiceProtocol:
    - concrete implementation retains a `DispatchWorkItem`
    - on each keystroke in search bar, this class cancels the pending work item
    - only makes http request after 250 ms delay
    - reduces amount of unnecessary requests

- properly displays wide vs tall screen shots in app preview and detail cells

- Express serverless cloud functions inside `/functions` folder

## TODO

Further investigate known issues:
 - URLSession memory leak
 - SearchController memory leak (haven't been able to recreate)

Things to add:

- unit and UI tests
- loading indicators
- pull to refresh
- pagination
- cache to file system
- background updates
- swagger

More found in issues.

Please let me know if you have any questions!