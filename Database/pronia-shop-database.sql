-- CREATE DATABASE molla_ecommerce;


-- SQLINES FOR EVALUATION USE ONLY (14 DAYS)
CREATE TABLE categories
(
    id     INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    name   VARCHAR(30),
    active BOOLEAN  DEFAULT TRUE
);
INSERT INTO categories (name)
VALUES ('Flowering Plants'),
       ('Succulents'),
       ('Trees'),
       ('Shrubs'),
       ('Perennials'),
       ('Annuals'),
       ('Herbs'),
       ('Vegetables'),
       ('Fruits'),
       ('Indoor Plants'),
       ('Outdoor Plants'),
       ('Bonsai'),
       ('Cacti'),
       ('Aquatic Plants'),
       ('Climbers'),
       ('Groundcovers'),
       ('Ornamental Grasses'),
       ('Ferns'),
       ('Medicinal Plants'),
       ('Aromatic Plants'),
       ('Shade-loving Plants'),
       ('Sun-loving Plants'),
       ('Drought-tolerant Plants'),
       ('Tropical Plants'),
       ('Alpine Plants'),
       ('Rock Garden Plants'),
       ('Xerophytic Plants'),
       ('Bamboo'),
       ('Hanging Plants'),
       ('Moss'),
       ('Edible Plants'),
       ('Foliage Plants'),
       ('Bulbs'),
       ('Vines'),
       ('Pollinator-friendly Plants'),
       ('Winter-blooming Plants'),
       ('Summer-blooming Plants'),
       ('Fall-blooming Plants'),
       ('Spring-blooming Plants'),
       ('Xerophyte Plants');


CREATE TABLE tags
(
    id     INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    name   VARCHAR(30),
    active BOOLEAN  DEFAULT TRUE
);
INSERT INTO tags (name)
VALUES ('Flowering'),
       ('Fragrant'),
       ('Indoor'),
       ('Outdoor'),
       ('Low Maintenance'),
       ('Colorful'),
       ('Edible'),
       ('Medicinal'),
       ('Shade-loving'),
       ('Drought-tolerant'),
       ('Succulent'),
       ('Tropical'),
       ('Perennial'),
       ('Annual'),
       ('Climber'),
       ('Groundcover'),
       ('Foliage Plants'),
       ('Fruit-bearing'),
       ('Aromatic'),
       ('Native'),
       ('Herb'),
       ('Bamboo'),
       ('Ornamental Grass'),
       ('Bonsai'),
       ('Exotic'),
       ('Aquatic'),
       ('Pollinator-friendly'),
       ('Humidity-loving'),
       ('Rock Garden'),
       ('Winter-blooming'),
       ('Summer-blooming'),
       ('Fall-blooming'),
       ('Spring-blooming'),
       ('Alpine'),
       ('Xerophytic'),
       ('Thorny'),
       ('Hanging Plants'),
       ('Moss'),
       ('Variegated'),
       ('Xerophyte');


CREATE TABLE plants
(
    id           INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    title        VARCHAR(30)  NOT NULL,
    description  TEXT,
    image_link   TEXT,
    color        VARCHAR(30),

    unit_price   DECIMAL(5, 2)  DEFAULT 0,

    quantity     INT,
    sale_opening DATE,
    stock_status VARCHAR(30)    DEFAULT 'In Stock',
    active       BOOLEAN        DEFAULT TRUE
);
INSERT INTO plants (title, description, image_link, color, unit_price, quantity, sale_opening, stock_status)
VALUES ('Rose', 'Beautiful red roses',
        'https://cdn.blossominggifts.com/media/catalog/product/cache/7/image/9df78eab33525d08d6e5fb8d27136e95/r/e/red-rose-plant-dark-grey-pot.webp',
        'Red', 10.99, 50, '2024-02-01', 'In Stock'),
       ('Tulip', 'Colorful tulips for your garden',
        'https://cdn.blossominggifts.com/media/catalog/product/cache/7/image/9df78eab33525d08d6e5fb8d27136e95/1/0/100-springtime-tulips-vase.webp',
        'Various', 8.99, 75, '2024-02-10', 'In Stock'),
       ('Sunflower', 'Bright and sunny sunflowers',
        'https://purpleflowers.ro/wp-content/uploads/2023/02/15-floarea-soarelui.jpg', 'Yellow', 12.99, 30,
        '2024-03-01', 'In Stock'),
       ('Lavender', 'Fragrant lavender plants',
        'https://m.media-amazon.com/images/I/71AOzpBIX-S._AC_UF894,1000_QL80_.jpg', 'Purple', 9.99, 40, '2024-03-15',
        'In Stock'),
       ('Daisy', 'Classic white daisies', 'https://www.dpartificialflowers.com/wp-content/uploads/2022/11/30.jpg',
        'White', 7.99, 60, '2024-04-01', 'In Stock'),
       ('Orchid', 'Elegant orchids for your home',
        'https://m.media-amazon.com/images/I/71ictJ9K7fS._AC_UF1000,1000_QL80_.jpg', 'Pink', 15.99, 25, '2024-04-10',
        'In Stock'),
       ('Fern', 'Lush green ferns for your garden',
        'https://toastandhoney.com.au/cdn/shop/products/boston-fern-20cm-basket-925758_1080x.jpg?v=1652557621', 'Green',
        11.99, 45, '2024-05-01', 'In Stock'),
       ('Cactus', 'Low-maintenance cactus plants',
        'https://www.ugaoo.com/cdn/shop/files/SpiroCeramicPot-Pink_50bcfff5-8b5d-4221-8321-8d387a1cc844.jpg?v=1683182182&width=1500',
        'Green', 8.99, 80, '2024-05-15', 'In Stock'),
       ('Hydrangea', 'Color-changing hydrangea flowers',
        'https://img.crocdn.co.uk/images/products2/pb/20/00/03/55/pb2000035537.jpg?width=940&height=940', 'Blue', 14.99,
        35, '2024-06-01', 'In Stock'),
       ('Lily', 'Fragrant lilies in various colors',
        'https://www.novablooms.com/cdn/shop/products/PinkOrientalLillies_1200x1200.jpg?v=1617957889', 'Various', 11.99,
        50, '2024-06-10', 'In Stock'),
       ('Bamboo', 'Lucky bamboo for good vibes',
        'https://bloomr.ae/cdn/shop/products/bloomr-trees-artificial-bamboo-tree-artificial-flowers-artificial-trees-artificial-plants-dubai-saudi-arabia-uae-18899251724450_2024x2024.jpg?v=1627131099',
        'Green', 9.99, 20, '2024-07-01', 'In Stock'),
       ('Poinsettia', 'Festive poinsettias for the holidays',
        'https://www.flowersforeveryone.com.au/cdn-cgi/image/fit=contain,width=1000,format=auto/images/products/large/large-poinsettia.jpg',
        'Red', 12.99, 70, '2024-07-15', 'In Stock'),
       ('Maple Tree', 'Beautiful maple trees for your backyard',
        'https://asset.i-fulfilment.co.uk/images/unid/59e06f6e3c574/render/1000/image.jpeg', 'Orange', 11.99, 15,
        '2024-08-01', 'In Stock'),
       ('Succulent', 'Assorted succulents for small spaces',
        'https://www.succulentsandsunshine.com/wp-content/uploads/2021/05/arrange-colorful-succulents-textured-pot-455x455.jpg',
        'Various', 11.99, 90, '2024-08-10', 'In Stock'),
       ('Aloe Vera', 'Aloe vera plants for health benefits',
        'https://m.media-amazon.com/images/I/61pdnefwnhS._AC_UF1000,1000_QL80_.jpg', 'Green', 10.99, 25, '2024-09-01',
        'In Stock'),
       ('Carnation', 'Colorful carnations for any occasion',
        'https://www.snowseed.co.jp/wp/wp-content/uploads/products/fluto_1.jpg', 'Pink', 14.99, 40, '2024-09-15',
        'In Stock'),
       ('Cherry Blossom', 'Cherry blossom trees in full bloom',
        'https://media.homecentre.com/i/homecentre/159777684-159777684-HC16092022_04-2100.jpg?fmt=auto&$quality-standard$&sm=c&$prodimg-m-sqr-pdp-2x$',
        'Pink', 13.99, 50, '2024-10-01', 'In Stock'),
       ('Bougainvillea', 'Vibrant bougainvillea for a splash of color',
        'https://en.flowy.be/cdn/shop/files/bougainvillier-grimpant-treillis_NP_x700.jpg?v=1683290661', 'Pink', 14.99,
        60, '2024-10-10', 'In Stock'),
       ('Palm Tree', 'Exotic palm trees for a tropical feel', 'https://m.media-amazon.com/images/I/71BBHqOYFRL.jpg',
        'Green', 15.99, 30, '2024-11-01', 'In Stock'),
       ('Crocus', 'Early blooming crocus flowers',
        'https://images.thdstatic.com/productImages/e2ef12b6-e72b-4b06-8355-a798a21ed7e0/svn/garden-state-bulb-flower-bulbs-ecf-11-100-31_600.jpg',
        'Purple', 14.99, 45, '2024-11-15', 'In Stock'),
       ('Fuchsia', 'Dangling fuchsia flowers for hanging baskets',
        'https://thisismygarden.com/wp-content/uploads/2022/04/shade-fuchsia.jpg', 'Pink', 16.99, 55, '2024-12-01',
        'In Stock'),
       ('African Violet', 'Delicate African violets for indoor beauty',
        'https://planterhoma.com/cdn/shop/products/3_0a04df69-a1b9-4db5-9b0d-8ce726ce8a4f_800x.jpg?v=1652857057',
        'Purple', 17.99, 20, '2024-12-10', 'In Stock'),
       ('Hibiscus', 'Tropical hibiscus flowers for a splash of color',
        'https://americanplantexchange.com/cdn/shop/products/pinkhib-1.jpg?v=1672881148', 'Red', 18.99, 70,
        '2025-01-01', 'In Stock'),
       ('Zinnia', 'Bright and cheerful zinnia flowers',
        'https://www.selectseeds.com/cdn/shop/products/407-3-1000_1000x.jpg?v=1687467172', 'Various', 19.99, 25,
        '2025-01-15', 'In Stock'),
       ('Ficus', 'Indoor ficus plants for air purification',
        'https://www.plantandpot.nz/wp-content/uploads/2021/12/Ficus-Louis-in-Rounded-White-Pot.jpg', 'Green', 20.99,
        40, '2025-02-01', 'In Stock'),
       ('Daffodil', 'Sunny daffodils for a touch of spring',
        'https://i.pinimg.com/originals/d2/4f/ee/d24fee993517d167ddfd59af27c3fbb0.jpg', 'Yellow', 20.99, 60,
        '2025-02-10', 'In Stock'),
       ('Geranium', 'Classic geraniums for window boxes',
        'https://www.countrydoor.com/dw/image/v2/BBVM_PRD/on/demandware.static/-/Sites-colony-master-catalog/default/dwb754c7dd/large/sub_43/300380.png?sw=680&sh=680&sm=fit',
        'Red', 21.99, 35, '2025-03-01', 'In Stock'),
       ('Chrysanthemum', 'Colorful chrysanthemum flowers',
        'https://image.floranext.com/shared/catalog/product/F/C/FCP-37-White-Chrysanthemum-Plant-Wood.jpg.webp?h=700&w=700&r=255&g=255&b=255',
        'White', 22.99, 50, '2025-03-15', 'In Stock'),
       ('Spider Plant', 'Easy-care spider plants for beginners',
        'https://www.beardsanddaisies.co.uk/cdn/shop/products/Beards-Daises-27.9.220111copy.jpg?v=1664959425', 'Green',
        23.99, 80, '2025-04-01', 'In Stock'),
       ('Columbine', 'Unique columbine flowers for your garden',
        'https://mobileimages.lowes.com/productimages/f3ac973c-eea9-485d-916b-8d012b281982/02111099.jpg?size=pdhism',
        'Various', 24.99, 30, '2025-04-10', 'In Stock'),
       ('Snake Plant', 'Hardy snake plants for air purification',
        'https://images.squarespace-cdn.com/content/v1/54fbb611e4b0d7c1e151d22a/1610074066643-OP8HDJUWUH8T5MHN879K/Snake+Plant.jpg?format=2500w',
        'Green', 25.99, 45, '2025-05-01', 'In Stock'),
       ('Peony', 'Lush peony flowers in various colors', 'https://www.therange.co.uk/media/0/3/1671540211_12_3591.jpg',
        'Various', 26.99, 55, '2025-05-15', 'In Stock'),
       ('Azalea', 'Colorful azalea bushes for landscaping',
        'https://flowercompany.ca/cdn/shop/products/potted-azalea-plant-toronto-flower-co-822484.jpg?v=1676627243',
        'Various', 27.99, 65, '2025-06-01', 'In Stock'),
       ('Clematis', 'Beautiful clematis vines for trellises',
        'https://www.thompson-morgan.com/product_images/100/optimised/CLEM-T71512-B_h.jpg', 'Various', 28.99, 75,
        '2025-06-10', 'In Stock'),
       ('Morning Glory', 'Vibrant morning glory flowers for fences',
        'https://img.ssww.com/cs_srgb/q_90/w_512/cs_srgb/q_90/v1547740778/2c/ob/SWGP3312cob.jpg', 'Various', 29.99, 85,
        '2025-07-01', 'In Stock'),
       ('Camellia', 'Elegant camellia flowers in various hues',
        'https://en-gb.bakker.com/cdn/shop/products/59043-01-BAKIE.jpg?v=1639537655&width=1946', 'Various', 30.99, 95,
        '2025-07-15', 'In Stock'),
       ('Dahlia', 'Showy dahlias in a variety of colors',
        'https://h2.commercev3.net/cdn.brecks.com/images/800/62773.jpg', 'Various', 31.99, 40, '2025-08-01',
        'In Stock'),
       ('Pansy', 'Cheerful pansies for cool-season gardening',
        'https://treemart.org/wp-content/uploads/2023/03/Pansy.jpg', 'Various', 32.99, 30, '2025-08-10',
        'In Stock');
-- GO
-- SQLINES DEMO *** p.dbo.plants
-- SQLINES DEMO ***  N'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incidid ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

CREATE TABLE plant_categories
(
    id          INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    plant_id    INTEGER REFERENCES plants (id),
    category_id INTEGER REFERENCES categories (id)
);
INSERT INTO plant_categories (plant_id, category_id)
VALUES (1, 1),
       (2, 1),
       (3, 3),
       (4, 5),
       (5, 2),
       (6, 8),
       (7, 4),
       (8, 6),
       (9, 3),
       (10, 2),
       (11, 11),
       (12, 7),
       (13, 3),
       (14, 10),
       (15, 9),
       (16, 5),
       (17, 1),
       (18, 1),
       (19, 12),
       (20, 13),
       (21, 14),
       (22, 9),
       (23, 6),
       (24, 4),
       (25, 12),
       (26, 1),
       (27, 4),
       (28, 6),
       (29, 2),
       (30, 15),
       (31, 1),
       (32, 5),
       (33, 2),
       (34, 3),
       (35, 4),
       (36, 11),
       (37, 7),
       (38, 8),
       (1, 40),
       (2, 39),
       (3, 38),
       (4, 37),
       (5, 36),
       (6, 35),
       (7, 34),
       (8, 33),
       (9, 32),
       (10, 31),
       (11, 30),
       (12, 29),
       (13, 28),
       (14, 27),
       (15, 26),
       (16, 25),
       (17, 24),
       (18, 23),
       (19, 22),
       (20, 21),
       (21, 20),
       (22, 19),
       (23, 18),
       (24, 17),
       (25, 16),
       (26, 15),
       (27, 14),
       (28, 13),
       (29, 12),
       (30, 11),
       (31, 10),
       (32, 9),
       (33, 8),
       (34, 7),
       (35, 6),
       (36, 5),
       (37, 4),
       (38, 3);

CREATE TABLE plant_tags
(
    id       INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    plant_id INTEGER REFERENCES plants (id),
    tag_id   INTEGER REFERENCES tags (id)
);
INSERT INTO plant_tags (plant_id, tag_id)
VALUES (1, 1),
       (2, 1),
       (3, 3),
       (4, 5),
       (5, 2),
       (6, 8),
       (7, 4),
       (8, 6),
       (9, 3),
       (10, 2),
       (11, 11),
       (12, 7),
       (13, 3),
       (14, 10),
       (15, 9),
       (16, 5),
       (17, 1),
       (18, 1),
       (19, 12),
       (20, 13),
       (21, 14),
       (22, 9),
       (23, 6),
       (24, 4),
       (25, 12),
       (26, 1),
       (27, 4),
       (28, 6),
       (29, 2),
       (30, 15),
       (31, 1),
       (32, 5),
       (33, 2),
       (34, 3),
       (35, 4),
       (36, 11),
       (37, 7),
       (38, 8),
       (1, 40),
       (2, 39),
       (3, 38),
       (4, 37),
       (5, 36),
       (6, 35),
       (7, 34),
       (8, 33),
       (9, 32),
       (10, 31),
       (11, 30),
       (12, 29),
       (13, 28),
       (14, 27),
       (15, 26),
       (16, 25),
       (17, 24),
       (18, 23),
       (19, 22),
       (20, 21),
       (21, 20),
       (22, 19),
       (23, 18),
       (24, 17),
       (25, 16),
       (26, 15),
       (27, 14),
       (28, 13),
       (29, 12),
       (30, 11),
       (31, 10),
       (32, 9),
       (33, 8),
       (34, 7),
       (35, 6),
       (36, 5),
       (37, 4),
       (38, 3);
--
-- CREATE TABLE user_roles
-- (
--     id   INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
--     name VARCHAR(30)
-- );
-- INSERT INTO user_roles (name)
-- VALUES ('Admin'),
--        ('Customer');

CREATE TABLE permission_group
(
    id                 INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    role               VARCHAR(20) UNIQUE,
    "AccessControlSet" jsonb  NOT NULL
);
INSERT INTO permission_group (role,
                              "AccessControlSet")
VALUES ('Admin',
        '[{ "resource": "post", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "comment", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "permission", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "admin", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "manager", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "staff", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "customer", "action": { "create": true, "read": true, "update": true, "delete": true } }
        ]'::jsonb);

-- Permission for Manager role
INSERT INTO permission_group (role,
                              "AccessControlSet")
VALUES ('Manager',
        '[ { "resource": "post", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "comment", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "staff", "action": { "create": true, "read": true, "update": true, "delete": true } }
        ]'::jsonb);

-- Permission for Staff role
INSERT INTO permission_group (role,
                              "AccessControlSet")
VALUES ('Staff',
        '[ { "resource": "post", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "comment", "action": { "create": true, "read": true, "update": true, "delete": true } },
          { "resource": "customer", "action": { "create": true, "read": true, "update": true, "delete": true } }
        ]'::jsonb);

-- Permission for Customer role
INSERT INTO permission_group (role,
                              "AccessControlSet")
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
    fullname            VARCHAR                  NOT NULL,
    email       VARCHAR(30)              NOT NULL UNIQUE,
    password            VARCHAR(80)              NOT NULL CHECK (LENGTH(RTRIM(password)) >= 6),
    "permissionGroupId" INTEGER                  NOT NULL REFERENCES permission_group (id),
    address             VARCHAR,
    "phoneNumber"       varchar,
    "dateOfBirth"        TIMESTAMP,
    "lastLogin"          TIMESTAMP,
    created_at           TIMESTAMP  DEFAULT now()  NOT NULL,
    updated_at           TIMESTAMP  DEFAULT now()  NOT NULL,
    "isActive"          boolean    DEFAULT true   NOT NULL
);
-- INSERT INTO users (first_name, last_name, email_address, password, country, street_address, apartment, city,
--                    phone, role_id)
-- VALUES ('Hoang Anh', 'Quoc', 'anhquoc5.1.2003.q@gmail.com', '123456', 'Viet Nam', 'Thach Hoa - Thach That',
--         'YoungHouse', 'Ha Noi', '0859159180', 1),
--        ('Nguyen Thi', 'A', 'nguyenthiA1873@gmail.com', '123456', 'Viet Nam', 'Trieu Son', 'YoungHouse', 'Thanh Hoa',
--         '0859159180', 2);
INSERT INTO users (
                   fullname,
                   email,
                   password,
                   "permissionGroupId",
                   address,
                   "phoneNumber",
                   "dateOfBirth",
                   "lastLogin",
                   "isActive")
VALUES (
        'Jane Doe',
        'jane.doe@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE role = 'Manager'),
        '456 Elm St',
        '555-5678',
        '1985-05-15',
        '2024-08-13 10:00:00',
        true),
       (
        'Bob Smith',
        'bob.smith@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE role = 'Staff'),
        NULL, -- No address provided
        NULL, -- No phone number provided
        '1978-11-20',
        NULL, -- No last login date provided
        true),
       (
        'Alice Jones',
        'alice.jones@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE role = 'Customer'),
        '789 Oak St',
        '555-7890',
        '1992-03-10',
        '2024-08-12 09:30:00',
        true);

CREATE VIEW user_view AS
SELECT users.*, permission_group.role AS role_name
FROM users
         JOIN permission_group ON users."permissionGroupId" = permission_group.id;

CREATE TABLE order_status
(
    id   INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    name VARCHAR(20)
);
INSERT INTO order_status (name)
VALUES ('Pending'),
       ('Processing'),
       ('Delivered'),
       ('Cancelled'),
       ('Returned');

CREATE TABLE orders
(
    id              INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,

    country         VARCHAR(20)    NOT NULL,
    street_address  VARCHAR(128)   NOT NULL,
    apartment       VARCHAR(128),

    city            VARCHAR(128)   NOT NULL,
    total_price     DECIMAL(5, 2)  NOT NULL                DEFAULT 0,
    order_date       TIMESTAMP(3)                          DEFAULT CURRENT_TIMESTAMP,
    order_status_id INTEGER REFERENCES order_status (id)  DEFAULT 1,
    customer_id     INTEGER REFERENCES users (id)
);

CREATE TABLE order_detail
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,

    product_id INTEGER REFERENCES plants (id),
    quantity   INTEGER        NOT NULL,
    subtotal   DECIMAL(5, 2)  NOT NULL  DEFAULT 0,
    order_id   INTEGER REFERENCES orders (id)
);
-- CREATE OR REPLACE FUNCTION update_total_price_of_order_func() RETURNS TRIGGER AS $$
--     UPDATE orders
--     SET total_price = (SELECT SUM(plants.unit_price * order_detail.quantity)
--                        FROM plants
--                                 JOIN order_detail ON plants.id = order_detail.product_id
--                        WHERE order_detail.order_id = orders.id)
--     WHERE orders.id = (SELECT order_id FROM inserted);
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER update_total_price_of_order
--
--     AFTER INSERT ON order_detail
-- FOR EACH ROW
--
-- EXECUTE FUNCTION update_total_price_of_order_func();

CREATE VIEW order_view AS
SELECT orders.id,
       orders.country,
       orders.street_address,
       orders.apartment,
       orders.city,
       orders.total_price,
       orders.order_date,
       order_status.name                          AS order_status,
       orders.customer_id,
       users.fullname AS customer_name,
       users.email,
       users."phoneNumber"
FROM orders
         JOIN order_status ON orders.order_status_id = order_status.id
         JOIN users ON orders.customer_id = users.id;

CREATE VIEW order_detail_view AS
SELECT order_detail.id,
       order_detail.product_id,
       plants.title                              AS product_name,
       order_detail.quantity,
       plants.unit_price,
       order_detail.quantity * plants.unit_price AS sub_total_price,
       order_detail.order_id
FROM order_detail
         JOIN plants ON order_detail.product_id = plants.id;


CREATE TABLE carts
(
    id          INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    customer_id INTEGER REFERENCES users (id),
    total_price DECIMAL(5, 2)  NOT NULL  DEFAULT 0
);
INSERT INTO carts (customer_id)
SELECT id
FROM users;

CREATE TABLE cart_detail
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    product_id INTEGER REFERENCES plants (id),
    quantity   INTEGER        NOT NULL,
    cart_id    INTEGER REFERENCES carts (id),
    sub_total  DECIMAL(5, 2)  NOT NULL  DEFAULT 0
);


CREATE VIEW plant_with_categories_view AS
SELECT plants.id,
       plants.title,
       plants.description,
       plants.image_link,
       plants.color,
       plants.unit_price,
       plants.quantity,
       plants.sale_opening,
       plants.stock_status,
       categories.id   AS category_id,
       categories.name AS category_name,
       categories.active

FROM plants
         JOIN plant_categories ON plants.id = plant_categories.plant_id
         JOIN categories ON plant_categories.category_id = categories.id;

CREATE VIEW plant_with_tags_view AS
SELECT plants.id,
       plants.title,
       plants.description,
       plants.image_link,
       plants.color,
       plants.unit_price,
       plants.quantity,
       plants.sale_opening,
       plants.stock_status,
       tags.id   AS tag_id,
       tags.name AS tag_name,
       tags.active

FROM plants
         JOIN plant_tags ON plants.id = plant_tags.plant_id
         JOIN tags ON plant_tags.tag_id = tags.id

-- CREATE OR REPLACE PROCEDURE usb_PlantsFindByPage(p_page_index INT, p_page_size INT, IN OUT cur REFCURSOR)
-- AS $$
--     BEGIN
--
--         OPEN cur FOR WITH plantPage AS
--         (
--             SELECT Plants.*, ROW_NUMBER() OVER (ORDER BY id) AS index
--             FROM Plants
--         )
--
--         SELECT * FROM plantPage
--         WHERE plantPage.index BETWEEN (p_page_index - 1) * p_page_size + 1 AND p_page_index * p_page_size;
--     END;
--
-- CALL usb_PlantsFindByPage(1, 5);
-- $$ LANGUAGE plpgsql;