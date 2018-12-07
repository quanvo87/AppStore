- 3 ways to search a term:
    - touch a `Recent Search`
    - type in the search bar and press `Search` on the keyboard
    - type in the search bar and tap one of the suggestions that appear

- Async loading and caching of images provides fast, smooth scrolling. Even while scrolling extremely quickly through a large amount of images.

- dependency injection

- SearchServiceProtocol:
    - concrete implementation retains a `DispatchWorkItem`
    - on each keystroke in search bar, this class cancels the pending work item
    - only makes http request after 250 ms delay
    - reduces amount of unnecessary requests

- properly displays wide vs tall screen shots in preview and detail cells