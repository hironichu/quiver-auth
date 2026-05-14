# quiver-auth

Authentication helpers for Quiver HTTP/3 applications. This package builds on `quiver-http3` and provides policy, extraction, guard, JWT, and OIDC support for HTTP/3 request handling.

## Product

| Product | Purpose |
| --- | --- |
| `QuiverAuth` | HTTP/3 authentication policies, request extraction helpers, guards, JWT issuing, OIDC validation, login redirect helpers, and server-side OIDC session storage. |

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
	.package(url: "https://github.com/hironichu/quiver-auth.git", branch: "main")
]
```

Then depend on `QuiverAuth`:

```swift
.target(
	name: "MyTarget",
	dependencies: [
		.product(name: "QuiverAuth", package: "quiver-auth"),
	]
)
```

## Local Development

Keep this package next to `quiver-http3` and `quiver-quic`:

```text
quiver-packages/
├── quiver-quic/
├── quiver-http3/
└── quiver-auth/
```

Set `QUIVER_PACKAGES_PATH=/path/to/quiver-packages` if your local Quiver package checkouts live somewhere else.

## Dependencies

- `quiver-http3` for HTTP/3 request and middleware integration.
- `quiver-quic` for shared QUIC core types.
- `swift-crypto` for cryptographic primitives.
- `swift-log` for diagnostics.
- `jwt-kit` for JWT handling.

## Development Commands

```bash
swift build
swift test
```

## Relationship To Quiver

The root `quiver` package conditionally re-exports this package through the `AuthSupport` package trait.
