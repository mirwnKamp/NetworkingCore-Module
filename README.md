# NetworkingCore

`NetworkingCore` is a lightweight, modular networking layer for iOS applications, designed to work perfectly with **MVVM + Clean Architecture**.

It is built as a **Swift Package** and follows **dependency inversion** by separating:
- **Interfaces (contracts)**
- **Concrete implementations**

This makes it easy to test, extend, and reuse across multiple apps.

---

## Features

- Swift Package Manager (SPM)
- Async / Await
- Clean Architecture–friendly
- Protocol-oriented design
- Request interceptors (e.g. authentication)
- Retry strategy support
- Fully testable (mockable sessions & clients)
- No dependency on UI or app-specific code

## Installation

### Swift Package Manager

Add the package using Xcode:

https://github.com/mirwnKamp/NetworkingCore-Module.git

markdown
Copy code

Choose **Up to Next Major Version**.

## Architecture Overview

The package is split into two modules:

### `NetworkingCoreInterfaces`
Contains **only contracts** (protocols & shared types).

Your **app and domain layers should depend on this module only**.

Includes:
- `APIClient`
- `Endpoint`
- `NetworkConfiguration`
- `NetworkError`
- `RequestInterceptor`
- `RetryStrategy`
- `NetworkSession`
- `TokenProvider`

---

### `NetworkingCore`
Contains **concrete implementations**.

Includes:
- `DefaultAPIClient`
- `RequestBuilder`
- `AuthInterceptor`
- `DefaultRetryStrategy`
- `NetworkResponseValidator`
