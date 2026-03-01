//
//  ContentView.swift
//  weather_wdiget
//
//  Created by Tan Xin Jie on 1/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var vm = WeatherViewModel()
    var body: some View {
        VStack {
            Image(systemName: vm.weather.condition.icon)
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding()
            Text(vm.weather.condition.rawValue)
                .font(.title)
            let timeText = "Last updated: " + vm.weather.timestamp.formatted(.dateTime)
            Text(timeText)
                .font(.caption)
            Text(vm.status.message)
            Button {
                Task {
                    await vm.onRetryButtonPressed()
                }
            } label: {
                switch vm.status {
                case .error:
                    Text("Retry")
                default:
                    Text("Update")
                }
            }
            .buttonStyle(.glass)
        }
        .padding()
        .task {
            await vm.onViewLoaded()
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                vm.updateTime()
            }
        }
    }
}

@MainActor
@Observable
class WeatherViewModel {
    private let repo = WeatherRepository()
    var weather = Weather(temperature: 0.0, condition: .unknown, timestamp: Date.now)
    var status: Status = .error
    
    func onViewLoaded() async {
        await loadWeather()
    }
    
    func onRetryButtonPressed() async {
        await loadWeather()
    }
    
    func loadWeather() async {
        status = .loading
        
        do {
            weather = try await repo.fetchWeather(for: .london)
            updateTime()
        } catch {
            status = .error
        }
    }
    
    func updateTime() {
        let minutes = Int(Date().timeIntervalSince(weather.timestamp) / 60)
        status = .success(minutes)
    }
}

class WeatherRepository {
    private let service = WeatherService()
    
    func fetchWeather(for city: City) async throws -> Weather {
        let response = try await service.fetchWeather(for: city)
        return Weather(
            temperature: response.currentWeather.temperature,
            condition: WeatherCondition(code: response.currentWeather.weathercode),
            timestamp: response.currentWeather.time
        )
    }
}

class WeatherService {
    private let baseURL = URL(string: "https://api.open-meteo.com/v1/")!
    
    func fetchWeather(for city: City) async throws -> WeatherResponse {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("forecast"),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: "\(city.latitude)"),
            URLQueryItem(name: "longitude", value: "\(city.longitude)"),
            URLQueryItem(name: "current_weather", value: "true"),
            URLQueryItem(name: "timeformat", value: "unixtime")
        ]
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode(WeatherResponse.self, from: data)

        return decoded
    }
}

struct WeatherResponse: Codable {
    let currentWeather: Current
    
    struct Current: Codable {
        let temperature: Double
        let weathercode: Int
        let time: Date
    }
}

struct Weather: Equatable {
    let temperature: Double
    let condition: WeatherCondition
    let timestamp: Date
}

enum WeatherCondition: String, Codable {
    case sunny, cloudy, rainy, snowy, unknown
    
    init(code: Int) {
        switch code {
        case 0:
            self = .sunny
        case 1...3:
            self = .cloudy
        case 61...67:
            self = .rainy
        case 71...77:
            self = .snowy
        default:
            self = .unknown
        }
    }
    
    var icon: String {
        switch self {
        case .sunny:
            return "sun.max"
        case .cloudy:
            return "cloud"
        case .rainy:
            return "cloud.rain"
        case .snowy:
            return "snowflake"
        default:
            return "questionmark"
        }
    }
}

enum Status {
    case loading, success(Int), stale, error
    
    var message: String {
        switch self {
        case .loading:
            return "Loading..."
        case .success(let minutes):
            if minutes == 0 {
                return "Updated less than a min ago"
            }
            return "Updated \(minutes) min ago"
        case . stale:
            return "Offline • Showing cached data"
        case .error:
            return "Tap to retry"
        }
    }
}

enum City {
    case london
    case newyork
    case singapore

    var latitude: Double {
        switch self {
        case .london:
            return 51.5074
        case .newyork:
            return 40.7128
        case .singapore:
            return 1.3521
        }
    }

    var longitude: Double {
        switch self {
        case .london:
            return -0.1278
        case .newyork:
            return -74.0060
        case .singapore:
            return 103.8198
        }
    }
}

#Preview {
    ContentView()
}
