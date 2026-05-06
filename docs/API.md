# Farmsy API Documentation

## Overview
This document outlines the core APIs provided by the Farmsy backend service. The actual implementations are generated via NestJS Swagger module, but this serves as a high-level reference.

## Base URL
`/api/v1`

## Authentication & Authorization
All endpoints requiring authentication must include a valid JWT token in the `Authorization` header: `Bearer <token>`.

---

## 1. Auth APIs

### `POST /auth/register`
Register a new user (Farmer, Consumer, etc.).
- **Body:** `{ "phone": "+91...", "role": "FARMER", ... }`

### `POST /auth/login`
Login via OTP or Password.
- **Body:** `{ "phone": "+91...", "password": "..." }`
- **Response:** `{ "accessToken": "...", "refreshToken": "..." }`

---

## 2. Product APIs

### `GET /products`
Retrieve a paginated list of products.
- **Query Params:** `?page=1&limit=20&category=vegetables&isOrganic=true`

### `GET /products/:id`
Get detailed information about a single product.

### `POST /products` *(Requires FARMER or ADMIN role)*
Create a new product listing.
- **Body:** `{ "name": "Tomatoes", "price": 40.0, "unit": "kg", "inventory": 500, "categoryId": "...", "farmId": "..." }`

---

## 3. Order APIs

### `POST /orders` *(Requires authentication)*
Place a new order.
- **Body:** `{ "items": [{ "productId": "...", "quantity": 5 }], "shippingAddress": "..." }`

### `GET /orders`
Get order history for the current user.

### `PATCH /orders/:id/status` *(Requires ADMIN or DELIVERY_PARTNER role)*
Update the status of an order.

---

## 4. Payment APIs

### `POST /payments/initiate`
Initiate a payment gateway session (e.g., Razorpay/Stripe).
- **Body:** `{ "orderId": "..." }`

### `POST /payments/webhook`
Webhook endpoint for payment gateway to post transaction results.

---

## 5. Logistics APIs

### `GET /deliveries/available` *(Requires DELIVERY_PARTNER role)*
Get a list of available deliveries near the partner's location.

### `PATCH /deliveries/:id/accept` *(Requires DELIVERY_PARTNER role)*
Accept a delivery assignment.

### `PATCH /deliveries/:id/location` *(Requires DELIVERY_PARTNER role)*
Update live location for tracking.

---

## 6. AI & Analytics APIs

### `GET /ai/demand-prediction` *(Requires FARMER, CORPORATE_BUYER, or ADMIN role)*
Get AI-driven demand predictions based on region and historical data.

### `GET /ai/crop-suggestions` *(Requires FARMER role)*
Get crop suggestions based on soil health and seasonal data.

---

## API Documentation (Swagger)
For detailed schemas, parameters, and interactive testing, visit the Swagger UI at:
`http://localhost:3000/api/docs` (when running locally)
