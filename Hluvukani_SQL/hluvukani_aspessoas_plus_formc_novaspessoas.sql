-- After the Proof of life check in the vfront, this query uses a select query to add names to the form_b_pessoas table from the form_c_parcelas - form_c_novas_pessoas relationship where titulars = '1' note the 1 is a sting not an integer... 


CREATE TABLE public.update_pessoas_nova AS SELECT 
  form_c_parcelas.subdate, 
  form_c_parcelas.start, 
  form_c_parcelas.myformname, 
  form_c_parcelas.intronote, 
  form_c_parcelas.tecnome, 
  form_c_parcelas.data, 
  form_c_parcelas.regionid, 
  form_c_parcelas.blocoid, 
  update_novas_pessoas.pessoa_app, 
  update_novas_pessoas.pessoa_nom, 
  update_novas_pessoas.pessoa_gen, 
  update_novas_pessoas.pessoa_civil, 
  update_novas_pessoas.pessoa_prof, 
  update_novas_pessoas.pessoa_prof_other, 
  update_novas_pessoas.pessoa_nacion, 
  update_novas_pessoas.pessoa_natural, 
  update_novas_pessoas.nasc_y_n, 
  update_novas_pessoas.pessoa_nasc, 
  update_novas_pessoas.pessoa_ida, 
  update_novas_pessoas.pessoa_doc, 
  update_novas_pessoas.pessoa_id, 
  update_novas_pessoas.doc_local, 
  update_novas_pessoas.doc_emi, 
  update_novas_pessoas.doc_val, 
  update_novas_pessoas.doc_vital, 
  update_novas_pessoas.pessoa_foto, 
  update_novas_pessoas.id_foto, 
  update_novas_pessoas.pessoa_assin, 
  update_novas_pessoas.contacto, 
  form_c_parcelas.finish, 
  form_c_parcelas.inst_id, 
  form_c_parcelas.inst_name, 
  update_novas_pessoas.parent_uid,
  update_novas_pessoas.party_name
FROM 
  public.form_c_parcelas, 
  public.update_novas_pessoas
WHERE 
  form_c_parcelas.key = update_novas_pessoas.parent_uid AND
  update_novas_pessoas.confirmado = 'sim';
  
  ALTER TABLE public.update_novas_pessoas OWNER TO postgres;

-- delete duplicates

DELETE FROM public.update_pessoas_nova a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_pessoas_nova b
                 WHERE  a.parent_uid = b.parent_uid);
				 

-- delete occurances we already have

DELETE from public.update_pessoas_nova
WHERE EXISTS (SELECT 1 FROM public.form_b_pessoas
WHERE key = public.update_pessoas_nova.parent_uid );

-- insert new validated pessoas into form b 

INSERT INTO public.form_b_pessoas(
            sub_date, start, form_name, intronote, tec_nome, 
            data, region_id, bloco_id, pessoa_app, pessoa_nom, pessoa_gen, 
            pessoa_civil, pessoa_prof, pessoa_prof_other, pessoa_nacion, 
            pessoa_natural, nasc_y_n, pessoa_nasc, pessoa_ida, pessoa_doc, 
            pessoa_id, doc_local, doc_emi, doc_val, doc_vital, pessoa_foto, 
            id_foto, pessoa_assin, contacto, finish, meta_id, meta_name, 
            key, party_name)
SELECT subdate, start, myformname, intronote, tecnome, 
data, regionid, blocoid, pessoa_app, pessoa_nom, pessoa_gen, 
pessoa_civil, pessoa_prof, pessoa_prof_other, pessoa_nacion, 
pessoa_natural, nasc_y_n, pessoa_nasc, pessoa_ida, pessoa_doc, 
pessoa_id, doc_local, doc_emi, doc_val, doc_vital, pessoa_foto, id_foto, pessoa_assin, contacto, finish, inst_id, inst_name, parent_uid, party_name
FROM public.update_pessoas_nova;

 -- attribute party id 
  
UPDATE public.form_b_pessoas SET id_party = 'party'||id;

--- Insert into form_c_titulares the new person with the new associated id_party

INSERT INTO public.form_c_titulares(parentuid, foundparty)
SELECT 
  update_pessoas_nova.parent_uid,
  form_b_pessoas.id_party
FROM 
  public.form_b_pessoas, 
  public.update_pessoas_nova
WHERE 
  form_b_pessoas.key = update_pessoas_nova.parent_uid;


-- delete from update_novas_pessoas those validated and added to form_b_pessoas

DELETE from public.update_novas_pessoas
WHERE EXISTS (SELECT 1 FROM public.form_b_pessoas
WHERE key = public.update_novas_pessoas.parent_uid );


-- produce updated regional lists for form_C which would update the lists produced from form_b  

Copy (select bloco_id AS bloco_id_key, id_party AS party_id_key, party_name FROM public.form_b_pessoas where region_id = 'Central') TO '/var/lib/share/projects/illovo/ODK Forms/hluvukani-odk-forms/Hluvukani_C_registrar_parcelas/Hluvukani_C_registrar_parcelas-media/Central.csv' DELIMITER ',' NULL AS '' CSV HEADER ENCODING 'latin1';

Copy (select bloco_id AS bloco_id_key, id_party AS party_id_key, party_name FROM public.form_b_pessoas where region_id = 'Norte') TO '/var/lib/share/projects/illovo/ODK Forms/hluvukani-odk-forms/Hluvukani_C_registrar_parcelas/Hluvukani_C_registrar_parcelas-media/Norte.csv' DELIMITER ',' NULL AS '' CSV HEADER ENCODING 'latin1';

Copy (select bloco_id AS bloco_id_key, id_party AS party_id_key, party_name FROM public.form_b_pessoas where region_id = 'Sul') TO '/var/lib/share/projects/illovo/ODK Forms/hluvukani-odk-forms/Hluvukani_C_registrar_parcelas/Hluvukani_C_registrar_parcelas-media/Sul.csv' DELIMITER ',' NULL AS '' CSV HEADER ENCODING 'latin1';

-- the association with parcels is through the parent_uid from form_c_(parcelas) oobase query joins parcels_hluvukani to form_c_parcelas through upn-parcelid and joins form_c_parcelas to form_c_titulars via parentuid-parentuid which links the part 
DROP TABLE public.update_pessoas_nova;

-- after we have updated the table we rebuild the update_novas_pessoas table taking out the authenticated pessoas..

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
COPY public.update_novas_pessoas FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_novas_pessoas.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

-- delete any data already in table_b

DELETE FROM public.update_novas_pessoas
WHERE EXISTS (SELECT 1 FROM public.form_b_pessoas 
WHERE key = public.update_novas_pessoas.parent_uid );
--set the display propertieds of the photos

UPDATE public.update_novas_pessoas 
SET pessoa_foto = '<img src="'||pessoa_foto||'" style="width:256px;height:256px;">',
id_foto = '<img src="'||id_foto||'" style="width:256px;height:256px;">',
pessoa_assin = '<img src="'||pessoa_assin||'" style="width:256px;height:256px;">';