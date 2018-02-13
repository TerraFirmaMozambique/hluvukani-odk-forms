CREATE TABLE public.update_form_c_novas_pessoas
(
  
  key character varying NOT NULL,
  app character varying,
  nome character varying,
  gen character varying,
  civil character varying,
  prof character varying,
  prof_other character varying,
  nacion character varying,
  naturalidade character varying,
  nascyn character varying,
  nasc date,
  ida character varying,
  doc character varying,
  doc_id character varying,
  doc_local character varying,
  doc_emi date,
  doc_val date,
  doc_vital character varying,
  foto character varying,
  doc_foto character varying,
  assin character varying,
  contacto integer,
  party_name character varying,
  party_name_key character varying,
  confirmado character varying,
  parcel_id integer
  )
  
WITH (
  OIDS=TRUE
);
ALTER TABLE public.update_form_c_novas_pessoas
  OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_c_novas_pessoas TO public;
GRANT ALL ON TABLE public.update_form_c_novas_pessoas TO postgres;

COPY public.update_form_c_novas_pessoas FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_novas_pessoas.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

DELETE FROM public.update_form_c_novas_pessoas a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_c_novas_pessoas b
                 WHERE  a.party_name_key = b.party_name_key);

DELETE from public.update_form_c_novas_pessoas
WHERE EXISTS (SELECT 1 FROM public.form_c_novas_pessoas 
WHERE party_name_key = public.update_form_c_novas_pessoas.party_name_key);

INSERT INTO public.form_c_novas_pessoas(
            key, app, nome, gen, civil, prof, prof_other, nacion, naturalidade, 
            nascyn, nasc, ida, doc, doc_id, doc_local, doc_emi, doc_val, 
            doc_vital, foto, doc_foto, assin, contacto, party_name, party_name_key, 
            confirmado, parcel_id)
SELECT key, app, nome, gen, civil, prof, prof_other, nacion, naturalidade, 
       nascyn, nasc, ida, doc, doc_id, doc_local, doc_emi, doc_val, 
       doc_vital, foto, doc_foto, assin, contacto, party_name, party_name_key, 
       confirmado, parcel_id
  FROM public.update_form_c_novas_pessoas;		

  DROP TABLE public.update_form_c_novas_pessoas;







