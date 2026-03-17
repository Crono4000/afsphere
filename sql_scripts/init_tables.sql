
CREATE TABLE disk (
    disk_id SERIAL PRIMARY KEY,
    disk_limit BIGINT DEFAULT 0,
    disk_used BIGINT DEFAULT 0,
    disk_path TEXT,

    UNIQUE (disk_id),
    UNIQUE (disk_path)
);

CREATE TABLE file (
    file_id SERIAL PRIMARY KEY,
    file_size BIGINT,
    disk_id INTEGER,
    file_name TEXT NOT NULL,

    UNIQUE (file_name),
    FOREIGN KEY (disk_id)
    REFERENCES disk(disk_id)
    ON DELETE CASCADE
);

CREATE TABLE sphere (
    sphere_id SERIAL PRIMARY KEY,
    sphere_name TEXT NOT NULL,
    UNIQUE (sphere_name)
);

CREATE TABLE connection (
    rank INTEGER,
    sphere_id INTEGER,
    file_id INTEGER,

    PRIMARY KEY (sphere_id, file_id),
    UNIQUE (sphere_id, file_id),

    FOREIGN KEY (file_id)
    REFERENCES file(file_id)
    ON DELETE CASCADE,

    FOREIGN KEY (sphere_id)
    REFERENCES sphere(sphere_id)
    ON DELETE CASCADE
);

CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(30) NOT NULL,

    UNIQUE (username)
);

CREATE TABLE login_session (
    key_login SERIAL PRIMARY KEY,
    token CHAR(40),
    user_id INTEGER,

    UNIQUE (token),
    FOREIGN KEY (user_id)
    REFERENCES app_user(user_id)
    ON DELETE CASCADE
);

CREATE TABLE permission (
    permission_id SERIAL PRIMARY KEY,
    permission_name VARCHAR(20) NOT NULL,

    UNIQUE (permission_name)
);

CREATE TABLE user_permission (
    user_id INTEGER,
    permission_id INTEGER,

    PRIMARY KEY (user_id, permission_id),
    UNIQUE (user_id, permission_id),

    FOREIGN KEY (user_id)
    REFERENCES app_user(user_id)
    ON DELETE CASCADE,

    FOREIGN KEY (permission_id)
    REFERENCES permission(permission_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_file_name
ON file(file_name);

CREATE INDEX idx_file_id
ON file(file_id);

CREATE INDEX idx_sphere_name
ON sphere(sphere_name);

CREATE INDEX idx_sphere_id
ON sphere(sphere_id);
