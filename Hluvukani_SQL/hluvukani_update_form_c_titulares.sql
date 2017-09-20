--updating titulars with known parties.... 

DROP TABLE public.update_form_c_titulares;


CREATE TABLE public.update_form_c_titulares
(
  parentuid character varying NOT NULL,
  searchtext character varying,
  foundparty character varying
  
)
WITH (
  OIDS=TRUE
);
ALTER TABLE public.update_form_c_titulares OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_c_titulares TO postgres;

COPY public.update_form_c_titulares FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_titulars.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

-- this removes all new parties and ensures only those parties already in the database are added to the database table.

-- this removes all new parties and ensures only those parties already in the database are added to the database table.

DELETE FROM public.update_form_c_titulares 
WHERE foundparty = '1';

ALTER TABLE public.update_form_c_titulares ADD COLUMN titulares character varying;

UPDATE public.update_form_c_titulares 
SET titulares = concat ("parentuid","searchtext","foundparty");

-- delete duplicates in update_form_c_titulares
DELETE FROM public.update_form_c_titulares a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_c_titulares b
                 WHERE  a.titulares = b.titulares);

-- delete from update_form_c_titulares data already parsed into dbase
  
DELETE FROM public.update_form_c_titulares
WHERE EXISTS (SELECT 1 FROM public.form_c_titulares 
WHERE titulares = public.update_form_c_titulares.titulares);


INSERT INTO public.form_c_titulares(parentuid, searchtext, foundparty, titulares)
SELECT parentuid, searchtext, foundparty, titulares
FROM public.update_form_c_titulares;
	
DELETE FROM public.form_c_titulares a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.form_c_titulares b
                 WHERE  a.titulares = b.titulares);
				 

				 
DROP TABLE public.update_form_c_titulares;


