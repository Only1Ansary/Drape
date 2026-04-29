# 🛍️ Drape — Flutter E-Commerce App

A full-featured mobile shopping app built with Flutter and Firebase, featuring user authentication, real-time product browsing, cart management, wishlist, and order confirmation.

---

## 📱 Overview

**Drape** is a Flutter-based e-commerce application that allows users to browse fashion products, manage a shopping cart and wishlist, and place orders — all backed by Firebase Authentication and Cloud Firestore for real-time data sync.

---

## ✨ Features

- **Onboarding Screen** — Gender selection (Men/Women) intro screen before entering the app
- **Authentication** — Register and login with email & password via Firebase Auth
- **Product Browsing** — Real-time product feed fetched from Firestore, displayed in a 2-column grid
- **Product Detail** — View full product info with expandable description, price breakdown, and add-to-cart action
- **Shopping Cart** — Add/remove items, view subtotal, shipping cost, and total; checkout flow with address and payment method summary
- **Wishlist** — Save products to a personal wishlist stored in Firestore; toggle items in/out with heart icon
- **Order Confirmation** — Dedicated screen shown after checkout, clears cart and returns user to home
- **User Profile** — View username and email; logout with confirmation dialog
- **Side Drawer** — Quick navigation to Profile, Wishlist, Cart, and settings (dark mode toggle UI ready)
- **Brand Showcase** — Horizontal scrollable brand list (Nike, Adidas, Fila, Puma) on the home screen

---

## 🏗️ Architecture

The app follows the **BLoC / Cubit pattern** for state management:

| Cubit | Responsibility |
|---|---|
| `AuthCubit` | Handles login, registration, and logout via `FirebaseServices` |
| `ProductCubit` | Fetches and exposes the product list |
| `CartCubit` | Manages cart items (add, remove, clear) with Firestore persistence |
| `WishlistCubit` | Manages wishlist items (add, remove) with Firestore persistence |

---

## 🔧 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | flutter_bloc (Cubit) |
| Backend / Auth | Firebase Authentication |
| Database | Cloud Firestore |
| HTTP Client | Dio |
| Product Data Source | [Fake Store API](https://fakestoreapi.com/) |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- A Firebase project with **Authentication** (Email/Password) and **Firestore** enabled
- `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) placed in the correct directories

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/drape.git
cd drape

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Seeding Products

Products are sourced from the [Fake Store API](https://fakestoreapi.com/) and uploaded to Firestore using `ApiServices`. Call `uploadProductsToFirestore()` once to populate your Firestore `products` collection before running the app.

---

## 📦 Key Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.x
  firebase_core: ^2.x
  firebase_auth: ^4.x
  cloud_firestore: ^4.x
  dio: ^5.x
```

---

## 📸 Screens at a Glance

| Screen | Description |
|---|---|
| Onboarding | Full-screen background image with gender toggle and skip option |
| Login / Signup | Form validation, password strength indicator, "Remember me" toggle |
| Home | Search bar, brand row, real-time product grid, cart shortcut |
| Product Detail | Image, title, category, expandable description, total price, add-to-cart |
| Cart | Item list, quantity UI, address, payment method, order summary |
| Wishlist | Grid of saved products with remove-on-tap heart icon |
| Order Confirmed | Illustration + confirmation message + "Continue Shopping" CTA |
| Profile | Read-only username/email display, logout with confirmation |

---

## 🔒 Authentication Flow

```
First (Onboarding)
    └── Login
          ├── Success → fetch cart & wishlist → Home
          └── Failure → SnackBar error
    └── Signup
          └── Success → redirect to Login
```

---

## 📝 Notes
- Address and payment method on the cart screen are static placeholders.

---

## 🪪 License

This project is for educational purposes. Feel free to use and modify it.
