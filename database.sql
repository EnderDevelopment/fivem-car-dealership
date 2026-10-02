CREATE TABLE IF NOT EXISTS car_dealership_cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    label VARCHAR(50) NOT NULL
);

INSERT INTO car_dealership_cars (model, price, label) VALUES
('adder', 500000, 'Adder'),
('banshee', 100000, 'Banshee'),
('bullet', 300000, 'Bullet');