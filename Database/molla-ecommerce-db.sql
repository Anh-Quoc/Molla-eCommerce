-- DROP DATABASE IF EXISTS molla_ecommerce;
--
-- CREATE DATABASE molla_ecommerce;


CREATE TABLE permission_group
(
    id          INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    name        VARCHAR(20) UNIQUE,
    permissions JSONB                NOT NULL,
    active      BOOLEAN DEFAULT TRUE NOT NULL
);
INSERT INTO permission_group (name,
                              permissions)
VALUES ('Admin',
        '[
          {
            "resource": "post",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "comment",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "permission",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "admin",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "manager",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "staff",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "customer",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          }
        ]'::jsonb);

-- Permission for Manager role
INSERT INTO permission_group (name,
                              permissions)
VALUES ('Manager',
        '[
          {
            "resource": "post",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "comment",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "staff",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          }
        ]'::jsonb);

-- Permission for Staff role
INSERT INTO permission_group (name,
                              permissions)
VALUES ('Staff',
        '[
          {
            "resource": "post",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "comment",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          },
          {
            "resource": "customer",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          }
        ]'::jsonb);

-- Permission for Customer role
INSERT INTO permission_group (name,
                              permissions)
VALUES ('Customer',
        '[
          {
            "resource": "post",
            "action": {
              "create": false,
              "read": true,
              "update": false,
              "delete": false
            }
          },
          {
            "resource": "comment",
            "action": {
              "create": true,
              "read": true,
              "update": true,
              "delete": true
            }
          }
        ]'::jsonb);

CREATE TABLE users
(
    id                  INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    full_name           VARCHAR                   NOT NULL,
    email               VARCHAR(30)               NOT NULL UNIQUE,
    password            VARCHAR(80)               NOT NULL CHECK (LENGTH(RTRIM(password)) >= 6),
    permission_group_id INTEGER                   NOT NULL REFERENCES permission_group (id),
    address             VARCHAR,
    phone               VARCHAR(15) UNIQUE,
    dob                 TIMESTAMP,
    last_login          TIMESTAMP,
    created_at          TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    active              BOOLEAN      DEFAULT TRUE NOT NULL
);

CREATE OR REPLACE FUNCTION set_customer_role()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.permission_group_id IS NULL THEN
        NEW.permission_group_id := (
            SELECT id FROM permission_group WHERE name = 'Customer'
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_customer_role
    BEFORE INSERT ON users
    FOR EACH ROW
EXECUTE FUNCTION set_customer_role();

CREATE OR REPLACE FUNCTION set_created_time()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.created_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_created_time
    BEFORE INSERT ON users
    FOR EACH ROW
EXECUTE FUNCTION set_created_time();

CREATE OR REPLACE FUNCTION set_updated_time()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_time
    BEFORE UPDATE ON users
    FOR EACH ROW
EXECUTE FUNCTION set_updated_time();

INSERT INTO users (full_name,
                   email,
                   password,
                   permission_group_id,
                   address,
                   phone,
                   dob,
                   last_login,
                   active)
VALUES ('Jane Doe',
        'jane.doe@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE name = 'Manager'),
        '456 Elm St',
        '555-5678',
        '1985-05-15',
        '2024-08-13 10:00:00',
        true),
       ('Bob Smith',
        'bob.smith@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE name = 'Staff'),
        NULL, -- No address provided
        NULL, -- No phone number provided
        '1978-11-20',
        NULL, -- No last login date provided
        true),
       ('Alice Jones',
        'alice.jones@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE name = 'Customer'),
        '789 Oak St',
        '555-7890',
        '1992-03-10',
        '2024-08-12 09:30:00',
        true);


CREATE TABLE products
(
    id            INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    url           VARCHAR(100) NOT NULL UNIQUE,
    name          VARCHAR(50)  NOT NULL,
    description   TEXT,
    price         DECIMAL(10, 2),
    stock         INTEGER               DEFAULT 1,

    types         JSONB,
    tags          JSONB,

    total_comment INTEGER      NOT NULL DEFAULT 0,
    total_rating  INTEGER,

    created_at    TIMESTAMP(3)          DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP(3)          DEFAULT CURRENT_TIMESTAMP,
    created_by    INTEGER REFERENCES users (id),
    updated_by    INTEGER REFERENCES users (id)
);
INSERT INTO products
(url, name, description, price, stock, types, tags, total_comment, total_rating, created_by, updated_by)
VALUES ('macbook-pro-14', 'MacBook Pro 14', 'Apple MacBook Pro 14 with M2 chip, 16GB RAM, 512GB SSD.', 1999.99, 10, '{
  "category": "laptop",
  "brand": "Apple"
}', '[
  "electronics",
  "computers",
  "apple"
]', 25, 100, 2, 2),
       ('iphone-14', 'iPhone 14', 'Apple iPhone 14 with A16 Bionic chip, 128GB storage.', 899.99, 50, '{
         "category": "smartphone",
         "brand": "Apple"
       }', '[
         "electronics",
         "phones",
         "apple"
       ]', 100, 450, 2, 2),
       ('ipad-pro-12-9', 'iPad Pro 12.9', 'Apple iPad Pro 12.9 with M2 chip, 128GB storage.', 1099.99, 20, '{
         "category": "tablet",
         "brand": "Apple"
       }', '[
         "electronics",
         "tablets",
         "apple"
       ]', 40, 200, 2, 2),
       ('dell-xps-15', 'Dell XPS 15', 'Dell XPS 15 with Intel i7, 16GB RAM, 512GB SSD.', 1499.99, 15, '{
         "category": "laptop",
         "brand": "Dell"
       }', '[
         "electronics",
         "computers",
         "dell"
       ]', 30, 150, 2, 2),
       ('samsung-galaxy-s23', 'Samsung Galaxy S23', 'Samsung Galaxy S23 with Snapdragon 8 Gen 1, 128GB storage.',
        799.99, 45, '{
         "category": "smartphone",
         "brand": "Samsung"
       }', '[
         "electronics",
         "phones",
         "samsung"
       ]', 120, 500, 2, 2),
       ('surface-pro-9', 'Surface Pro 9', 'Microsoft Surface Pro 9 with Intel i7, 16GB RAM, 256GB SSD.', 1199.99, 25, '{
         "category": "tablet",
         "brand": "Microsoft"
       }', '[
         "electronics",
         "tablets",
         "microsoft"
       ]', 50, 220, 2, 2),
       ('hp-spectre-x360', 'HP Spectre x360', 'HP Spectre x360 with Intel i7, 16GB RAM, 512GB SSD.', 1399.99, 12, '{
         "category": "laptop",
         "brand": "HP"
       }', '[
         "electronics",
         "computers",
         "hp"
       ]', 35, 180, 2, 2),
       ('google-pixel-7', 'Google Pixel 7', 'Google Pixel 7 with Tensor chip, 128GB storage.', 699.99, 40, '{
         "category": "smartphone",
         "brand": "Google"
       }', '[
         "electronics",
         "phones",
         "google"
       ]', 90, 400, 2, 2),
       ('lenovo-thinkpad-x1-carbon', 'Lenovo ThinkPad X1 Carbon',
        'Lenovo ThinkPad X1 Carbon with Intel i7, 16GB RAM, 512GB SSD.', 1699.99, 8, '{
         "category": "laptop",
         "brand": "Lenovo"
       }', '[
         "electronics",
         "computers",
         "lenovo"
       ]', 20, 120, 2, 2),
       ('oneplus-11', 'OnePlus 11', 'OnePlus 11 with Snapdragon 8 Gen 1, 128GB storage.', 649.99, 55, '{
         "category": "smartphone",
         "brand": "OnePlus"
       }', '[
         "electronics",
         "phones",
         "oneplus"
       ]', 110, 470, 2, 2),
       ('ipad-air', 'iPad Air', 'Apple iPad Air with A14 Bionic chip, 64GB storage.', 599.99, 30, '{
         "category": "tablet",
         "brand": "Apple"
       }', '[
         "electronics",
         "tablets",
         "apple"
       ]', 45, 190, 2, 2),
       ('razer-blade-15', 'Razer Blade 15', 'Razer Blade 15 with Intel i7, 16GB RAM, 512GB SSD, RTX 3060.', 1799.99, 7,
        '{
          "category": "laptop",
          "brand": "Razer"
        }', '[
         "electronics",
         "computers",
         "razer"
       ]', 18, 110, 2, 2),
       ('xiaomi-mi-13', 'Xiaomi Mi 13', 'Xiaomi Mi 13 with Snapdragon 8 Gen 1, 128GB storage.', 599.99, 60, '{
         "category": "smartphone",
         "brand": "Xiaomi"
       }', '[
         "electronics",
         "phones",
         "xiaomi"
       ]', 95, 420, 2, 2),
       ('surface-laptop-5', 'Surface Laptop 5', 'Microsoft Surface Laptop 5 with Intel i5, 8GB RAM, 256GB SSD.', 999.99,
        22, '{
         "category": "laptop",
         "brand": "Microsoft"
       }', '[
         "electronics",
         "computers",
         "microsoft"
       ]', 30, 160, 2, 2),
       ('samsung-galaxy-tab-s8', 'Samsung Galaxy Tab S8',
        'Samsung Galaxy Tab S8 with Snapdragon 8 Gen 1, 128GB storage.', 699.99, 35, '{
         "category": "tablet",
         "brand": "Samsung"
       }', '[
         "electronics",
         "tablets",
         "samsung"
       ]', 55, 210, 2, 2),
       ('asus-zenbook-14', 'ASUS ZenBook 14', 'ASUS ZenBook 14 with Intel i7, 16GB RAM, 512GB SSD.', 1199.99, 18, '{
         "category": "laptop",
         "brand": "ASUS"
       }', '[
         "electronics",
         "computers",
         "asus"
       ]', 32, 140, 2, 2),
       ('sony-xperia-1-v', 'Sony Xperia 1 V', 'Sony Xperia 1 V with Snapdragon 8 Gen 1, 256GB storage.', 949.99, 20, '{
         "category": "smartphone",
         "brand": "Sony"
       }', '[
         "electronics",
         "phones",
         "sony"
       ]', 85, 390, 2, 2),
       ('ipad-mini', 'iPad Mini', 'Apple iPad Mini with A15 Bionic chip, 64GB storage.', 499.99, 28, '{
         "category": "tablet",
         "brand": "Apple"
       }', '[
         "electronics",
         "tablets",
         "apple"
       ]', 40, 170, 2, 2),
       ('huawei-matebook-x-pro', 'Huawei MateBook X Pro', 'Huawei MateBook X Pro with Intel i7, 16GB RAM, 512GB SSD.',
        1499.99, 9, '{
         "category": "laptop",
         "brand": "Huawei"
       }', '[
         "electronics",
         "computers",
         "huawei"
       ]', 22, 130, 2, 2),
       ('google-pixel-6a', 'Google Pixel 6a', 'Google Pixel 6a with Tensor chip, 128GB storage.', 449.99, 50, '{
         "category": "smartphone",
         "brand": "Google"
       }', '[
         "electronics",
         "phones",
         "google"
       ]', 105, 450, 2, 2),
       ('acer-predator-helios-300', 'Acer Predator Helios 300',
        'Acer Predator Helios 300 with Intel i7, 16GB RAM, 512GB SSD, RTX 3060.', 1499.99, 11, '{
         "category": "laptop",
         "brand": "Acer"
       }', '[
         "electronics",
         "computers",
         "acer"
       ]', 30, 160, 2, 2),
       ('oppo-find-x5-pro', 'Oppo Find X5 Pro', 'Oppo Find X5 Pro with Snapdragon 8 Gen 1, 256GB storage.', 899.99, 38,
        '{
          "category": "smartphone",
          "brand": "Oppo"
        }', '[
         "electronics",
         "phones",
         "oppo"
       ]', 88, 410, 2, 2),
       ('samsung-galaxy-book-pro', 'Samsung Galaxy Book Pro',
        'Samsung Galaxy Book Pro with Intel i5, 8GB RAM, 256GB SSD.', 1099.99, 17, '{
         "category": "laptop",
         "brand": "Samsung"
       }', '[
         "electronics",
         "computers",
         "samsung"
       ]', 29, 150, 2, 2),
       ('lenovo-tab-p12-pro', 'Lenovo Tab P12 Pro', 'Lenovo Tab P12 Pro with Snapdragon 870, 128GB storage.', 649.99,
        25, '{
         "category": "tablet",
         "brand": "Lenovo"
       }', '[
         "electronics",
         "tablets",
         "lenovo"
       ]', 45, 200, 2, 2),
       ('microsoft-surface-duo-2', 'Microsoft Surface Duo 2',
        'Microsoft Surface Duo 2 with Snapdragon 888, 128GB storage.', 1399.99, 10, '{
         "category": "smartphone",
         "brand": "Microsoft"
       }', '[
         "electronics",
         "phones",
         "microsoft"
       ]', 50, 230, 2, 2),
       ('hp-envy-13', 'HP Envy 13', 'HP Envy 13 with Intel i5, 8GB RAM, 256GB SSD.', 849.99, 20, '{
         "category": "laptop",
         "brand": "HP"
       }', '[
         "electronics",
         "computers",
         "hp"
       ]', 25, 140, 2, 2),
       ('samsung-galaxy-z-fold-4', 'Samsung Galaxy Z Fold 4',
        'Samsung Galaxy Z Fold 4 with Snapdragon 8 Gen 1, 256GB storage.', 1799.99, 12, '{
         "category": "smartphone",
         "brand": "Samsung"
       }', '[
         "electronics",
         "phones",
         "samsung"
       ]', 75, 330, 2, 2),
       ('asus-rog-zephyrus-g14', 'ASUS ROG Zephyrus G14',
        'ASUS ROG Zephyrus G14 with AMD Ryzen 9, 16GB RAM, 1TB SSD, RTX 3060.', 1799.99, 8, '{
         "category": "laptop",
         "brand": "ASUS"
       }', '[
         "electronics",
         "computers",
         "asus"
       ]', 33, 170, 2, 2),
       ('sony-xperia-5-iv', 'Sony Xperia 5 IV', 'Sony Xperia 5 IV with Snapdragon 8 Gen 1, 128GB storage.', 799.99, 22,
        '{
          "category": "smartphone",
          "brand": "Sony"
        }', '[
         "electronics",
         "phones",
         "sony"
       ]', 70, 300, 2, 2),
       ('amazon-fire-hd-10', 'Amazon Fire HD 10', 'Amazon Fire HD 10 with 64GB storage.', 149.99, 50, '{
         "category": "tablet",
         "brand": "Amazon"
       }', '[
         "electronics",
         "tablets",
         "amazon"
       ]', 60, 220, 2, 2),
       ('huawei-matepad-pro', 'Huawei MatePad Pro', 'Huawei MatePad Pro with Kirin 990, 128GB storage.', 749.99, 18, '{
         "category": "tablet",
         "brand": "Huawei"
       }', '[
         "electronics",
         "tablets",
         "huawei"
       ]', 50, 210, 2, 2),
       ('surface-laptop-studio', 'Surface Laptop Studio',
        'Microsoft Surface Laptop Studio with Intel i7, 16GB RAM, 512GB SSD.', 1599.99, 13, '{
         "category": "laptop",
         "brand": "Microsoft"
       }', '[
         "electronics",
         "computers",
         "microsoft"
       ]', 40, 180, 2, 2),
       ('nokia-xr20', 'Nokia XR20', 'Nokia XR20 with Snapdragon 480, 128GB storage.', 549.99, 35, '{
         "category": "smartphone",
         "brand": "Nokia"
       }', '[
         "electronics",
         "phones",
         "nokia"
       ]', 85, 350, 2, 2),
       ('acer-swift-3', 'Acer Swift 3', 'Acer Swift 3 with Intel i5, 8GB RAM, 256GB SSD.', 699.99, 24, '{
         "category": "laptop",
         "brand": "Acer"
       }', '[
         "electronics",
         "computers",
         "acer"
       ]', 28, 140, 2, 2),
       ('oppo-pad-air', 'Oppo Pad Air', 'Oppo Pad Air with Snapdragon 680, 64GB storage.', 329.99, 40, '{
         "category": "tablet",
         "brand": "Oppo"
       }', '[
         "electronics",
         "tablets",
         "oppo"
       ]', 55, 240, 2, 2),
       ('apple-mac-mini', 'Apple Mac Mini', 'Apple Mac Mini with M2 chip, 8GB RAM, 256GB SSD.', 699.99, 20, '{
         "category": "desktop",
         "brand": "Apple"
       }', '[
         "electronics",
         "computers",
         "apple"
       ]', 40, 180, 2, 2),
       ('hp-omen-15', 'HP Omen 15', 'HP Omen 15 with Intel i7, 16GB RAM, 512GB SSD, RTX 3070.', 1799.99, 14, '{
         "category": "laptop",
         "brand": "HP"
       }', '[
         "electronics",
         "computers",
         "hp"
       ]', 35, 190, 2, 2),
       ('xiaomi-redmi-note-12-pro', 'Xiaomi Redmi Note 12 Pro',
        'Xiaomi Redmi Note 12 Pro with Snapdragon 778G, 128GB storage.', 349.99, 60, '{
         "category": "smartphone",
         "brand": "Xiaomi"
       }', '[
         "electronics",
         "phones",
         "xiaomi"
       ]', 100, 460, 2, 2),
       ('asus-vivobook-s15', 'ASUS VivoBook S15', 'ASUS VivoBook S15 with Intel i5, 8GB RAM, 256GB SSD.', 799.99, 23, '{
         "category": "laptop",
         "brand": "ASUS"
       }', '[
         "electronics",
         "computers",
         "asus"
       ]', 27, 140, 2, 2),
       ('oneplus-pad', 'OnePlus Pad', 'OnePlus Pad with Dimensity 9000, 128GB storage.', 499.99, 30, '{
         "category": "tablet",
         "brand": "OnePlus"
       }', '[
         "electronics",
         "tablets",
         "oneplus"
       ]', 45, 210, 2, 2),
       ('dell-inspiron-15', 'Dell Inspiron 15', 'Dell Inspiron 15 with Intel i5, 8GB RAM, 256GB SSD.', 699.99, 25, '{
         "category": "laptop",
         "brand": "Dell"
       }', '[
         "electronics",
         "computers",
         "dell"
       ]', 30, 160, 2, 2),
       ('vivo-x90-pro', 'Vivo X90 Pro', 'Vivo X90 Pro with Snapdragon 8 Gen 1, 256GB storage.', 899.99, 32, '{
         "category": "smartphone",
         "brand": "Vivo"
       }', '[
         "electronics",
         "phones",
         "vivo"
       ]', 90, 380, 2, 2),
       ('lenovo-ideapad-3', 'Lenovo IdeaPad 3', 'Lenovo IdeaPad 3 with Intel i3, 8GB RAM, 256GB SSD.', 499.99, 28, '{
         "category": "laptop",
         "brand": "Lenovo"
       }', '[
         "electronics",
         "computers",
         "lenovo"
       ]', 25, 130, 2, 2),
       ('nokia-t20', 'Nokia T20', 'Nokia T20 with Unisoc T610, 64GB storage.', 199.99, 45, '{
         "category": "tablet",
         "brand": "Nokia"
       }', '[
         "electronics",
         "tablets",
         "nokia"
       ]', 55, 240, 2, 2),
       ('samsung-galaxy-watch-5', 'Samsung Galaxy Watch 5', 'Samsung Galaxy Watch 5 with Exynos W920, 16GB storage.',
        299.99, 35, '{
         "category": "wearable",
         "brand": "Samsung"
       }', '[
         "electronics",
         "wearables",
         "samsung"
       ]', 65, 270, 2, 2),
       ('lg-gram-16', 'LG Gram 16', 'LG Gram 16 with Intel i7, 16GB RAM, 512GB SSD.', 1399.99, 12, '{
         "category": "laptop",
         "brand": "LG"
       }', '[
         "electronics",
         "computers",
         "lg"
       ]', 35, 180, 2, 2),
       ('realme-gt-neo-3', 'Realme GT Neo 3', 'Realme GT Neo 3 with Dimensity 8100, 128GB storage.', 449.99, 40, '{
         "category": "smartphone",
         "brand": "Realme"
       }', '[
         "electronics",
         "phones",
         "realme"
       ]', 95, 390, 2, 2),
       ('dell-alienware-x17', 'Dell Alienware X17', 'Dell Alienware X17 with Intel i9, 32GB RAM, 1TB SSD, RTX 3080.',
        2999.99, 6, '{
         "category": "laptop",
         "brand": "Dell"
       }', '[
         "electronics",
         "computers",
         "dell"
       ]', 28, 160, 2, 2),
       ('lenovo-legion-5', 'Lenovo Legion 5', 'Lenovo Legion 5 with AMD Ryzen 7, 16GB RAM, 512GB SSD, RTX 3060.',
        1499.99, 14, '{
         "category": "laptop",
         "brand": "Lenovo"
       }', '[
         "electronics",
         "computers",
         "lenovo"
       ]', 32, 150, 2, 2),
       ('samsung-galaxy-a53', 'Samsung Galaxy A53', 'Samsung Galaxy A53 with Exynos 1280, 128GB storage.', 349.99, 55,
        '{
          "category": "smartphone",
          "brand": "Samsung"
        }', '[
         "electronics",
         "phones",
         "samsung"
       ]', 85, 360, 2, 2);


CREATE TABLE categories
(
    id   INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
INSERT INTO categories (name)
VALUES ('Smartphones'),
       ('Laptops'),
       ('Tablets'),
       ('Desktops'),
       ('Wearables'),
       ('Accessories'),
       ('Gaming Laptops'),
       ('Ultrabooks'),
       ('Convertible Laptops'),
       ('Budget Smartphones'),
       ('Flagship Smartphones'),
       ('Android Tablets'),
       ('iOS Tablets'),
       ('Windows Laptops'),
       ('MacBooks'),
       ('Gaming Consoles'),
       ('Smartwatches'),
       ('2-in-1 Tablets'),
       ('Business Laptops'),
       ('Chromebooks'),
       ('High-End Desktops'),
       ('All-in-One PCs'),
       ('Budget Laptops'),
       ('Enterprise Laptops'),
       ('Rugged Smartphones'),
       ('Graphic Design Laptops'),
       ('Video Editing Laptops'),
       ('Developer Laptops'),
       ('Student Laptops'),
       ('Kids Tablets'),
       ('Entry-Level Laptops'),
       ('Mid-Range Smartphones'),
       ('High-End Smartphones'),
       ('Gaming Smartphones'),
       ('Photography Smartphones'),
       ('Fordable Phones'),
       ('Smartphone Accessories'),
       ('Laptop Accessories'),
       ('Tablet Accessories'),
       ('Smart Home Devices'),
       ('Bluetooth Speakers'),
       ('Noise-Canceling Headphones'),
       ('VR Headsets'),
       ('AR Glasses'),
       ('E-Readers'),
       ('Portable Gaming Consoles'),
       ('Home Office Desktops'),
       ('Mini PCs'),
       ('Workstation Laptops');


CREATE TABLE product_categories
(
    id          INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    category_id INTEGER REFERENCES categories (id),
    product_id  INTEGER REFERENCES products (id)
);
-- INSERT INTO product_categories (category_id, product_id)
-- VALUES (1, 1),   -- Apple iPhone 14 - Smartphones
--        (2, 2),   -- Dell XPS 13 - Laptops
--        (3, 3),   -- Apple iPad Air - Tablets
--        (1, 4),   -- Samsung Galaxy S22 Ultra - Smartphones
--        (2, 5),   -- MacBook Pro 16 - Laptops
--        (3, 6),   -- Microsoft Surface Pro 8 - Tablets
--        (4, 7),   -- Apple iMac 24 - Desktops
--        (5, 8),   -- Samsung Galaxy Watch 4 - Wearables
--        (2, 9),   -- Lenovo ThinkPad X1 Carbon - Laptops
--        (1, 10),  -- Google Pixel 6 Pro - Smartphones
--        (1, 11),  -- OnePlus 10 Pro - Smartphones
--        (2, 12),  -- ASUS ZenBook 14 - Laptops
--        (3, 13),  -- Samsung Galaxy Tab S8 - Tablets
--        (5, 14),  -- Apple Watch Series 7 - Wearables
--        (1, 15),  -- Xiaomi Mi 11 Ultra - Smartphones
--        (7, 16),  -- Razer Blade 15 - Gaming Laptops
--        (9, 17),  -- HP Spectre x360 - Convertible Laptops
--        (8, 18),  -- Dell XPS 13 2-in-1 - Ultrabooks
--        (1, 19),  -- Sony Xperia 1 III - Smartphones
--        (2, 20),  -- Acer Aspire 5 - Budget Laptops
--        (10, 21), -- Samsung Galaxy A32 - Budget Smartphones
--        (4, 22),  -- Lenovo Legion T5 - Desktops
--        (1, 23),  -- Huawei P50 Pro - Flagship Smartphones
--        (3, 24),  -- Amazon Fire HD 10 - Android Tablets
--        (2, 25),  -- Samsung Galaxy Book Pro 360 - Laptops
--        (3, 26),  -- Apple iPad Mini - iOS Tablets
--        (14, 27), -- MacBook Air M1 - MacBooks
--        (2, 28),  -- ASUS ROG Zephyrus G14 - Laptops
--        (6, 29),  -- Samsung Galaxy Buds Pro - Accessories
--        (5, 30),  -- Fitbit Versa 3 - Wearables
--        (1, 31),  -- OPPO Find X3 Pro - Smartphones
--        (9, 32),  -- Microsoft Surface Book 3 - Convertible Laptops
--        (15, 33), -- PlayStation 5 - Gaming Consoles
--        (1, 34),  -- Motorola Moto G Power - Smartphones
--        (7, 35),  -- Dell G5 15 - Gaming Laptops
--        (13, 36), -- iPad Pro 11 - iOS Tablets
--        (2, 37),  -- Lenovo Yoga 9i - Laptops
--        (3, 38),  -- Lenovo Tab P12 Pro - Tablets
--        (1, 39),  -- Microsoft Surface Duo 2 - Smartphones
--        (2, 40),  -- HP Envy 13 - Laptops
--        (17, 41), -- Amazon Kindle Paperwhite - E-Readers
--        (1, 42),  -- Nokia XR20 - Rugged Smartphones
--        (8, 43),  -- LG Gram 16 - Ultrabooks
--        (1, 44),  -- Vivo X90 Pro - Photography Smartphones
--        (4, 45),  -- ASUS ROG Strix G15 - High-End Desktops
--        (1, 46),  -- Samsung Galaxy Z Fold 4 - Foldable Phones
--        (3, 47),  -- Microsoft Surface Go 3 - 2-in-1 Tablets
--        (9, 48),  -- Acer Swift 3 - Ultrabooks
--        (19, 49), -- HP Omen 15 - Gaming Laptops
--        (10, 50); -- Google Pixel 5a - Budget Smartphones


CREATE TABLE product_images
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    url        VARCHAR(100) NOT NULL,
    types      JSONB        NOT NULL,
    product_id INTEGER REFERENCES products (id)
);
INSERT INTO product_images (url, types, product_id) 
VALUES
('https://example.com/images/iphone-14-front.jpg', '{"view": "front", "resolution": "1080x1920"}', 1),
('https://example.com/images/dell-xps-13-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 2),
('https://example.com/images/ipad-air-front.jpg', '{"view": "front", "resolution": "1640x2360"}', 3),
('https://example.com/images/samsung-s22-ultra-front.jpg', '{"view": "front", "resolution": "1440x3088"}', 4),
('https://example.com/images/macbook-pro-16-front.jpg', '{"view": "front", "resolution": "3072x1920"}', 5),
('https://example.com/images/surface-pro-8-front.jpg', '{"view": "front", "resolution": "2880x1920"}', 6),
('https://example.com/images/imac-24-front.jpg', '{"view": "front", "resolution": "4480x2520"}', 7),
('https://example.com/images/galaxy-watch-4-front.jpg', '{"view": "front", "resolution": "450x450"}', 8),
('https://example.com/images/thinkpad-x1-front.jpg', '{"view": "front", "resolution": "1920x1200"}', 9),
('https://example.com/images/pixel-6-pro-front.jpg', '{"view": "front", "resolution": "1440x3120"}', 10),
('https://example.com/images/oneplus-10-pro-front.jpg', '{"view": "front", "resolution": "1440x3216"}', 11),
('https://example.com/images/zenbook-14-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 12),
('https://example.com/images/galaxy-tab-s8-front.jpg', '{"view": "front", "resolution": "2560x1600"}', 13),
('https://example.com/images/apple-watch-7-front.jpg', '{"view": "front", "resolution": "396x484"}', 14),
('https://example.com/images/mi-11-ultra-front.jpg', '{"view": "front", "resolution": "1440x3200"}', 15),
('https://example.com/images/razer-blade-15-front.jpg', '{"view": "front", "resolution": "2560x1440"}', 16),
('https://example.com/images/hp-spectre-x360-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 17),
('https://example.com/images/xps-13-2in1-front.jpg', '{"view": "front", "resolution": "1920x1200"}', 18),
('https://example.com/images/xperia-1-iii-front.jpg', '{"view": "front", "resolution": "1644x3840"}', 19),
('https://example.com/images/acer-aspire-5-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 20),
('https://example.com/images/galaxy-a32-front.jpg', '{"view": "front", "resolution": "1080x2400"}', 21),
('https://example.com/images/lenovo-legion-t5-front.jpg', '{"view": "front", "resolution": "2560x1440"}', 22),
('https://example.com/images/p50-pro-front.jpg', '{"view": "front", "resolution": "1224x2700"}', 23),
('https://example.com/images/fire-hd-10-front.jpg', '{"view": "front", "resolution": "1920x1200"}', 24),
('https://example.com/images/galaxy-book-pro-360-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 25),
('https://example.com/images/ipad-mini-front.jpg', '{"view": "front", "resolution": "2266x1488"}', 26),
('https://example.com/images/macbook-air-m1-front.jpg', '{"view": "front", "resolution": "2560x1600"}', 27),
('https://example.com/images/rog-zephyrus-g14-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 28),
('https://example.com/images/galaxy-buds-pro.jpg', '{"view": "front", "resolution": "600x600"}', 29),
('https://example.com/images/fitbit-versa-3-front.jpg', '{"view": "front", "resolution": "336x336"}', 30),
('https://example.com/images/find-x3-pro-front.jpg', '{"view": "front", "resolution": "1440x3216"}', 31),
('https://example.com/images/surface-book-3-front.jpg', '{"view": "front", "resolution": "3000x2000"}', 32),
('https://example.com/images/ps5-front.jpg', '{"view": "front", "resolution": "3840x2160"}', 33),
('https://example.com/images/moto-g-power-front.jpg', '{"view": "front", "resolution": "1080x2300"}', 34),
('https://example.com/images/dell-g5-15-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 35),
('https://example.com/images/ipad-pro-11-front.jpg', '{"view": "front", "resolution": "2388x1668"}', 36),
('https://example.com/images/lenovo-yoga-9i-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 37),
('https://example.com/images/lenovo-tab-p12-pro-front.jpg', '{"view": "front", "resolution": "2560x1600"}', 38),
('https://example.com/images/surface-duo-2-front.jpg', '{"view": "front", "resolution": "1892x2688"}', 39),
('https://example.com/images/hp-envy-13-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 40),
('https://example.com/images/kindle-paperwhite-front.jpg', '{"view": "front", "resolution": "1448x1072"}', 41),
('https://example.com/images/nokia-xr20-front.jpg', '{"view": "front", "resolution": "1080x2400"}', 42),
('https://example.com/images/lg-gram-16-front.jpg', '{"view": "front", "resolution": "2560x1600"}', 43),
('https://example.com/images/vivo-x90-pro-front.jpg', '{"view": "front", "resolution": "1080x2400"}', 44),
('https://example.com/images/rog-strix-g15-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 45),
('https://example.com/images/galaxy-z-fold-4-front.jpg', '{"view": "front", "resolution": "1812x2176"}', 46),
('https://example.com/images/surface-go-3-front.jpg', '{"view": "front", "resolution": "1920x1280"}', 47),
('https://example.com/images/acer-swift-3-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 48),
('https://example.com/images/hp-omen-15-front.jpg', '{"view": "front", "resolution": "1920x1080"}', 49),
('https://example.com/images/pixel-5a-front.jpg', '{"view": "front", "resolution": "1080x2340"}', 50);


CREATE TABLE product_rating
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    value      INTEGER,
    product_id INTEGER REFERENCES products (id),
    user_id    INTEGER REFERENCES users (id)
);
INSERT INTO product_rating (value, product_id, user_id) VALUES
(5, 1, 3),  -- Apple iPhone 14
(4, 2, 3),  -- Dell XPS 13
(5, 3, 3),  -- Apple iPad Air
(5, 4, 3),  -- Samsung Galaxy S22 Ultra
(4, 5, 3),  -- MacBook Pro 16
(5, 6, 3),  -- Microsoft Surface Pro 8
(4, 7, 3),  -- Apple iMac 24
(5, 8, 3),  -- Samsung Galaxy Watch 4
(4, 9, 3),  -- Lenovo ThinkPad X1 Carbon
(5, 10, 3),-- Google Pixel 6 Pro
(4, 11, 3),-- OnePlus 10 Pro
(5, 12, 3); -- ASUS ZenBook 14



CREATE TABLE carts
(
    id            INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    total_product INTEGER                DEFAULT 0,
    total_price   DECIMAL(5, 2) NOT NULL DEFAULT 0,
    user_id       INTEGER REFERENCES users (id)
);
INSERT INTO carts (user_id)
SELECT id
FROM users;

CREATE TABLE cart_items
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    quantity   INTEGER       NOT NULL,
    sub_total  DECIMAL(5, 2) NOT NULL DEFAULT 0,
    product_id INTEGER REFERENCES products (id),
    cart_id    INTEGER REFERENCES carts (id)
);


CREATE TABLE orders
(
    id            INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    order_number  VARCHAR(20) NOT NULL,
    discount      DECIMAL(2),
    total_amount  DECIMAL(5, 2),
    full_name     VARCHAR     NOT NULL,
    phone         VARCHAR(15) UNIQUE,
    address       VARCHAR,
    shipping_cost DECIMAL(5, 2) DEFAULT 0,
    status        JSONB,
    created_at    TIMESTAMP(3)  DEFAULT CURRENT_TIMESTAMP,
    created_by    INTEGER REFERENCES users (id),
    updated_by    INTEGER REFERENCES users (id)
);

CREATE TABLE order_items
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,

    product_id INTEGER REFERENCES products (id),
    price      DECIMAL(5, 2),
    discount   DECIMAL(2),
    quantity   INTEGER       NOT NULL,
    amount     DECIMAL(5, 2) NOT NULL DEFAULT 0,
    order_id   INTEGER REFERENCES orders (id)
);

CREATE TABLE articles
(
    id             INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    url           VARCHAR(100) NOT NULL UNIQUE,
    title          VARCHAR(100) NOT NULL,
    content        TEXT        NOT NULL,

    total_comments INTEGER,
    total_likes    INTEGER,

    created_at     TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    created_by     INTEGER REFERENCES users (id),
    updated_by     INTEGER REFERENCES users (id)
);
INSERT INTO articles (url, title, content, total_comments, total_likes, created_by, updated_by) VALUES
('top-smartphones-2024', 'Top 10 Smartphones of 2024', 'Discover the top 10 smartphones of 2024, including the latest from Apple, Samsung, and Google.', 15, 120, 2, 2),
('best-laptops-for-students', 'Best Laptops for Students', 'A guide to the best laptops for students, focusing on affordability and performance.', 20, 150, 2, 2),
('ultimate-guide-to-tablets', 'Ultimate Guide to Tablets', 'Everything you need to know about tablets in 2024, from iPads to Android devices.', 12, 90, 2, 2),
('future-of-gaming-pcs', 'The Future of Gaming PCs', 'An in-depth look at the future of gaming PCs, including upcoming hardware and trends.', 18, 130, 2, 2),
('choosing-right-smartwatch', 'How to Choose the Right Smartwatch', 'Tips on selecting the perfect smartwatch based on your needs and preferences.', 25, 160, 2, 2),
('top-convertible-laptops', 'Top 5 Convertible Laptops', 'Review of the top 5 convertible laptops that combine performance and versatility.', 22, 110, 2, 2),
('rise-of-foldable-phones', 'The Rise of Foldable Phones', 'Exploring the rise of foldable phones and what makes them a game-changer.', 17, 140,2, 2),
('best-accessories-for-tech', 'Best Accessories for Your Tech Gadgets', 'A roundup of essential accessories to enhance your tech gadgets.', 14, 85, 2, 2),
('choosing-laptop-for-gaming', 'Choosing the Right Laptop for Gaming', 'How to choose the best laptop for gaming, including key features to look for.', 19, 125, 2, 2),
('top-tablets-for-digital-art', 'Top Tablets for Digital Art', 'The best tablets for digital artists, including reviews and comparisons.', 16, 95, 2, 2),
('guide-to-high-end-smartphones', 'Guide to High-End Smartphones', 'A comprehensive guide to high-end smartphones with the latest features and specs.', 21, 135, 2, 2),
('best-budget-smartphones-2024', 'Best Budget Smartphones of 2024', 'Affordable smartphones that offer great value without breaking the bank.', 13, 80, 2, 2),
('latest-trends-in-wearables', 'The Latest Trends in Wearables', 'Explore the latest trends in wearable technology and what to expect in the coming years.', 20, 115, 2, 2),
('smart-home-devices-to-watch', 'Smart Home Devices to Watch', 'Review of innovative smart home devices that can transform your living space.', 15, 100, 2, 2),
('laptop-for-remote-work', 'Choosing a Laptop for Remote Work', 'Tips on selecting the right laptop for remote work, including important features.', 22, 130, 2, 2),
('top-10-laptop-accessories', 'Top 10 Accessories for Your Laptop', 'Essential accessories to enhance the functionality of your laptop.', 18, 120, 2, 2),
('best-android-tablets-2024', 'Best Android Tablets for 2024', 'A list of the best Android tablets available this year, with detailed reviews.', 14, 85, 2, 2),
('how-to-maintain-tech-gadgets', 'How to Maintain Your Tech Gadgets', 'Guide on how to properly maintain and extend the lifespan of your tech gadgets.', 19, 95, 2, 2),
('vr-headsets-exploration', 'Exploring the World of VR Headsets', 'An overview of VR headsets and their impact on gaming and entertainment.', 25, 140, 2, 2),
('best-laptops-for-content-creators', 'Best Laptops for Content Creators', 'Top laptops designed for content creators, focusing on performance and features.', 20, 110, 2, 2),
('evolution-of-smartphone-cameras', 'The Evolution of Smartphone Cameras', 'How smartphone cameras have evolved over the years and what to expect next.', 23, 125, 2, 2),
('picks-for-business-laptops', 'Top Picks for Business Laptops', 'Review of the best laptops for business professionals, emphasizing reliability and security.', 18, 105, 2, 2),
('high-performance-tablets', 'Guide to High-Performance Tablets', 'A look at high-performance tablets that excel in both speed and functionality.', 16, 90, 2, 2),
('best-budget-laptops-2024', 'Best Budget Laptops for 2024', 'Affordable laptops that offer excellent performance for their price.', 14, 80, 2, 2),
('smartwatch-features-you-need', 'Smartwatch Features You Need to Know', 'Key features to look for in a smartwatch and how they can benefit you.', 21, 135, 2, 2),
('top-gaming-consoles-2024', 'Top 5 Gaming Consoles of 2024', 'Review of the top gaming consoles available this year, including specs and features.', 19, 120, 2, 2),
('essential-laptop-maintenance-tips', 'Essential Laptop Maintenance Tips', 'How to keep your laptop in top condition with these essential maintenance tips.', 20, 110, 2, 2),
('best-tech-gadgets-for-students', 'Best Tech Gadgets for Students', 'A roundup of tech gadgets that are perfect for students and their needs.', 17, 100, 2, 2),
('best-foldable-phones', 'Exploring the Best Foldable Phones', 'An exploration of the best foldable phones available today, including their benefits.', 18, 115, 2, 2),
('tablets-for-streaming-media', 'The Best Tablets for Streaming Media', 'Review of the best tablets for streaming media, with a focus on display and performance.', 15, 90, 2, 2),
('top-gadgets-for-gamers', 'Top 10 Accessories for Gamers', 'Must-have accessories that can enhance your gaming experience.', 22, 130, 2, 2),
('choosing-right-smart-home-hub', 'Choosing the Right Smart Home Hub', 'Guide to selecting the best smart home hub for controlling your smart devices.', 19, 120, 2, 2),
('how-to-upgrade-tech-setup', 'How to Upgrade Your Tech Setup', 'Tips on upgrading your tech setup for better performance and productivity.', 21, 125, 2, 2),
('best-tablets-for-reading-writing', 'Best Tablets for Reading and Writing', 'Tablets that excel in reading and writing tasks, including detailed reviews.', 14, 85,2, 2),
('best-smartwatches-for-fitness', 'The Best Smartwatches for Fitness Tracking', 'A guide to the best smartwatches for tracking fitness and health.', 23, 140, 2, 2),
('best-business-desktops', 'Top Picks for Business Desktops', 'Best desktop computers for business use, focusing on performance and reliability.', 20, 110, 2, 2),
('latest-smartphone-features', 'Guide to Latest Smartphone Features', 'Overview of the latest features in smartphones and their benefits.', 18, 95, 2, 2),
('future-of-wearable-technology', 'The Future of Wearable Technology', 'Predictions and insights into the future of wearable technology.', 21, 120, 2, 2),
('best-laptops-for-photo-editing', 'Best Laptops for Photo Editing', 'Laptops that are ideal for photo editing, with a focus on display and processing power.', 16, 100, 2, 2),
('top-tech-gadgets', 'Top 10 Gadgets for Tech Enthusiasts', 'A list of the top 10 gadgets that every tech enthusiast should have.', 15, 85, 2, 2),
('best-tech-gifts-2024', 'The Best Tech Gifts for 2024', 'A guide to the best tech gifts for this year, suitable for any occasion.', 20, 115, 2, 2),
('choosing-best-gaming-accessories', 'How to Choose the Best Gaming Accessories', 'Tips on selecting the best accessories to enhance your gaming experience.', 18, 110, 2, 2),
('tablets-for-kids', 'Top Tablets for Kids', 'Review of the best tablets designed specifically for children.', 12, 70, 2, 2),
('best-tech-for-small-business', 'Best Tech for Small Business Owners', 'Tech gadgets and tools that can benefit small business owners.', 19, 95, 2, 2),
('guide-to-buying-first-laptop', 'Guide to Buying Your First Laptop', 'Tips and advice for buying your first laptop, including key considerations.', 16, 85, 2, 2),
('best-portable-gaming-devices', 'The Best Portable Gaming Devices', 'Review of portable gaming devices that offer a great gaming experience on the go.', 23, 125,2, 2),
('choosing-right-smart-tv', 'Choosing the Right Smart TV', 'How to select the best smart TV based on your viewing preferences and needs.', 21, 120, 2, 2),
('top-tech-innovations-2024', 'Top 10 Tech Innovations of 2024', 'Overview of the top tech innovations expected to make an impact in 2024.', 20, 130, 2, 2),
('best-accessories-for-tablets', 'Best Accessories for Tablets', 'Essential accessories that can enhance your tablet experience.', 18, 110, 2, 2),
('optimizing-your-tech-setup', 'How to Optimize Your Tech Setup', 'Tips and tricks for optimizing your tech setup for better performance.', 22, 125, 2, 2);


CREATE TABLE comments
(
    id          INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    product_id  INTEGER REFERENCES products (id),
    article_id  INTEGER REFERENCES articles (id),

    content     TEXT NOT NULL,
    total_likes INTEGER,
    parent_id   INTEGER REFERENCES comments (id),

    created_at  TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    created_by  INTEGER REFERENCES users (id)
);
INSERT INTO comments (product_id, article_id, content, total_likes, parent_id, created_by) VALUES
(1, NULL, 'Great smartphone with excellent features!', 15, NULL, 3),
(2, NULL, 'The best laptop for students. Highly recommend!', 22, NULL, 3),
(3, NULL, 'Love the versatility of this tablet.', 12, NULL, 3),
(4, NULL, 'Amazing gaming PC with powerful specs.', 18, NULL, 3),
(5, NULL, 'This smartwatch is perfect for fitness tracking.', 25, NULL, 3),
(6, NULL, 'The convertible laptop is a game-changer for productivity.', 14, NULL,3),
(7, NULL, 'Fordable phones are really cool but pricey.', 17, NULL, 3),
(8, NULL, 'Must-have accessories for every tech enthusiast.', 20, NULL, 3),
(9, NULL, 'Best laptop for gaming I’ve ever used.', 19, NULL, 3),
(10, NULL, 'Tablets for digital art are getting better every year.', 16, NULL, 3),
(11, NULL, 'High-end smartphones have incredible features.', 21, NULL, 3),
(12, NULL, 'Affordable yet powerful budget smartphones.', 13, NULL, 3),
(13, NULL, 'Wearables are becoming more advanced. Exciting times!', 20, NULL, 3),
(14, NULL, 'Smart home devices can truly transform your home.', 15, NULL, 3),
(15, NULL, 'Remote work is so much easier with the right laptop.', 22, NULL, 3),
(16, NULL, 'Top accessories to enhance your laptop experience.', 18, NULL, 3),
(17, NULL, 'Android tablets are a great alternative to iPads.', 14, NULL, 3),
(18, NULL, 'Maintaining tech gadgets is crucial for longevity.', 19, NULL, 3),
(19, NULL, 'VR headsets are amazing for immersive experiences.', 25, NULL, 3),
(20, NULL, 'Content creators need laptops with top-notch performance.', 20, NULL, 3);

INSERT INTO comments (product_id, article_id, content, total_likes, parent_id, created_by) VALUES
(NULL, 1, 'Great overview of the latest smartphones! The features of the new models are impressive.', 25, NULL, 3),
(NULL, 1, 'I agree, the new camera technology is revolutionary.', 18, NULL, 3),
(NULL, 2, 'This list of laptops is very helpful. I ended up buying one from this article.', 30, NULL, 3),
(NULL, 2, 'Can you add a comparison of these laptops with some other models?', 12, NULL, 3),
(NULL, 3, 'The tablet recommendations are spot on for digital artists.', 22, NULL, 3),
(NULL, 3, 'Looking forward to trying out the new models mentioned in this guide.', 15, NULL, 3),
(NULL, 4, 'The gaming PC specs are very detailed. Great article!', 28, NULL, 3),
(NULL, 4, 'Could you include some budget-friendly options in future articles?', 14, NULL, 3),
(NULL, 5, 'Excellent tips on smartwatches. I found the health tracking features very useful.', 35, NULL, 3),
(NULL, 5, 'The smartwatch reviews are very insightful. Helped me make a decision.', 20, NULL, 3),
(NULL, 6, 'The convertible laptop review is very informative. I’m considering buying one.', 18, NULL, 3),
(NULL, 6, 'It would be great to see a review on the durability of these laptops.', 10, NULL, 3),
(NULL, 7, 'Foldable phones are amazing but too expensive for my budget.', 20, NULL, 3),
(NULL, 7, 'Hoping the prices come down in the near future.', 12, NULL, 3),
(NULL, 8, 'Great list of tech accessories. Found some cool gadgets to enhance my setup.', 25, NULL, 3),
(NULL, 8, 'The reviews on these accessories are very detailed and helpful.', 18, NULL, 3),
(NULL, 9, 'The gaming laptop recommendations are fantastic. I purchased one last week.', 27, NULL, 3),
(NULL, 9, 'Can you provide a comparison with the latest gaming consoles?', 14, NULL, 3),
(NULL, 10, 'The tablets for digital art are really impressive. I’m considering switching to one.', 19, NULL, 3),
(NULL, 10, 'The tips for choosing the best tablet for artists are very useful.', 11, NULL, 3),
(NULL, 11, 'The guide on high-end smartphones is very comprehensive. Thanks for the insights.', 22, NULL, 3),
(NULL, 11, 'What do you think about the new features in these smartphones?', 14, NULL, 3),
(NULL, 12, 'Good recommendations for budget smartphones. Just what I needed.', 16, NULL, 3),
(NULL, 12, 'Are there any deals or discounts available for these models?', 8, NULL, 3),
(NULL, 13, 'Wearable tech is evolving rapidly. Excited to see what’s next.', 24, NULL, 3),
(NULL, 13, 'I’m particularly interested in the new health tracking features.', 17, NULL, 3),
(NULL, 14, 'Smart home devices are so useful. I’ve upgraded my home with a few of these.', 30, NULL, 3),
(NULL, 14, 'Looking forward to more reviews on smart home gadgets.', 12, NULL, 3),
(NULL, 15, 'The advice on choosing a laptop for remote work is very practical.', 20, NULL, 3),
(NULL, 15, 'It would be helpful to have more details on the performance benchmarks.', 11, NULL, 3),
(NULL, 16, 'The accessory recommendations for laptops are spot on. Found some great products.', 22, NULL, 3),
(NULL, 16, 'More reviews on accessories for specific use cases would be great.', 10, NULL, 3),
(NULL, 17, 'Android tablets are great alternatives. Good to see them getting recognition.', 15, NULL, 3),
(NULL, 17, 'What’s your take on the new Android tablet from Samsung?', 9, NULL, 3),
(NULL, 18, 'Maintaining tech gadgets is crucial. The tips here are really helpful.', 20, NULL, 3),
(NULL, 18, 'Could you provide more information on cleaning and care?', 8, NULL, 3),
(NULL, 19, 'VR headsets are amazing for gaming. Thanks for the detailed overview.', 22, NULL, 3),
(NULL, 19, 'How do these VR headsets compare with the latest models from other brands?', 14, NULL, 3),
(NULL, 20, 'Content creators need high-performance laptops. This guide is very useful.', 18, NULL, 3),
(NULL, 20, 'Would love to see a comparison with some recent models.', 12, NULL, 3),
(NULL, 21, 'Smartphone cameras are getting better. Excited to try the new features.', 21, NULL, 3),
(NULL, 21, 'The camera comparison was very informative. Thanks for the insights.', 15, NULL, 3),
(NULL, 22, 'Business laptops need to be reliable. Good recommendations here.', 19, NULL, 3),
(NULL, 22, 'Could you include more options for different business needs?', 10, NULL, 3),
(NULL, 23, 'High-performance tablets are great for demanding tasks. Thanks for the review.', 17, NULL, 3),
(NULL, 23, 'Looking forward to more comparisons between high-end tablets.', 8, NULL, 3),
(NULL, 24, 'Budget laptops are a great option for those on a tight budget.', 14, NULL, 3),
(NULL, 24, 'Any advice on getting the best deals on these laptops?', 9, NULL, 3),
(NULL, 25, 'Smartwatch features are really advancing. Great tips in this article.', 20, NULL, 3),
(NULL, 25, 'Can you do a detailed review on fitness tracking features?', 11, NULL, 3),
(NULL, 26, 'Gaming consoles have some amazing new features. Thanks for the breakdown.', 23, NULL, 3),
(NULL, 26, 'I’m interested in how these compare with older models.', 14, NULL, 3),
(NULL, 27, 'Laptop maintenance is key for longevity. Good tips provided.', 18, NULL, 3),
(NULL, 27, 'More information on software maintenance would be helpful.', 10, NULL, 3),
(NULL, 28, 'Tech gadgets can really aid in studies. Thanks for the recommendations.', 22, NULL, 3),
(NULL, 28, 'Any specific gadgets you recommend for engineering students?', 12, NULL, 3),
(NULL, 29, 'Foldable phones are innovative but pricey. Interesting article.', 19, NULL, 3),
(NULL, 29, 'Do you think the prices will become more affordable soon?', 11, NULL, 3),
(NULL, 30, 'Tablets with good media display are fantastic for streaming.', 16, NULL, 3),
(NULL, 30, 'More reviews on tablets with high-resolution displays would be appreciated.', 9, NULL,3),
(NULL, 31, 'Gaming accessories can make a huge difference. Great list!', 21, NULL, 3),
(NULL, 31, 'Any recommendations for accessories specifically for PC gaming?', 12, NULL, 3),
(NULL, 32, 'Smart home hubs are essential for managing smart devices.', 20, NULL, 3),
(NULL, 32, 'Looking forward to more reviews on smart home technology.', 8, NULL, 3),
(NULL, 33, 'Optimizing tech setups can really improve performance. Good advice.', 22, NULL, 3),
(NULL, 33, 'Can you include tips for optimizing for gaming setups?', 10, NULL,3),
(NULL, 34, 'Tablets for reading and writing are very useful. Thanks for the guide.', 18, NULL,3),
(NULL, 34, 'Any suggestions for tablets that are good for academic work?', 7, NULL, 3),
(NULL, 35, 'Fitness tracking smartwatches are very useful. Great overview.', 23, NULL, 3),
(NULL, 35, 'Can you do a review on smartwatches with advanced health features?', 12, NULL, 3),
(NULL, 36, 'Business desktops need to be powerful. Good recommendations.', 20, NULL, 3),
(NULL, 36, 'Would love to see more on the durability of these desktops.', 9, NULL, 3),
(NULL, 37, 'Smartphone features are evolving quickly. Exciting stuff!', 18, NULL, 3),
(NULL, 37, 'More comparisons with older models would be helpful.', 11, NULL, 3),
(NULL, 38, 'Wearable technology is advancing rapidly. Thanks for the insights.', 22, NULL, 3),
(NULL, 38, 'Any upcoming trends in wearable tech?', 10, NULL, 3),
(NULL, 39, 'Photo editing on powerful laptops is a game-changer. Great tips.', 20, NULL, 3),
(NULL, 39, 'More information on software for photo editing would be useful.', 9, NULL, 3),
(NULL, 40, 'Tech gadgets keep improving. Excited to see what’s next.', 18, NULL, 3),
(NULL, 40, 'Any upcoming tech gadgets that you’re excited about?', 11, NULL, 3),
(NULL, 41, 'Tech gifts for 2024 are impressive. I’ve got some great ideas now.', 25, NULL, 3),
(NULL, 41, 'Which tech gift would you recommend for a tech enthusiast?', 14, NULL, 3),
(NULL, 42, 'Gaming accessories can enhance gameplay. Good recommendations.', 22, NULL, 3),
(NULL, 42, 'More detailed reviews on gaming accessories would be great.', 12, NULL, 3),
(NULL, 43, 'Tablets for kids need to be durable. Good list of recommendations.', 17, NULL, 3),
(NULL, 43, 'Any suggestions for the most durable tablets for young children?', 8, NULL, 3),
(NULL, 44, 'Tech for small business owners is crucial. Great list of tools.', 20, NULL, 3),
(NULL, 44, 'Would like more details on specific tech tools for different business needs.', 11, NULL, 3),
(NULL, 45, 'Buying your first laptop is a big decision. Thanks for the tips.', 22, NULL, 3),
(NULL, 45, 'Any advice on choosing between a laptop and a desktop for a beginner?', 10, NULL, 3),
(NULL, 46, 'Portable gaming devices are great for gaming on the move. Thanks for the review.', 19, NULL, 3),
(NULL, 46, 'More information on the battery life of these devices would be helpful.', 8, NULL, 3),
(NULL, 47, 'Smart TVs with the latest features are impressive. Good guide.', 20, NULL, 3),
(NULL, 47, 'Could you review smart TVs with the best sound quality?', 11, NULL, 3),
(NULL, 48, 'Top tech innovations of 2024 are exciting. Looking forward to them.', 22, NULL, 3),
(NULL, 48, 'Any predictions for the next big tech innovation?', 10, NULL, 3),
(NULL, 49, 'Accessories for tablets are essential. Good list of recommendations.', 18, NULL, 3),
(NULL, 49, 'What’s the best accessory for enhancing tablet productivity?', 7, NULL, 3),
(NULL, 50, 'Optimizing your tech setup is key. Good tips provided.', 21, NULL, 3),
(NULL, 50, 'Any suggestions for optimizing for a home office setup?', 12, NULL, 3);


CREATE TABLE likes
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    comment_id INTEGER REFERENCES comments (id),
    article_id INTEGER REFERENCES articles (id),
    user_id    INTEGER REFERENCES users (id)
);
INSERT INTO likes (comment_id, article_id, user_id) VALUES
(1, NULL, 3),
(1, NULL, 3),
(1, NULL, 3),
(2, NULL, 3),
(2, NULL, 3),
(3, NULL, 3),
(3, NULL, 3),
(4, NULL, 3),
(4, NULL, 3),
(5, NULL, 3),
(5, NULL, 3),
(6, NULL, 3),
(6, NULL, 3),
(7, NULL, 3),
(8, NULL, 3),
(8, NULL, 3),
(9, NULL, 3),
(9, NULL, 3),
(10, NULL, 3),
(11, NULL, 3),
(11, NULL, 3),
(12, NULL, 3),
(12, NULL, 3),
(13, NULL, 3),
(14, NULL, 3),
(15, NULL, 3),
(15, NULL, 3),
(16, NULL, 3),
(16, NULL, 3),
(17, NULL, 3),
(17, NULL, 3),
(18, NULL, 3),
(18, NULL, 3),
(19, NULL, 3),
(19, NULL, 3),
(20, NULL, 3);



SELECT "PermissionGroup"."id" AS "PermissionGroup_id", "PermissionGroup"."name" AS "PermissionGroup_name", "PermissionGroup"."permissions" AS "PermissionGroup_permissions", "PermissionGroup"."active" AS "PermissionGroup_active", User FROM "users" "User", "users" "users" LEFT JOIN "permission_group" "PermissionGroup" ON "PermissionGroup"."id" = "users"."permission_group_id" WHERE "PermissionGroup"."name" = 'Customer'