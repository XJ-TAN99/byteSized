# Repository Guidelines

## Project Structure & Module Organization
- Each app lives at the repo root in `<ProjectName>/` and is standalone (`<ProjectName>.xcodeproj`, `Sources/`, `Tests/`, `Resources/Assets.xcassets`).
- Keep shared code in `Shared/` (e.g., `Sources/SharedUI`, `Sources/Utilities`) and import via project references or SPM packages as needed.
- Do not commit user-specific files (`xcuserdata/`, `*.xcuserstate`, `DerivedData/`); the `.gitignore` already covers these.

## Build, Test, and Development Commands
- Open in Xcode: `open Clock/Clock.xcodeproj`.
- Build (Debug): `xcodebuild -project Clock/Clock.xcodeproj -scheme Clock -configuration Debug build`.
- Run tests with coverage: `xcodebuild test -project Clock/Clock.xcodeproj -scheme Clock -destination 'platform=iOS Simulator,name=iPhone 15' -enableCodeCoverage YES`.
- If a project uses SPM only: from its folder run `swift build` and `swift test`.
- Optional tooling (if present): `fastlane test`, `mint run swiftlint`, `mint run swiftformat .`.

## Coding Style & Naming Conventions
- Language: Swift (2-space indent, prefer type inference; avoid force unwraps; use `guard` for early exits).
- Names: UpperCamelCase types/protocols; lowerCamelCase functions/properties; enum cases lowerCamelCase. File names match the primary type.
- Organize with `// MARK:` and extensions by responsibility. Keep view code and logic separated; prefer small, focused types.
- Formatting/Linting: run `swiftformat .` and `swiftlint` when configured (SPM plugin or Mint).

## Testing Guidelines
- Framework: XCTest. Place tests in `<ProjectName>/Tests/<ProjectName>Tests/` (and `...UITests/` for UI tests).
- Name tests `test_<FeatureOrType>_<Behavior>()`. Include edge cases and async paths.
- Target meaningful coverage for changed code (≈80%+). Enable coverage locally as shown above.

## Commit & Pull Request Guidelines
- Commits: small, focused, imperative mood. Prefix with scope when helpful, e.g. `[Clock] Fix timer reset on resume`.
- PRs: include summary, linked issues, screenshots for UI, steps to verify (device + iOS version), and any configuration changes (`.xcconfig`, `Package.resolved` for apps should be committed).
- Ensure builds and tests pass for all touched projects/schemes.

## Security & Configuration Tips
- Never commit secrets. Use `.xcconfig` and environment variables; keep secrets out of source.
- Respect the existing `.gitignore` for Xcode, SPM, CocoaPods, Carthage, and Fastlane artifacts.
