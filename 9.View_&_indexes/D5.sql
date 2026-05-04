-- Create a products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    last_restock_date DATE
);

INSERT INTO products (product_name, category, price, stock_quantity, last_restock_date) VALUES
('Laptop Pro', 'Electronics', 1299.99, 25, '2023-05-15'),
('Wireless Mouse', 'Electronics', 29.99, 100, '2023-06-01'),
('Desk Chair', 'Furniture', 199.50, 15, '2023-04-20'),
('Notebook', 'Office', 4.99, 200, '2023-06-10'),
('Monitor 24"', 'Electronics', 179.99, 30, '2023-05-28'),
('Coffee Mug', 'Kitchen', 8.95, 75, '2023-06-05'),
('Keyboard', 'Electronics', 59.99, 45, '2023-05-30');

-- Create orders table with auto-increment
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE DEFAULT CURRENT_DATE,
    employee_id INT REFERENCES employees(employee_id),
    status VARCHAR(20) CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

INSERT INTO orders (customer_name, order_date, employee_id, status) VALUES
('Acme Corp', '2023-06-01', 1, 'Shipped'),
('Globex', '2023-06-02', 3, 'Pending'),
('Initech', '2023-06-03', 6, 'Delivered'),
('Hooli', '2023-06-04', 10, 'Shipped'),
('Soylent', '2023-06-05', 1, 'Pending');

-- Order details junction table
CREATE TABLE order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price DECIMAL(10,2)
);

INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 1199.99),
(1, 3, 5, 189.50),
(2, 2, 10, 29.99),
(2, 7, 5, 59.99),
(3, 5, 3, 179.99),
(4, 1, 1, 1299.99),
(4, 2, 3, 29.99),
(5, 4, 20, 4.99),
(5, 6, 15, 8.95);