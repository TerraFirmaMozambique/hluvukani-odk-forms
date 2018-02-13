DROP TABLE public.table_occ_master;

CREATE TABLE public.table_occ_master
(
  uuid character varying,
  region_id character varying,
  bloco_id character varying,
  parcel_id integer,
  party_id character varying,
  nome character varying,
  genero character varying,
  nas date,
  idad character varying,
  doc character varying,
  doc_id character varying,
  party_name_key character varying NOT NULL,
  CONSTRAINT table_occ_master_pkey PRIMARY KEY (party_name_key)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.table_occ_master
  OWNER TO postgres;
GRANT ALL ON TABLE public.table_occ_master TO public;
GRANT ALL ON TABLE public.table_occ_master TO postgres;

COPY public.table_occ_master FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_table_occ_master.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';


