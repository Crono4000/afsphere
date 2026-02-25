
CREATE TABLE file (
    file_id SERIAL PRIMARY KEY,
    file_path TEXT NOT NULL,
    file_size BIGINT,
    file_name TEXT NOT NULL,

    FOREIGN KEY (disk_id)
    REFERENCES disk(disk_id)
    ON DELETE CASCADE
);

CREATE TABLE sphere (
    sphere_id SERIAL PRIMARY KEY,
    sphere_name TEXT NOT NULL
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

CREATE TABLE disk (
    disk_id INTEGER,
    disk_limit BIGINT,
    disk_used BIGINT,
    disk_path TEXT,

    PRIMARY KEY (disk_id),
    UNIQUE (disk_id),
    UNIQUE (disk_path)
);

CREATE INDEX idx_file_id
ON file(file_id);

CREATE INDEX idx_sphere_name
ON sphere(sphere_name);

CREATE INDEX idx_sphere_id
ON sphere(sphere_id);

ALTER TABLE file
ADD CONSTRAINT file_file_name_unique
UNIQUE (file_name);
