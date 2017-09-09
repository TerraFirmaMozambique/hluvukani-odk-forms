-- this query uses a select query to add names to the form_b_pessoas table from the form_c_parcelas - form_c_novas_pessoas relationship


-- 1st we add new people collected during the completion of the ODK from form_c_parcelas
-- After the VBA code has been run form C, we build a primary table "public.update_novas_pessoas" which allows a check of the data through VFront for "proof of life"

DROP TABLE public.update_novas_pessoas;

CREATE TABLE public.update_novas_pessoas
(
id serial,
parent_uid character varying,
pessoa_app character varying,
pessoa_nom character varying,
pessoa_gen character varying,
pessoa_civil character varying,
pessoa_prof character varying,
pessoa_prof_other character varying,
pessoa_nacion character varying,
pessoa_natural character varying,
nasc_y_n character varying,
pessoa_nasc date,
pessoa_ida character varying,
pessoa_doc character varying,
pessoa_id character varying,
doc_local character varying,
doc_emi date,
doc_val date,
doc_vital character varying,
pessoa_foto character varying,
id_foto character varying,
pessoa_assin character varying,
contacto integer,
party_name character varying,
confirmado character varying(3) NOT NULL DEFAULT 'não'::character varying,
CONSTRAINT pkey_update_novas_pessoas PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.update_novas_pessoas  OWNER to postgres;

-- upload the ODK output
COPY public.update_novas_pessoas FROM '/var/lib/share/projects/illovo/working_folder/Hluvukani_C_novas_pessoas.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

-- delete any data already in table_b

DELETE FROM public.update_novas_pessoas
WHERE EXISTS (SELECT 1 FROM public.form_b_pessoas 
WHERE key = public.update_novas_pessoas.parent_uid );

UPDATE public.update_novas_pessoas 
--set the display propertieds of the photos

SET pessoa_foto = '<img src="'||pessoa_foto||'" style="width:256px;height:256px;">',
id_foto = '<img src="'||id_foto||'" style="width:256px;height:256px;">',
pessoa_assin = '<img src="'||pessoa_assin||'" style="width:256px;height:256px;">';