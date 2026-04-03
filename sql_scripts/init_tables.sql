
CREATE TABLE IF NOT EXISTS disk (
    disk_id SERIAL PRIMARY KEY,
    disk_limit BIGINT DEFAULT 0,
    disk_used BIGINT DEFAULT 0,
    disk_path TEXT,
    disk_current INTEGER DEFAULT 0,
    disk_priority INTEGER DEFAULT 0,

    UNIQUE (disk_id),
    UNIQUE (disk_path)
);

ALTER TABLE disk
ADD COLUMN IF NOT EXISTS disk_priority INTEGER DEFAULT 0;

CREATE TABLE IF NOT EXISTS file (
    file_id SERIAL PRIMARY KEY,
    file_path TEXT NOT NULL,
    file_size BIGINT,
    disk_id INTEGER,
    file_name TEXT NOT NULL,

    UNIQUE (file_name),
    FOREIGN KEY (disk_id)
    REFERENCES disk(disk_id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS sphere (
    sphere_id SERIAL PRIMARY KEY,
    sphere_name TEXT NOT NULL,
    UNIQUE (sphere_name)
);

CREATE TABLE IF NOT EXISTS connection (
    rank INTEGER DEFAULT 0,
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

ALTER TABLE connection
ALTER COLUMN rank SET DEFAULT 0;

CREATE TABLE IF NOT EXISTS app_user (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(30) NOT NULL,

    UNIQUE (username)
);

CREATE TABLE IF NOT EXISTS login_session (
    key_login SERIAL PRIMARY KEY,
    token CHAR(40),
    user_id INTEGER,

    UNIQUE (token),
    FOREIGN KEY (user_id)
    REFERENCES app_user(user_id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS permission (
    permission_id SERIAL PRIMARY KEY,
    permission_name VARCHAR(20) NOT NULL,

    UNIQUE (permission_name)
);

CREATE TABLE IF NOT EXISTS user_permission (
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

CREATE INDEX IF NOT EXISTS idx_file_name
ON file(file_name);

CREATE INDEX IF NOT EXISTS idx_file_id
ON file(file_id);

CREATE INDEX IF NOT EXISTS idx_sphere_name
ON sphere(sphere_name);

CREATE INDEX IF NOT EXISTS idx_sphere_id
ON sphere(sphere_id);
