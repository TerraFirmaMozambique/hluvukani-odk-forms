CREATE TABLE public.update_form_d_occ
(
  sub_date timestamp without time zone,
  start timestamp without time zone,
  form_name character varying,
  intronote character varying,
  tec_nome character varying,
  add_nome character varying,
  region_id character varying,
  bloco_id character varying,
  parcel_id integer,
  parcel_id_check integer,
  outcome character varying,
  party_id character varying,
  party_id_check character varying,
  issues character varying,
  parcel_id_new character varying,
  pessoa_app_new character varying,
  pessoa_nom_new character varying,
  pessoa_gen_new character varying,
  data_new date,
  pessoa_doc_new character varying,
  pessoa_id_new character varying,
  limites_new character varying,
  limites_new_image character varying,
  finish timestamp without time zone,
  inst_id character varying,
  inst_name character varying,
  key character varying NOT NULL
)
WITH (
  OIDS=TRUE
);
ALTER TABLE public.update_form_d_occ
  OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_d_occ TO public;
GRANT ALL ON TABLE public.update_form_d_occ TO postgres;

COPY public.update_form_d_occ FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_D_occ.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

DELETE from public.update_form_d_occ
WHERE EXISTS (SELECT 1 FROM public.form_d_occ 
WHERE key = public.update_form_d_occ.key);

DELETE FROM public.update_form_d_occ a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_d_occ b
                 WHERE  a.key = b.key);

UPDATE public.update_form_d_occ 
SET limites_new_image = '<img src="'||limites_new_image||'" style="width:1024px;height:1024px;">';

INSERT INTO public.form_d_occ(
            sub_date, start, form_name, intronote, tec_nome, add_nome, region_id, 
            bloco_id, parcel_id, parcel_id_check, outcome, party_id, party_id_check, 
            issues, parcel_id_new, pessoa_app_new, pessoa_nom_new, pessoa_gen_new, 
            data_new, pessoa_doc_new, pessoa_id_new, limites_new, limites_new_image, 
            finish, inst_id, inst_name, key)
SELECT sub_date, start, form_name, intronote, tec_nome, add_nome, region_id, 
       bloco_id, parcel_id, parcel_id_check, outcome, party_id, party_id_check, 
       issues, parcel_id_new, pessoa_app_new, pessoa_nom_new, pessoa_gen_new, 
       data_new, pessoa_doc_new, pessoa_id_new, limites_new, limites_new_image, 
       finish, inst_id, inst_name, key
  FROM public.update_form_d_occ;

DROP TABLE  public.update_form_d_occ;