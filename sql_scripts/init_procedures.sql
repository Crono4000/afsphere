
CREATE OR REPLACE PROCEDURE insert_file(ficheiro_nome text, siz BIGINT, OUT file_ud INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    disk_idd INTEGER;
    disk_pathh TEXT;
    disk_cur INTEGER;
BEGIN
  SELECT disk_id, disk_path, disk_current INTO disk_idd, disk_pathh, disk_cur FROM disk WHERE disk_used + siz < disk_limit LIMIT 1;
  IF disk_idd IS NULL THEN
    RAISE EXCEPTION 'There are no disks available';
  END IF;
  SELECT file_id INTO file_ud FROM file WHERE disk_id IS NULL LIMIT 1;

  IF file_ud IS NOT NULL THEN
    UPDATE file SET file_name = ficheiro_nome, file_path = CONCAT_WS('/', disk_pathh, disk_cur), disk_id = disk_idd, file_size = siz WHERE file_id = file_ud;
  ELSE
    INSERT INTO file(file_name, file_path, disk_id, file_size) VALUES (ficheiro_nome,  CONCAT_WS('/', disk_pathh, disk_cur), disk_idd, siz) RETURNING file_id INTO file_ud;
  END IF;

  CALL update_disk_size(NULL, NULL, disk_idd);
END;
$$;

CREATE OR REPLACE PROCEDURE add_file_with_sphere(ficheiro_nome text, siz BIGINT, sphere_nome text)
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
  
  CALL insert_file(ficheiro_nome, siz, file_ii);
  INSERT INTO connection(file_id, sphere_id) VALUES (file_ii, novo_id);
END;
$$;

CREATE OR REPLACE PROCEDURE transfer_sphere_to_sphere(sphere_from text, sphere_destiny text)
LANGUAGE plpgsql
AS $$
DECLARE
  macaco INTEGER DEFAULT NULL;
BEGIN
  SELECT sphere_id FROM sphere WHERE sphere_name = sphere_destiny INTO macaco;
  IF macaco IS NULL THEN

  END IF;

  INSERT INTO connection(file_id, sphere_id)
  SELECT file_id, macaco
  FROM connection, sphere
  WHERE connection.sphere_id = sphere.sphere_id AND sphere_name = sphere_from
  ON CONFLICT(file_id, sphere_id) DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE update_disk_size(t_file_id INT, t_file_name TEXT, t_disk_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
  IF t_file_id IS NOT NULL THEN
    SELECT disk_id INTO t_disk_id FROM file WHERE file_id = t_file_id LIMIT 1;
  ELSE
    IF t_file_name IS NOT NULL THEN
      SELECT disk_id INTO t_disk_id FROM file WHERE file_name = t_file_name LIMIT 1;
    END IF;
  END IF;

  UPDATE disk SET disk_used = (SELECT SUM(file_size) FROM file WHERE disk_id = t_disk_id),
  disk_current = (SELECT COUNT(*) FROM file WHERE disk_id = t_disk_id)
  WHERE disk_id = t_disk_id;
END;
$$;
