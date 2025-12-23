# Vehicle Rental Management System
A comprehensive PostgreSQL based vehicle rental management system for managing users, vehicles, and bookings efficiently.

## ✨Features
- **User Management:** Support for Admin and Customer roles with authentication
- **Vehicle Inventory:** Track cars, bikes, and trucks with real-time availability
- **Advanced Queries:** Predefined queries for common business operations
- **Data Integrity:** Referential integrity with foreign key constraints
- **Type Safety:** Enum types for status and role management

## Tables and Entity Relationship Diagram
The system manages
- **Users**
- **Vehicles**
- **Bookings**
---
Diagram using DrawSQL 
[Click to view](https://drawsql.app/teams/md-manik/diagrams/assignment-3)
Or copy this link bellow and show in your browser
```
https://drawsql.app/teams/md-manik/diagrams/assignment-3
```
## 📊 Tables Structure
### Users table
```sql
CREATE TYPE user_role AS enum('Admin', 'Customer');
CREATE TABLE users (
  user_id serial PRIMARY KEY,
  name varchar(50) NOT NULL,
  email varchar(100) NOT NULL UNIQUE,
  password varchar(250) NOT NULL,
  phone varchar(25) NOT NULL,
  role user_role NOT NULL
);
```
### Vehicles Table
```sql
CREATE TYPE vehicle_type AS enum('car', 'bike', 'truck');
CREATE TYPE availability AS enum('available', 'rented', 'maintenance');
CREATE TABLE vehicles (
  vehicle_id serial PRIMARY KEY,
  vehicle_name varchar(100) NOT NULL,
  type vehicle_type NOT NULL,
  model int NOT NULL,
  registration_number varchar(50) NOT NULL UNIQUE,
  rental_price int NOT NULL,
  availability_status availability NOT NULL
);
```
### Bookings Table
```sql
CREATE TYPE booking_status_enum AS enum('pending', 'confirmed', 'completed', 'cancelled');
CREATE TABLE bookings (
  booking_id serial PRIMARY KEY,
  user_id int REFERENCES users (user_id) NOT NULL,
  vehicle_id int REFERENCES vehicles (vehicle_id) NOT NULL,
  rent_start_date date NOT NULL,
  rent_end_date date NOT NULL,
  booking_status booking_status_enum NOT NULL,
  total_cost int NOT NULL
);
```
## 🔑 Key Queries
### Query 1: Retrieve Booking Information
Get complete booking details with customer and vehicle information.
```sql
SELECT
  booking_id,
  name AS customer_name,
  vehicle_name,
  rent_start_date,
  rent_end_date,
  booking_status
FROM
  bookings
  JOIN users USING (user_id)
  JOIN vehicles USING (vehicle_id);
```
### Query 2: Find Unbooked Vehicles
Identify vehicles that have never been rented.
```sql
SELECT
  *
FROM
  vehicles
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      bookings
    WHERE
      bookings.vehicle_id = vehicles.vehicle_id
  );
```
### Query 3: Available Cars
Find all available cars.
```sql
SELECT
  *
FROM
  vehicles
WHERE
  availability_status = 'available'
  AND type = 'car';
```
### Query 4: Popular Vehicles
Find vehicles with more than 2 bookings.
```sql
SELECT
  vehicle_name,
  count(*) AS total_bookings
FROM
  bookings
  JOIN vehicles USING (vehicle_id)
GROUP BY
  vehicle_name
HAVING
  count(*) > 2;
```
## 📝 Sample Data
### Insert Sample Users
```sql
INSERT INTO users (name, email, password, phone, role) VALUES
('John Doe', 'john@example.com', 'hashed_pass_123', '+1234567890', 'Admin'),
('Jane Smith', 'jane@example.com', 'hashed_pass_456', '+1987654321', 'Customer'),
('Robert Johnson', 'robert@example.com', 'hashed_pass_789', '+1555123456', 'Customer');
```
### Insert Sample Vehicles
```sql
INSERT INTO vehicles (vehicle_name, type, model, registration_number, rental_price, availability_status) VALUES
('Toyota Camry', 'car', 2023, 'ABC123', 50, 'available'),
('Honda Civic', 'car', 2022, 'XYZ789', 45, 'rented'),
('Ford F-150', 'truck', 2021, 'TRK001', 80, 'available');
```
### Insert Sample Bookings
```sql
INSERT INTO bookings (user_id, vehicle_id, rent_start_date, rent_end_date, booking_status, total_cost) VALUES
(2, 1, '2024-01-15', '2024-01-20', 'completed', 250),
(3, 2, '2024-02-01', '2024-02-05', 'confirmed', 225);
```
