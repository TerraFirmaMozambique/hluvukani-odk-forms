
CREATE TABLE public.update_form_b_pessoas
(
sub_date timestamp without time zone,
start timestamp without time zone,
form_name character varying,
intronote character varying,
tec_nome character varying,
data date,
region_id character varying,
bloco_id character varying,
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
finish date,
meta_id character varying,
meta_name character varying,
key character varying
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.update_form_b_pessoas OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_b_pessoas TO public;
GRANT ALL ON TABLE public.update_form_b_pessoas TO postgres;


COPY public.update_form_b_pessoas FROM '/var/lib/share/projects/illovo/working_folder/Hluvukani B Registrar Pessoas.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

DELETE FROM public.update_form_b_pessoas a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_b_pessoas b
                 WHERE  a.key = b.key);


DELETE from public.update_form_b_pessoas
WHERE EXISTS (SELECT 1 FROM public.form_b_pessoas 
WHERE key = public.update_form_b_pessoas.key);



INSERT INTO public.form_b_pessoas(
sub_date, start, form_name, intronote, tec_nome, data, region_id, bloco_id, pessoa_app, pessoa_nom, pessoa_gen, pessoa_civil, pessoa_prof, pessoa_prof_other, pessoa_nacion, pessoa_natural, nasc_y_n, pessoa_nasc, pessoa_ida, pessoa_doc, pessoa_id, doc_local, doc_emi, doc_val, doc_vital, pessoa_foto, id_foto, pessoa_assin, contacto, finish, meta_id, meta_name, key)
SELECT sub_date, start, form_name, intronote, tec_nome, data, region_id, bloco_id, pessoa_app, pessoa_nom, pessoa_gen, pessoa_civil, pessoa_prof, pessoa_prof_other, pessoa_nacion, pessoa_natural, nasc_y_n, pessoa_nasc, pessoa_ida, pessoa_doc, pessoa_id, doc_local, doc_emi, doc_val, doc_vital, pessoa_foto, id_foto, pessoa_assin, contacto, finish, meta_id, meta_name, key
FROM update_form_b_pessoas;

UPDATE public.form_b_pessoas SET id_party = 'party';

UPDATE public.form_b_pessoas SET id_party = id_party||id;

UPDATE public.form_b_pessoas SET party_name = pessoa_nom||' '||pessoa_app||' '||pessoa_doc||' '|| pessoa_id;


Copy (select bloco_id AS bloco_id_key, id_party AS party_id_key, party_name FROM public.form_b_pessoas where region_id = 'Central') TO '/var/lib/share/projects/illovo/ODK Forms/hluvukani-odk-forms/Hluvukani_C_registrar_parcelas/Hluvukani_C_registrar_parcelas-media/Central.csv' DELIMITER ',' NULL AS '' CSV HEADER ENCODING 'latin1';

Copy (select bloco_id AS bloco_id_key, id_party AS party_id_key, party_name FROM public.form_b_pessoas where region_id = 'Norte') TO '/var/lib/share/projects/illovo/ODK Forms/hluvukani-odk-forms/Hluvukani_C_registrar_parcelas/Hluvukani_C_registrar_parcelas-media/Norte.csv' DELIMITER ',' NULL AS '' CSV HEADER ENCODING 'latin1';

Copy (select bloco_id AS bloco_id_key, id_party AS party_id_key, party_name FROM public.form_b_pessoas where region_id = 'Sul') TO '/var/lib/share/projects/illovo/ODK Forms/hluvukani-odk-forms/Hluvukani_C_registrar_parcelas/Hluvukani_C_registrar_parcelas-media/Sul.csv' DELIMITER ',' NULL AS '' CSV HEADER ENCODING 'latin1';


DROP TABLE public.update_form_b_pessoas;