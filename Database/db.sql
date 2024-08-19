-- Insert roles if they don't already exist
-- INSERT INTO
--     roles (name)
-- VALUES
--     ('Manager'),
--     ('Staff'),
--     ('Customer'),
--     ('Guest');


-- Insert permissions
-- Permission for Admin role
INSERT INTO permission_group (role,
                              "AccessControlSet")
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
INSERT INTO permission_group (role,
                              "AccessControlSet")
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
INSERT INTO permission_group (role,
                              "AccessControlSet")
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

-- Insert users
-- Sample 1
INSERT INTO users (email,
                   password,
                   "permissionGroupId",
                   fullname,
                   address,
                   "phoneNumber",
                   "dateOfBirth",
                   "lastLogin",
                   "isActive")
VALUES ('jane.doe@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE role = 'Manager'),
        'Jane Doe',
        '456 Elm St',
        '555-5678',
        '1985-05-15',
        '2024-08-13 10:00:00',
        true),
       ('bob.smith@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE role = 'Staff'),
        'Bob Smith',
        NULL, -- No address provided
        NULL, -- No phone number provided
        '1978-11-20',
        NULL, -- No last login date provided
        true),
       ('alice.jones@example.com',
        '$2b$10$zVQ.FB77IECAfCt7uENASO4bAV8IKIhGQJJGMbIuNmYP70LzBkbCC',
        (SELECT id FROM permission_group WHERE role = 'Customer'),
        'Alice Jones',
        '789 Oak St',
        '555-7890',
        '1992-03-10',
        '2024-08-12 09:30:00',
        true);
