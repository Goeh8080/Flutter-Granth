-- Standalone sample; not part of the app build.
CREATE OR REPLACE FUNCTION granth_titles() RETURNS SETOF text AS $$
BEGIN
  RETURN QUERY SELECT title FROM granths ORDER BY position;
END;
$$ LANGUAGE plpgsql;
-- Granth list sample — prints titles in order.
-- Granth list sampl
