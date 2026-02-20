
ALTER TABLE file
ADD CONSTRAINT file_file_name_unique
UNIQUE (file_name);