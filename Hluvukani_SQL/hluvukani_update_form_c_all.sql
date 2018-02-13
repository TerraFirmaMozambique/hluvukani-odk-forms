CREATE TABLE public.update_form_c_parcelas
(
    geom geometry(Point,0),
    subdate timestamp without time zone,
    start timestamp without time zone,
    myformname character varying,
    intronote character varying,
    tecnome character varying,
    data date,
    regionid character varying,
    blocoid character varying,
    parcelid integer,
    ocup character varying,
    ocupoutro character varying,
    zexcl character varying,
    partexcl character varying,
    tipoexcl character varying,
    conf character varying,
    tipoconf character varying,
    descconf character varying,
    usecat character varying,
    usetipo character varying,
    useprin character varying,
    useother character varying,
    partytype character varying,
    repmenor character varying,
    addpartynumber integer,
    titularescount integer,
    titulares character varying,
    regpartyyn character varying,
    regnewpartynumber character varying,
    novaspessoascount integer,
    novaspessoas character varying,
    testemnum integer,
    testemunhas_count integer,
    testemunhas character varying,
    latitude double precision,
    longitude double precision,
    altitude double precision,
    accuracy double precision,
    limitesyn character varying,
    pontos character varying,
    endnote character varying,
    reciboimage character varying,
    finish timestamp without time zone,
    inst_id character varying,
    inst_name character varying,
    key character varying  NOT NULL
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

ALTER TABLE public.update_form_c_parcelas  OWNER to postgres;


COPY public.update_form_c_parcelas FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_parcelas.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

DELETE from public.update_form_c_parcelas
WHERE EXISTS (SELECT 1 FROM public.table_c_duplicates 
WHERE key = public.update_form_c_parcelas.key);

DELETE FROM public.update_form_c_parcelas a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_c_parcelas b
                 WHERE  a.key = b.key);

DELETE from public.update_form_c_parcelas
WHERE EXISTS (SELECT 1 FROM public.form_c_parcelas 
WHERE key = public.update_form_c_parcelas.key);

UPDATE public.update_form_c_parcelas 
SET reciboimage = '<img src="'||reciboimage||'" style="width:256px;height:256px;">';

SELECT UpdateGeometrySRID('form_c_parcelas','geom',0);

INSERT INTO public.form_c_parcelas(
            geom, subdate, start, myformname, intronote, tecnome, data, regionid, 
            blocoid, parcelid, ocup, ocupoutro, zexcl, partexcl, tipoexcl, 
            conf, tipoconf, descconf, usecat, usetipo, useprin, useother, 
            partytype, repmenor, addpartynumber, titularescount, titulares, 
            regpartyyn, regnewpartynumber, novaspessoascount, novaspessoas, 
            testemnum, testemunhas_count, testemunhas, latitude, longitude, 
            altitude, accuracy, limitesyn, pontos, endnote, reciboimage, 
            finish, inst_id, inst_name, key)
SELECT geom, subdate, start, myformname, intronote, tecnome, data, regionid, 
       blocoid, parcelid, ocup, ocupoutro, zexcl, partexcl, tipoexcl, 
       conf, tipoconf, descconf, usecat, usetipo, useprin, useother, 
       partytype, repmenor, addpartynumber, titularescount, titulares, 
       regpartyyn, regnewpartynumber, novaspessoascount, novaspessoas, 
       testemnum, testemunhas_count, testemunhas, latitude, longitude, 
       altitude, accuracy, limitesyn, pontos, endnote, reciboimage, 
       finish, inst_id, inst_name, key
  FROM public.update_form_c_parcelas;	

SELECT UpdateGeometrySRID('form_c_parcelas','geom',4326);  

DROP TABLE public.update_form_c_parcelas;

-----------------------------------------------------

CREATE TABLE public.update_form_c_titulares
(
  
  parentuid character varying NOT NULL,
  searchtext character varying,
  foundparty character varying,
  titulares character varying
  
)
WITH (
  OIDS=TRUE
);
ALTER TABLE public.update_form_c_titulares
  OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_c_titulares TO postgres;
GRANT ALL ON TABLE public.update_form_c_titulares TO public;


COPY public.update_form_c_titulares FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_titulars.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';


DELETE from public.update_form_c_titulares
WHERE EXISTS (SELECT 1 FROM public.table_c_duplicates 
WHERE key = public.update_form_c_titulares.parentuid);

DELETE FROM public.update_form_c_titulares a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_c_titulares b
                 WHERE  a.titulares = b.titulares);

DELETE from public.update_form_c_titulares
WHERE EXISTS (SELECT 1 FROM public.form_c_titulares 
WHERE titulares = public.update_form_c_titulares.titulares);


INSERT INTO public.form_c_titulares( parentuid, searchtext, foundparty, titulares)
SELECT parentuid, searchtext, foundparty, titulares
FROM public.update_form_c_titulares;

DROP TABLE public.update_form_c_titulares;

--------------------------------

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
ALTER TABLE public.update_form_c_novas_pessoas OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_c_novas_pessoas TO public;
GRANT ALL ON TABLE public.update_form_c_novas_pessoas TO postgres;

COPY public.update_form_c_novas_pessoas FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_novas_pessoas.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';


DELETE from public.update_form_c_novas_pessoas
WHERE EXISTS (SELECT 1 FROM public.table_c_duplicates 
WHERE key = public.update_form_c_novas_pessoas.key);

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
  
-------------------------------------------------

CREATE TABLE public.update_form_c_testemunhas
(
  parentuid character varying NOT NULL,
  testemnome character varying,
  testemtype character varying,
  testemassin character varying
)
WITH (
  OIDS=TRUE
);
ALTER TABLE public.update_form_c_testemunhas
  OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_c_testemunhas TO postgres;
GRANT ALL ON TABLE public.update_form_c_testemunhas TO public;

COPY public.update_form_c_testemunhas FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_testemunhas.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

DELETE from public.update_form_c_testemunhas
WHERE EXISTS (SELECT 1 FROM public.table_c_duplicates 
WHERE key = public.update_form_c_testemunhas.parentuid);


DELETE FROM public.update_form_c_testemunhas a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_c_testemunhas b
                 WHERE  a.testemassin = b.testemassin);

DELETE from public.update_form_c_testemunhas
WHERE EXISTS (SELECT 1 FROM public.form_c_testemunhas 
WHERE testemassin = public.update_form_c_testemunhas.testemassin);

INSERT INTO public.form_c_testemunhas( parentuid, testemnome, testemtype, testemassin)
SELECT  parentuid, testemnome, testemtype, testemassin
FROM public.update_form_c_testemunhas;


DROP TABLE public.update_form_c_testemunhas;
  
------------------------------------

CREATE TABLE public.update_form_c_pontos
(
  geom geometry(Point,0),
  latitude double precision,
  longitude double precision,
  altitude double precision,
  accuracy double precision,
  upngpslimit character varying,
  parentuid character varying NOT NULL,
  key character varying NOT NULL
)
WITH (
  OIDS=TRUE
);
ALTER TABLE public.update_form_c_pontos OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_c_pontos TO public;
GRANT ALL ON TABLE public.update_form_c_pontos TO postgres;


COPY public.update_form_c_pontos FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_pontos.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';


DELETE from public.update_form_c_pontos
WHERE EXISTS (SELECT 1 FROM public.table_c_duplicates 
WHERE key = public.update_form_c_pontos.parentuid);

DELETE FROM public.update_form_c_pontos a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_c_pontos b
                 WHERE  a.key = b.key);

DELETE from public.update_form_c_pontos
WHERE EXISTS (SELECT 1 FROM public.form_c_pontos 
WHERE key = public.update_form_c_pontos.key);


SELECT UpdateGeometrySRID('form_c_pontos','geom',0);

INSERT INTO public.form_c_pontos(
            geom, latitude, longitude, altitude, accuracy, upngpslimit, parentuid, 
            key)
SELECT geom, latitude, longitude, altitude, accuracy, upngpslimit, parentuid, 
       key
  FROM public.update_form_c_pontos;			


SELECT UpdateGeometrySRID('form_c_pontos','geom',4326);


DROP TABLE public.update_form_c_pontos;
































