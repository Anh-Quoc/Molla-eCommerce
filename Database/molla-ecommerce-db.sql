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
    full_name           VARCHAR                 NOT NULL,
    email               VARCHAR(30)             NOT NULL UNIQUE,
    password            VARCHAR(80)             NOT NULL CHECK (LENGTH(RTRIM(password)) >= 6),
    permission_group_id INTEGER                 NOT NULL REFERENCES permission_group (id),
    address             VARCHAR,
    phone               VARCHAR(15) UNIQUE,
    dob                 TIMESTAMP,
    last_login          TIMESTAMP,
    created_at          TIMESTAMP DEFAULT now() NOT NULL,
    updated_at          TIMESTAMP DEFAULT now() NOT NULL,
    active              BOOLEAN   DEFAULT TRUE  NOT NULL
);

INSERT INTO users (
    full_name,
    email,
    password,
    permission_group_id,
    address,
    phone,
    dob,
    last_login,
    active)
VALUES (
           'Jane Doe',
           'jane.doe@example.com',
           '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
           (SELECT id FROM permission_group WHERE name = 'Manager'),
           '456 Elm St',
           '555-5678',
           '1985-05-15',
           '2024-08-13 10:00:00',
           true),
       (
           'Bob Smith',
           'bob.smith@example.com',
           '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
           (SELECT id FROM permission_group WHERE name = 'Staff'),
           NULL, -- No address provided
           NULL, -- No phone number provided
           '1978-11-20',
           NULL, -- No last login date provided
           true),
       (
           'Alice Jones',
           'alice.jones@example.com',
           '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
           (SELECT id FROM permission_group WHERE name = 'Customer'),
           '789 Oak St',
           '555-7890',
           '1992-03-10',
           '2024-08-12 09:30:00',
           true);