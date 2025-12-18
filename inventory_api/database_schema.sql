-- Database Schema for Inventory Management System
-- Run this SQL script to create all necessary tables

-- Create database
CREATE DATABASE IF NOT EXISTS inventory_management;
USE inventory_management;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    nim VARCHAR(20),
    program_studi VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_username (username)
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category_name (category_name)
);

-- Locations table
CREATE TABLE IF NOT EXISTS locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    location_name VARCHAR(100) NOT NULL,
    building VARCHAR(100),
    room_number VARCHAR(50),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_location_name (location_name)
);

-- Items table
CREATE TABLE IF NOT EXISTS items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    barcode VARCHAR(100) UNIQUE,
    sku VARCHAR(100) UNIQUE,
    item_name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INT,
    location_id INT,
    quantity INT NOT NULL DEFAULT 0,
    min_stock INT DEFAULT 5,
    unit_price DECIMAL(10,2),
    total_value DECIMAL(10,2),
    condition_status ENUM('good', 'fair', 'poor', 'damaged') DEFAULT 'good',
    image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL,
    INDEX idx_barcode (barcode),
    INDEX idx_sku (sku),
    INDEX idx_item_name (item_name),
    INDEX idx_category (category_id),
    INDEX idx_location (location_id)
);

-- Loans table
CREATE TABLE IF NOT EXISTS loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    borrower_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    quantity INT NOT NULL DEFAULT 1,
    status ENUM('active', 'returned', 'overdue') DEFAULT 'active',
    condition_borrowed ENUM('good', 'fair', 'poor', 'damaged') DEFAULT 'good',
    condition_returned ENUM('good', 'fair', 'poor', 'damaged') NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (borrower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_item (item_id),
    INDEX idx_borrower (borrower_id),
    INDEX idx_status (status),
    INDEX idx_loan_date (loan_date),
    INDEX idx_due_date (due_date)
);

-- Stock movements table (for tracking inventory changes)
CREATE TABLE IF NOT EXISTS stock_movements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    movement_type ENUM('in', 'out', 'adjustment') NOT NULL,
    quantity INT NOT NULL,
    reason VARCHAR(255),
    reference_id INT, -- Could reference loan_id or other transaction
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_item (item_id),
    INDEX idx_type (movement_type),
    INDEX idx_created_at (created_at)
);

-- Insert sample data
-- Sample categories
INSERT INTO categories (category_name, description) VALUES
('Elektronik', 'Barang elektronik dan gadget'),
('Furniture', 'Mebel dan peralatan kantor'),
('Alat Tulis', 'Peralatan tulis dan stationery'),
('Laboratorium', 'Peralatan laboratorium');

-- Sample locations
INSERT INTO locations (location_name, building, room_number, description) VALUES
('Gudang A', 'Gedung Utama', '101', 'Gudang utama penyimpanan barang'),
('Gudang B', 'Gedung Utama', '102', 'Gudang cadangan'),
('Lab Mobile', 'Gedung Teknik', '201', 'Laboratorium Mobile Computing'),
('Lab Komputer', 'Gedung Teknik', '202', 'Laboratorium Komputer');

-- Sample admin user (password: admin123)
INSERT INTO users (username, email, full_name, password_hash, role) VALUES
('admin', 'admin@inventory.com', 'Administrator', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- Sample regular user (password: user123)
INSERT INTO users (username, email, full_name, password_hash, role, nim, program_studi) VALUES
('student', 'student@university.edu', 'John Doe', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', '12345678', 'Teknik Informatika');

-- Sample items
INSERT INTO items (item_name, description, category_id, location_id, quantity, min_stock, unit_price, condition_status) VALUES
('Laptop ASUS ROG', 'Laptop gaming untuk mahasiswa', 1, 3, 5, 2, 15000000.00, 'good'),
('Proyektor Epson', 'Proyektor untuk presentasi', 1, 4, 3, 1, 5000000.00, 'good'),
('Meja Kantor', 'Meja kerja ergonomis', 2, 1, 10, 3, 750000.00, 'good'),
('Kursi Kantor', 'Kursi ergonomis', 2, 1, 15, 5, 500000.00, 'fair'),
('Spidol Boardmarker', 'Spidol untuk papan tulis', 3, 2, 50, 10, 5000.00, 'good'),
('Arduino Uno', 'Board microcontroller', 4, 3, 8, 3, 150000.00, 'good');