
CREATE OR REPLACE FUNCTION login_user(usernam TEXT, pass TEXT)
RETURNS VARCHAR(40)
LANGUAGE plpgsql
AS $$
DECLARE
  iff INTEGER DEFAULT NULL;
  itt VARCHAR(40) DEFAULT NULL;
BEGIN
  SELECT user_id INTO iff FROM app_user WHERE username = usernam AND pass = password LIMIT 1;

  IF iff IS NOT NULL THEN
    SELECT token INTO itt FROM login_session WHERE user_id = iff;

    IF itt IS NULL THEN
      INSERT INTO login_session(user_id, token) VALUES (iff, (SELECT string_agg(substr('abcdefghijklmnopqrstuvwxyz0123456789', floor(random()*36 + 1)::int, 1),'') FROM generate_series(1,40))) RETURNING token INTO itt;
    END IF;
  ELSE
    RETURN NULL;
  END IF;

  RETURN itt;
END;
$$;
