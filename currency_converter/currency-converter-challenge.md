# Currency Converter

Build a simple currency converter that fetches live exchange rates, caches them briefly, and handles network failures gracefully.

---

## 1) Problem Statement

Create a currency converter screen. User enters an amount, selects from/to currencies, and sees the converted value. Rates should be cached to avoid redundant API calls within a short window.

---

## 2) Deliverable

- **ExchangeRateService**: Fetches and caches rates
- **ConverterView**: Single SwiftUI screen with input, pickers, and result

---

## 3) Functional Requirements

- Convert between USD, EUR, GBP, JPY (hardcoded list fine)
- Fetch rates from a public API (exchangerate-api.com or similar)
- Cache rates in memory for 5 minutes
- Show loading state during fetch
- Show error if network fails (allow retry)
- Auto-convert when user stops typing for 500ms

---

## 4) Non-Functional Requirements

- Cancel in-flight request if user changes currency before response returns
- Don't leak memory on view dismissal
- Thread-safe cache access
- Handle API rate limits (429) with "too many requests" message

---

## 5) UI Spec (Light)

**ConverterView**: Single screen, vertically stacked

| Element | Description |
|---------|-------------|
| TextField | "Amount" (numeric input) |
| HStack | Two pickers for From/To currency |
| Button | "Convert" (or auto-convert on debounce) |
| Result | Large text showing converted amount |
| Error | Red text below, dismissible |

**States:** idle → loading → success (show result) / error (show message)

---

## 6) Expected Public API

```swift
protocol ExchangeRateServiceProtocol {
    func rate(from: Currency, to: Currency) async throws -> Decimal
}

enum Currency: String, CaseIterable {
    case usd, eur, gbp, jpy
}

@MainActor
final class ConverterViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var fromCurrency: Currency = .usd
    @Published var toCurrency: Currency = .eur
    @Published var result: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func convert() async
}
```

---

## 7) Allowed Frameworks

- Swift Concurrency (async/await)
- URLSession
- SwiftUI
- Foundation

---

## Notes for Implementation

- Identify your own edge cases
- Identify your own testing strategy
- Ask clarifying questions before coding
- Evaluation criteria will be provided after implementation review
