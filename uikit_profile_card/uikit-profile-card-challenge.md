# UIKit Profile Card

Build a reusable profile card view programmatically (no Storyboards). Hardcoded data is fine — the goal is pure layout code.

---

## 1) Problem Statement

Create a `ProfileCardView` that displays a user's photo, name, and role. Use only programmatic Auto Layout.

---

## 2) Deliverable

Single file: `ProfileCardView.swift`

---

## 3) Requirements

- **Avatar**: 80x80pt circle image (use `UIImage(systemName: "person.circle.fill")` or any placeholder)
- **Name label**: Bold, 20pt, centered below avatar
- **Role label**: Gray, 16pt, centered below name
- **Card background**: White, 16pt corner radius, subtle shadow
- **Padding**: 20pt all around, components spaced 12pt apart

---

## 4) Layout Spec

```
┌─────────────────────────────┐
│                             │
│         ┌───────┐           │
│         │ Avatar│  80x80    │
│         └───────┘           │
│                             │
│        "Jane Doe"           │
│      "iOS Developer"        │
│                             │
└─────────────────────────────┘
     (card: 280pt wide)
```

---

## 5) Constraints

- Use `NSLayoutConstraint` or `UILayoutGuide` (no third-party layout libraries)
- Support dynamic type (labels should wrap if name is long)
- Minimum iOS 15

---

## 6) Usage Example

```swift
let card = ProfileCardView()
card.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(card)

NSLayoutConstraint.activate([
    card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    card.widthAnchor.constraint(equalToConstant: 280)
])
```

---

## What I'm Checking

| Skill | Evidence |
|-------|----------|
| `translatesAutoresizingMaskIntoConstraints = false` | You remembered the #1 UIKit footgun |
| `addSubview` order | Layout works regardless of add order |
| Constraint activation | `NSLayoutConstraint.activate([...])` pattern |
| Safe area / bounds | Card doesn't hardcode to screen edges |
| Readable code | Clear variable names, grouped constraints |

---

**Time:** 15 minutes max. Just make it compile and look right.

---

## Notes for Implementation

- Evaluation criteria will be provided after implementation review
