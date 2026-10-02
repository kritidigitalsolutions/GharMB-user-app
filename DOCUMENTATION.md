# 🏡 GharMB User App — Complete Project & API Documentation

A comprehensive guide covering the Flutter mobile application architecture, tech stack, feature workflows, and complete Backend REST API specifications.

---

## 📑 Table of Contents
1. [Part 1: Project & Architecture Documentation](#part-1-project--architecture-documentation)
   - [1.1 Project Overview](#11-project-overview)
   - [1.2 Tech Stack & Key Libraries](#12-tech-stack--key-libraries)
   - [1.3 Folder & Code Structure](#13-folder--code-structure)
   - [1.4 Core User Flows & Features](#14-core-user-flows--features)
   - [1.5 State Management & Routing Architecture](#15-state-management--routing-architecture)
   - [1.6 How to Run & Build](#16-how-to-run--build)
2. [Part 2: Backend API Specifications & Requirements](#part-2-backend-api-specifications--requirements)
   - [2.1 Global Standards & Conventions](#21-global-standards--conventions)
   - [2.2 Authentication & User Onboarding Endpoints](#22-authentication--user-onboarding-endpoints)
   - [2.3 Home & Banners Endpoints](#23-home--banners-endpoints)
   - [2.4 Properties Endpoints (Buy / Rent / Post)](#24-properties-endpoints-buy--rent--post)
   - [2.5 Commercial Spaces Endpoints](#25-commercial-spaces-endpoints)
   - [2.6 Projects & Developers Endpoints](#26-projects--developers-endpoints)
   - [2.7 Wishlist Endpoints](#27-wishlist-endpoints)
   - [2.8 Notifications Endpoints](#28-notifications-endpoints)
   - [2.9 Legal, Support & Static Content Endpoints](#29-legal-support--static-content-endpoints)

---

# Part 1: Project & Architecture Documentation

## 1.1 Project Overview
**GharMB** is a full-featured real estate mobile application built for iOS and Android using Flutter. It is designed to provide property buyers, tenants, owners, real estate agents, and builders with a smooth marketplace experience.

### Key Capabilities:
- **Property Discovery:** Verified residential & commercial listings, map/radius-based search ("Near Me"), advanced multi-criteria filters.
- **Post Property Pipeline:** Multi-step wizard to upload and list properties with photos, videos, and specifications.
- **Token Booking:** Direct advance token booking and key handover tracking for verified property reservations.
- **Builder Projects & Developers:** Township showcases, project plans, verified builder profiles, ratings, and instant inquiry forms.
- **Utilities & Services:** Real-time EMI/Loan Calculator, Area Unit Converter, and requests for home loans, interior design, legal advice, and packers/movers.

---

## 1.2 Tech Stack & Key Libraries

| Category | Package / Tool | Version | Description |
| :--- | :--- | :--- | :--- |
| **Language & Framework** | **Flutter / Dart** | SDK `^3.11.5` | Cross-platform mobile client |
| **State Management** | `flutter_riverpod` & `riverpod` | `^3.3.2` | Clean, decoupled state management & DI |
| **Routing** | `go_router` | `^17.3.0` | Declarative, URL-based deep linking & route guards |
| **Networking** | `dio` | `^5.10.0` | HTTP client with interceptors, cancellation & error handling |
| **Persistence** | `shared_preferences` | `^2.5.5` | Token storage & cached user preferences |
| **Location & Maps** | `geolocator`, `geocoding` | `^14.0.2`, `^4.0.0` | GPS location fetching & reverse geocoding |
| **Push Notifications** | `firebase_messaging`, `flutter_local_notifications` | `^16.5.0`, `^22.3.0` | Remote & local notifications |
| **Authentication** | `google_sign_in` | `^6.2.2` | Google OAuth authentication |
| **UI Components** | `carousel_slider`, `shimmer`, `font_awesome_flutter` | `^5.1.2`, `^4.0.0` | Carousels, skeleton loaders & modern icon pack |
| **Media Picking** | `image_picker`, `file_picker` | `^1.2.2`, `^11.0.2` | Camera / Gallery image and document pickers |

---

## 1.3 Folder & Code Structure

```text
lib/
├── main.dart                       # App entrypoint (Firebase init, Riverpod ProviderScope, GoRouter)
│
├── core/                           # Shared core services & utilities
│   ├── constants/                  # AppUrls, Colors, Strings, Assets constants
│   ├── data/
│   │   ├── exception/              # Custom AppExceptions (FetchData, BadRequest, Unauthorised)
│   │   └── network/                # NetworkApiService with Dio & Multipart upload
│   ├── theme/                      # App theme colors, font styles & widget themes
│   └── utils/                      # AuthStorage / LocalStorageService helpers
│
├── routes/                         # Navigation Layer
│   ├── app_page.dart               # Static route names & path definitions
│   └── app_routes.dart             # GoRouter instance, redirects, and route transitions
│
├── features/                       # Feature-Driven Modules
│   ├── auth/                       # Login, OTP verification, Google Auth, Basic Info setup
│   │   ├── models/                 # Request/Response models
│   │   ├── providers/              # Riverpod auth providers
│   │   ├── repo/                   # Auth HTTP repositories
│   │   └── views/                  # UI screens (Login, OTP, Role Selection, Basic Info)
│   │
│   ├── home/                       # Home screen, banner carousels, category grid, top listings
│   ├── property/                   # Property listings, detail page, booking, Add-Property wizard
│   ├── commercial/                 # Commercial spaces, filters, office/shop details
│   ├── project/                    # Builder projects, master plans, floor layouts
│   ├── developer/                  # Developer directory, profile overview, reviews & enquiries
│   ├── profile/                    # User dashboard, my listed properties, edit profile, settings
│   ├── wishlist/                   # Saved & bookmarked properties
│   ├── real_state_news/            # Real estate market news, articles, categories
│   └── quick_access/               # Services (Home Loans, Legal, Interiors, Packers & Movers)
│
└── shared/                         # Reusable UI Components
    ├── button/                     # Custom styled buttons (Filled, Outlined, Loading state)
    ├── dialog/                     # Popups & modal alerts
    └── widget/                     # Custom Shimmer loader, TextFields, AppBars
```

---

## 1.4 Core User Flows & Features

### 1. Authentication & Onboarding
- **Phone Number Login:** User enters phone number ➔ Backend sends OTP ➔ User enters OTP ➔ Backend validates and issues JWT token.
- **Google Sign-In:** One-tap sign in via Google OAuth.
- **Onboarding Setup:** For new users, prompts for Name, Email, Preferred Role (Buyer, Owner, Agent, Developer) and location preferences.

### 2. Property Discovery & Search
- **Geo-location Search:** Automatically queries `/api/properties/near-me` with current GPS coordinates or allows manual city selection.
- **Filters:** Allows filtering by Buy/Rent, Property Type (Apartment, Independent House, Villa, Plot), Price range, and BHK count.
- **Detailed View:** High-resolution image carousel, tour videos, floor plans, specs, key handover status, and agent/seller contact actions.

### 3. Multi-Step Post Property Pipeline
1. **Basic Info:** Listing category (Sell / Rent), Property type, City, Locality, and Pincode.
2. **Specs:** Carpet area, Super area, Bedrooms, Bathrooms, Balconies, Floor number, Furnishing status.
3. **Media Upload:** Uploads multiple photos and tour videos via multipart API.
4. **Pricing:** Expected price, maintenance charges, security deposit, and possession date.
5. **Review & Post:** Live preview before final submission to `/api/user/properties`.

### 4. Utilities & Value-Added Services
- **Loan / EMI Calculator:** Interactive slider to calculate monthly installments and total interest based on Principal, Rate %, and Tenure.
- **Unit Converter:** Real-time conversion between Sq. Feet, Sq. Yards, Sq. Meters, Acres, and Bigha.
- **Home Services:** In-app inquiry requests for Legal Advice, Home Loans, Packers & Movers, and Interior Designers.

---

## 1.5 State Management & Routing Architecture
- **State Management:** Follows Riverpod's `StateNotifierProvider` / `NotifierProvider` pattern. Business logic is separated into repositories (`*Repo`) and state controllers (`*Provider`), keeping views strictly declarative.
- **Routing:** Handled with `GoRouter`. Route guards verify if a user is authenticated (`LocalStorageService.getToken()`) before allowing access to protected views (e.g. Post Property, Profile Dashboard).

---

## 1.6 How to Run & Build

```bash
# 1. Install packages
flutter pub get

# 2. Run in debug mode on connected device/emulator
flutter run

# 3. Generate Android Release APK
flutter build apk --release

# 4. Generate Android App Bundle (for Play Store)
flutter build appbundle --release

# 5. Generate iOS Archive (macOS only)
flutter build ipa --release
```

---
---

# Part 2: Backend API Specifications & Requirements

## 2.1 Global Standards & Conventions
- **Base URL:** `http://<your-server-domain-or-ip>:5001/api`
- **Request Format:** `application/json` (except file uploads which use `multipart/form-data`)
- **Authentication:** `Bearer <JWT_TOKEN>` in the `Authorization` header for protected endpoints.
- **Standard Success Response Format:**
  ```json
  {
    "status": "success",
    "message": "Operation completed successfully",
    "data": {}
  }
  ```
- **Standard Error Response Format:**
  ```json
  {
    "status": "error",
    "message": "Invalid credentials or request error",
    "errors": []
  }
  ```

---

## 2.2 Authentication & User Onboarding Endpoints

### 1. Send OTP (Login / Register Initiation)
- **Method:** `POST`
- **Endpoint:** `/api/user/auth/send-otp`
- **Auth:** Public
- **Request Body:**
  ```json
  {
    "phone": "9876543210"
  }
  ```
- **Response:**
  ```json
  {
    "status": "success",
    "message": "OTP sent successfully",
    "data": {
      "otpSent": true,
      "expiresIn": 300
    }
  }
  ```

### 2. Verify OTP
- **Method:** `POST`
- **Endpoint:** `/api/user/auth/verify-otp`
- **Auth:** Public
- **Request Body:**
  ```json
  {
    "phone": "9876543210",
    "otp": "123456"
  }
  ```
- **Response:**
  ```json
  {
    "status": "success",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "data": {
      "_id": "64f1a2b3c4d5e6f7a8b9c0d1",
      "phone": "9876543210",
      "name": "Alex Smith",
      "email": "alex@example.com",
      "role": "buyer",
      "isProfileComplete": true
    }
  }
  ```

### 3. Google OAuth Login
- **Method:** `POST`
- **Endpoint:** `/api/user/auth/google`
- **Auth:** Public
- **Request Body:**
  ```json
  {
    "idToken": "google_id_token_string",
    "token": "google_access_token_string",
    "email": "user@gmail.com",
    "name": "Alex Smith",
    "photoUrl": "https://lh3.googleusercontent.com/..."
  }
  ```
- **Response:** Returns JWT token & user profile object.

### 4. Submit Basic Info / Complete Profile
- **Method:** `POST`
- **Endpoint:** `/api/user/auth/basic-info`
- **Auth:** Protected (`Bearer <Token>`)
- **Request Body:**
  ```json
  {
    "name": "Alex Smith",
    "email": "alex@example.com",
    "role": "seller",
    "city": "Mumbai"
  }
  ```

### 5. Get Current User Profile
- **Method:** `GET`
- **Endpoint:** `/api/users/me`
- **Auth:** Protected (`Bearer <Token>`)

### 6. Update User Profile
- **Method:** `PATCH`
- **Endpoint:** `/api/users/update-me`
- **Auth:** Protected (`Bearer <Token>`)
- **Request Body:**
  ```json
  {
    "name": "Alex Smith",
    "email": "alex.new@example.com",
    "city": "Pune",
    "avatar": "https://cdn.gharmb.com/users/avatar1.jpg"
  }
  ```

### 7. File & Media Upload
- **Method:** `POST`
- **Endpoint:** `/api/user/upload/multiple`
- **Auth:** Protected (`Bearer <Token>`)
- **Content-Type:** `multipart/form-data`
- **Payload:** `files` (Array of binary image/video files), `folder` (string, e.g. `properties`)
- **Response:**
  ```json
  {
    "status": "success",
    "data": {
      "urls": [
        "https://cdn.gharmb.com/properties/img_01.jpg",
        "https://cdn.gharmb.com/properties/img_02.jpg"
      ]
    }
  }
  ```

---

## 2.3 Home & Banners Endpoints

### 1. Get Home Screen Banners
- **Method:** `GET`
- **Endpoint:** `/api/banners/home`
- **Auth:** Public
- **Response:**
  ```json
  {
    "status": "success",
    "data": [
      {
        "_id": "ban_001",
        "title": "Exclusive Offers on Luxury Villas",
        "imageUrl": "https://cdn.gharmb.com/banners/villa_offer.jpg",
        "actionUrl": "gharmb://property/verified?category=villa",
        "position": "home_top"
      }
    ]
  }
  ```

### 2. Log Banner Click
- **Method:** `POST`
- **Endpoint:** `/api/banners/:id/click`
- **Auth:** Public

---

## 2.4 Properties Endpoints (Buy / Rent / Post)

### 1. List Verified Properties
- **Method:** `GET`
- **Endpoint:** `/api/properties/verified`
- **Auth:** Public
- **Query Parameters:**
  - `page` (default: 1)
  - `limit` (default: 20)
  - `category` (`residential` | `commercial`)
  - `listingFor` (`sale` | `rent`)
  - `propertyType` (`apartment`, `villa`, `independent_house`, `plot`)
  - `city`, `locality`
  - `minPrice`, `maxPrice`
  - `search`

### 2. Near-Me Geo-Spatial Properties
- **Method:** `GET`
- **Endpoint:** `/api/properties/near-me`
- **Auth:** Public
- **Query Parameters:**
  - `lat` (latitude, e.g. `19.0760`)
  - `lng` (longitude, e.g. `72.8777`)
  - `radius` (default: 50)
  - `radiusUnit` (default: `km`)
  - `city` (optional)

### 3. Add / Post New Property
- **Method:** `POST`
- **Endpoint:** `/api/user/properties`
- **Auth:** Protected (`Bearer <Token>`)
- **Request Body:**
  ```json
  {
    "title": "3 BHK Luxury High-rise Flat",
    "description": "Corner apartment with scenic city view and modular kitchen.",
    "category": "residential",
    "listingFor": "sale",
    "propertyType": "apartment",
    "bhk": 3,
    "carpetArea": 1350,
    "superArea": 1650,
    "price": 14500000,
    "maintenance": 4500,
    "address": {
      "addressLine": "Tower 4, Green Valley Heights",
      "city": "Mumbai",
      "locality": "Andheri West",
      "pincode": "400053",
      "lat": 19.1363,
      "lng": 72.8277
    },
    "amenities": ["Swimming Pool", "Clubhouse", "24/7 Security", "Covered Parking", "Power Backup"],
    "images": [
      "https://cdn.gharmb.com/properties/flat1.jpg",
      "https://cdn.gharmb.com/properties/flat2.jpg"
    ],
    "videos": [
      "https://cdn.gharmb.com/properties/tour.mp4"
    ]
  }
  ```
- **Response:**
  ```json
  {
    "status": "success",
    "message": "Property submitted for verification successfully",
    "data": {
      "submissionId": "prop_sub_98124"
    }
  }
  ```

### 4. Toggle Key Handover Status
- **Method:** `PATCH`
- **Endpoint:** `/api/properties/:id/key-handover`
- **Auth:** Protected (`Bearer <Token>`)
- **Request Body:**
  ```json
  { "keyHandover": true }
  ```

### 5. My Listed Properties (User Dashboard)
- **Method:** `GET`
- **Endpoint:** `/api/properties/my-dashboard`
- **Auth:** Protected (`Bearer <Token>`)

---

## 2.5 Commercial Spaces Endpoints

### 1. List Commercial Spaces
- **Method:** `GET`
- **Endpoint:** `/api/commercial-spaces`
- **Query Parameters:** `spaceType`, `listingFor`, `minPrice`, `maxPrice`, `minArea`, `maxArea`, `city`, `locality`, `search`, `page`, `limit`

### 2. Featured Commercial Spaces
- **Method:** `GET`
- **Endpoint:** `/api/commercial-spaces/featured`

### 3. Commercial Space Details
- **Method:** `GET`
- **Endpoint:** `/api/commercial-spaces/:id`

### 4. Commercial Space Types / Categories
- **Method:** `GET`
- **Endpoint:** `/api/commercial-spaces/types`
- **Response:** List of categories (e.g. `Office`, `Retail Shop`, `Showroom`, `Warehouse`, `Co-working Space`)

---

## 2.6 Projects & Developers Endpoints

### 1. List Builder Township Projects
- **Method:** `GET`
- **Endpoint:** `/api/projects`
- **Query Parameters:** `city`, `status` (`ongoing`, `ready_to_move`), `builderId`

### 2. List All Verified Developers
- **Method:** `GET`
- **Endpoint:** `/api/users/developers`

### 3. Get Developer Details & Portfolio
- **Method:** `GET`
- **Endpoint:** `/api/developers/:id`

### 4. Send Lead / Inquiry to Developer
- **Method:** `POST`
- **Endpoint:** `/api/developers/:developerId/enquiry`
- **Auth:** Protected (`Bearer <Token>`)
- **Request Body:**
  ```json
  {
    "name": "Jane Doe",
    "phone": "9876543210",
    "email": "jane@example.com",
    "message": "Interested in site visit this weekend."
  }
  ```

### 5. Developer Reviews & Ratings
- `GET /api/developers/:developerId/reviews` — Fetch reviews for a developer.
- `POST /api/developers/:developerId/reviews` — Submit a review (`{ "rating": 5, "comment": "Great experience!" }`).
- `DELETE /api/developers/:developerId/reviews` — Delete user review.

---

## 2.7 Wishlist Endpoints *(Protected)*

- `GET /api/wishlist` — Fetch saved properties.
- `POST /api/wishlist/toggle` — Add or remove a property:
  ```json
  { "propertyId": "64f1a2b3c4d5e6f7a8b9c0d1" }
  ```
- `GET /api/wishlist/check/:id` — Check if a property is already in wishlist.
- `DELETE /api/wishlist/:id` — Remove property from wishlist.

---

## 2.8 Notifications Endpoints *(Protected)*

- `GET /api/notifications` — Fetch notifications list with pagination.
- `PATCH /api/notifications/:id/read` — Mark a single notification as read.
- `PATCH /api/notifications/mark-all-read` — Mark all user notifications as read.
- `DELETE /api/notifications/:id` — Delete a notification.
- `DELETE /api/notifications/clear-all` — Clear all notifications.

---

## 2.9 Legal, Support & Static Content Endpoints

- `GET /api/legal/terms` — Returns Terms & Conditions.
- `GET /api/legal/privacy-policy` — Returns Privacy Policy.
- `GET /api/pages/about-us` — Returns About Us content and company info.
- `GET /api/pages/help-support` — Returns FAQs, contact emails, and helpline numbers.
