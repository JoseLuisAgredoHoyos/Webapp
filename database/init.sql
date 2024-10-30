-- Crear la tabla de productos
CREATE TABLE IF NOT EXISTS product (
 id SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 description TEXT,
 price DECIMAL(10, 2) NOT NULL,
 stock INTEGER NOT NULL DEFAULT 0
);
-- Insertar datos de ejemplo
INSERT INTO product (name, description, price, stock) VALUES
 ('Laptop', 'Potente laptop para trabajo y juegos', 5759000, 50),
 ('Smartphone', 'Último modelo con cámara de alta resolución', 2365000, 100),
 ('Auriculares', 'Auriculares inalámbricos con cancelación de ruido', 459000, 7),
 ('Tablet', 'Tablet ligera ideal para viajes', 2349000, 30),
 ('Monitor', 'Monitor 4K de 27 pulgadas', 799000, 25);
