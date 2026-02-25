
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
