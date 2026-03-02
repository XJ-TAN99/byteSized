# Weather Widget

Build a single-screen weather app that fetches current conditions, caches the last result, and handles poor connectivity gracefully.

---

## 1) Problem Statement

Create a weather display for a single hardcoded city (e.g., "London"). Show temperature, condition, and last updated time. If the user opens the app offline, show cached data with a "stale" indicator.

---

## 2) Deliverable

- **WeatherService**: Fetches from Open-Meteo API (free, no key needed)
- **WeatherCache**: File-based persistence of last response
- **WeatherView**: Single SwiftUI screen with refresh capability

---

## 3) Functional Requirements

- Fetch current weather from `https://api.open-meteo.com/v1/forecast`
- Display: temperature, weather condition (sunny/rainy/cloudy), last updated time
- Cache last successful response to disk (FileManager)
- On launch: try network first, fall back to cache if offline
- Pull-to-refresh triggers new fetch
- Hardcoded location (lat=51.5, lon=-0.1 for London)

---

## 4) Non-Functional Requirements

- Cancel in-flight request if user pulls to refresh again
- Cache valid for 30 minutes (then show stale indicator)
- Handle HTTP errors with specific messages (404, 500, no network)
- Don't block UI thread during cache read/write
- Graceful JSON decoding failure handling

---

## 5) UI Spec (Light)

**WeatherView**: Centered card layout

| State | Visual |
|-------|--------|
| Loading | Progress indicator + "Updating..." |
| Success | Large temperature, condition icon/text, "Updated 2 min ago" |
| Stale | Success UI + orange banner "Offline • Showing cached data" |
| Error | Red text + "Tap to retry" button |

---

## 6) Expected Public API

```swift
struct Weather: Codable, Equatable {
    let temperature: Double
    let condition: WeatherCondition
    let timestamp: Date
}

enum WeatherCondition: String, Codable {
    case sunny, cloudy, rainy, snowy, unknown
}

protocol WeatherServiceProtocol {
    func fetchWeather(lat: Double, lon: Double) async throws -> Weather
}

actor WeatherCache {
    func save(_ weather: Weather) async throws
    func load() async -> Weather?
    var isStale: Bool { get }
}

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var state: WeatherState = .loading
    
    func load() async
    func refresh() async
    
    enum WeatherState: Equatable {
        case loading
        case loaded(Weather, isStale: Bool)
        case error(String)
    }
}
```

---

## 7) Allowed Frameworks

- Swift Concurrency
- URLSession
- FileManager (for caching)
- SwiftUI

---

## 8) What Success Looks Like (1-2 Hour Scope)

- Clean separation: Service → Cache → ViewModel → View
- Actor-isolated cache
- Proper cancellation on refresh
- Handle all 3 error cases: network fail, HTTP error, decode fail
- At least 2 unit tests (cache roundtrip, service error handling)

**Out of scope:** Multiple cities, search, animations, background refresh, notifications.

---

## Notes for Implementation

- Identify your own edge cases
- Identify your own testing strategy
- Ask clarifying questions before coding
- Evaluation criteria will be provided after implementation review
