-- Database initialization script
-- This only creates the schema, data seeding is handled by the Next.js API

-- Create the status enum type
CREATE TYPE status AS ENUM ('active', 'inactive', 'archived');

-- Create the products table
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  image_url TEXT NOT NULL,
  name TEXT NOT NULL,
  status status NOT NULL,
  price NUMERIC(10, 2) NOT NULL,
  stock INTEGER NOT NULL,
  available_at TIMESTAMP NOT NULL
);

-- Create indexes for better performance
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_status ON products(status);

-- Log completion
\echo 'Database schema created successfully. Data seeding will be handled by the application.'