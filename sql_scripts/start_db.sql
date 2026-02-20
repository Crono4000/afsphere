
CREATE TABLE file (
    file_id SERIAL PRIMARY KEY,
    file_path TEXT NOT NULL,
    file_name TEXT NOT NULL
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

CREATE INDEX idx_file_id
ON file(file_id);

CREATE INDEX idx_sphere_name
ON sphere(sphere_name);

CREATE INDEX idx_sphere_id
ON sphere(sphere_id);

CREATE OR REPLACE PROCEDURE add_file_with_sphere(ficheiro_nome text, ficheiro_caminho text, sphere_nome text)
LANGUAGE plpgsql
AS $$
DECLARE
    novo_id INTEGER;
    file_ii INTEGER;
BEGIN
  IF NOT EXISTS(SELECT * FROM sphere WHERE sphere_name = sphere_nome) THEN
    INSERT INTO sphere (sphere_name) VALUES (sphere_nome) RETURNING sphere_id INTO novo_id;
  ELSE
    SELECT sphere_id FROM sphere WHERE sphere_name = sphere_nome INTO novo_id;
  END IF;
  
  INSERT INTO file(file_name, file_path) VALUES (ficheiro_nome, ficheiro_caminho) RETURNING file_id INTO file_ii;
  INSERT INTO connection(file_id, sphere_id) VALUES (file_ii, novo_id);
END;
$$;

CREATE OR REPLACE PROCEDURE transfer_sphere_to_sphere(sphere_from text, sphere_destiny text)
LANGUAGE plpgsql
AS $$
DECLARE
  macaco INTEGER;
BEGIN
  SELECT sphere_id FROM sphere WHERE sphere_name = sphere_destiny INTO macaco; 

  INSERT INTO connection(file_id, sphere_id)
  SELECT file_id, macaco
  FROM connection, sphere
  WHERE connection.sphere_id = sphere.sphere_id AND sphere_name = sphere_from
  ON CONFLICT(file_id, sphere_id) DO NOTHING;
END;
$$;

ALTER TABLE file
ADD CONSTRAINT file_file_name_unique
UNIQUE (file_name);