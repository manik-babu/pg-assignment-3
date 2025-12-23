-- Users table
CREATE TYPE user_role AS enum('Admin', 'Customer');
CREATE TABLE users (
  user_id serial PRIMARY KEY,
  name varchar(50) NOT NULL,
  email varchar(100) NOT NULL UNIQUE,
  password varchar(250) NOT NULL,
  phone varchar(25) NOT NULL,
  role user_role NOT NULL
);

-- Vehicles table
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

-- Bookings table
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


-- QUERY-1 Retrieve booking information along with Customer name and Vehicle name
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


-- QUERY-2 Find all vehicles that have never been booked
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


-- QUERY-3 Retrieve all available vehicles of a specific type (e.g. cars)
SELECT
  *
FROM
  vehicles
WHERE
  availability_status = 'available'
  AND type = 'car';


-- QUERY-4 Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings
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