CREATE OR REPLACE TABLE staging.priority_roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50),
    priority_role BOOLEAN
);

INSERT INTO staging.priority_roles (role_id, role_name, priority_role)
VALUES (1, 'Data Engineer', TRUE),
       (2, 'Senior Data Engineer', TRUE),
       (3, 'Software Engineer', FALSE);

SELECT * FROM staging.priority_roles;

