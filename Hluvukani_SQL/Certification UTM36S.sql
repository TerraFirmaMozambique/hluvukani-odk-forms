/* Illovo */ 

DROP TABLE public.normalise_form_d_occ;

CREATE TABLE public.normalise_form_d_occ
(

  parcel_id integer,
  outcome character varying,
  party_id character varying,
  key character varying NOT NULL
)
WITH (
  OIDS=TRUE
);
ALTER TABLE public.normalise_form_d_occ
  OWNER TO postgres;
GRANT ALL ON TABLE public.normalise_form_d_occ TO public;
GRANT ALL ON TABLE public.normalise_form_d_occ TO postgres;



INSERT INTO public.normalise_form_d_occ( parcel_id, outcome, party_id, key)
SELECT parcel_id, outcome, party_id, key
  FROM public.form_d_occ;
  
  
ALTER TABLE normalise_form_d_occ ADD COLUMN id_outcome character varying;

UPDATE normalise_form_d_occ set id_outcome = parcel_id ||'-'|| outcome;
-----

ALTER TABLE normalise_form_d_occ ADD COLUMN id_count integer;

UPDATE normalise_form_d_occ set id_count = count From (Select parcel_id, count FROM (SELECT normalise_form_d_occ.parcel_id, count(parcel_id) OVER (PARTITION BY parcel_id) FROM normalise_form_d_occ) AS a) AS b
where normalise_form_d_occ.parcel_id = b.parcel_id;

ALTER TABLE normalise_form_d_occ ADD COLUMN id_outcome_count integer;

UPDATE normalise_form_d_occ set id_outcome_count = count From (Select id_outcome, count FROM (SELECT normalise_form_d_occ.id_outcome, count(id_outcome) OVER (PARTITION BY id_outcome) FROM normalise_form_d_occ) AS a) AS b
where normalise_form_d_occ.id_outcome = b.id_outcome;

ALTER TABLE normalise_form_d_occ ADD COLUMN desicion character varying;

UPDATE normalise_form_d_occ set desicion = b.desicion FROM (SELECT desicion, key FROM (SELECT id_outcome_count, id_count, outcome, key,
  CASE
    WHEN "id_outcome_count" = "id_count" THEN outcome 
    ELSE 'PROBLEM'
  END 
  AS desicion
FROM normalise_form_d_occ)AS a) AS b
WHERE normalise_form_d_occ.key = b.key;


DELETE FROM public.normalise_form_d_occ a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.normalise_form_d_occ b
                 WHERE  a.key = b.key);
----------------------------------------------------------------------				 
DROP TABLE public.party;

UPDATE form_c_novas_pessoas
SET parcel_id = parcelid FROM 
(SELECT 
  form_c_parcelas.parcelid, 
  form_c_parcelas.key
FROM 
  public.form_c_parcelas) AS a
WHERE form_c_novas_pessoas.key = a.key;

----------------------------------------------------------------------

CREATE TABLE public.party
(
  id character varying, 
  parcel_id integer,
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
  key character varying
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.party   OWNER TO postgres;
GRANT ALL ON TABLE public.party TO public;
GRANT ALL ON TABLE public.party TO postgres;

INSERT INTO public.party(
            id, parcel_id, app, nome, gen, civil, prof, prof_other, nacion, naturalidade, 
            nascyn, nasc, ida, doc, doc_id, doc_local, doc_emi, doc_val, 
            doc_vital, foto, doc_foto, assin, contacto, key)
SELECT form_c_novas_pessoas.id, form_c_novas_pessoas.parcel_id, form_c_novas_pessoas.app, form_c_novas_pessoas.nome, table_genero_pessoa.genero AS gen, form_c_novas_pessoas.civil, form_c_novas_pessoas.prof, form_c_novas_pessoas.prof_other, form_c_novas_pessoas.nacion, form_c_novas_pessoas.naturalidade, form_c_novas_pessoas.nascyn, form_c_novas_pessoas.nasc, form_c_novas_pessoas.ida, table_doc_identificacao.documento AS doc, form_c_novas_pessoas.doc_id, form_c_novas_pessoas.doc_local, form_c_novas_pessoas.doc_emi, form_c_novas_pessoas.doc_val, form_c_novas_pessoas.doc_vital, form_c_novas_pessoas.foto, form_c_novas_pessoas.doc_foto, form_c_novas_pessoas.assin, form_c_novas_pessoas.contacto, form_c_novas_pessoas.id::text||form_c_novas_pessoas.parcel_id::text as key FROM  public.table_genero_pessoa AS table_genero_pessoa RIGHT OUTER JOIN public.table_doc_identificacao AS table_doc_identificacao RIGHT OUTER JOIN public.form_c_novas_pessoas AS form_c_novas_pessoas LEFT OUTER JOIN public.form_c_parcelas AS form_c_parcelas ON form_c_novas_pessoas.parcel_id = form_c_parcelas.parcelid ON table_doc_identificacao.code = form_c_novas_pessoas.doc ON table_genero_pessoa.code = form_c_novas_pessoas.gen
WHERE id::text||parcelid::text NOT IN (SELECT key FROM party);

INSERT INTO public.party(
            id, parcel_id, app, nome, gen, civil, prof, prof_other, nacion, 
            naturalidade, nascyn, nasc, ida, doc, doc_id, doc_local, doc_emi, 
            doc_val, doc_vital, foto, doc_foto, assin, contacto, key)
SELECT * FROM (SELECT form_c_titulares.foundparty AS id, form_c_parcelas.parcelid, form_b_pessoas.pessoa_app, form_b_pessoas.pessoa_nom, table_genero_pessoa.genero, form_b_pessoas.pessoa_civil, form_b_pessoas.pessoa_prof, form_b_pessoas.pessoa_prof_other, form_b_pessoas.pessoa_nacion, form_b_pessoas.pessoa_natural, form_b_pessoas.nasc_y_n, form_b_pessoas.pessoa_nasc, form_b_pessoas.pessoa_ida, table_doc_identificacao.documento, form_b_pessoas.pessoa_id, form_b_pessoas.doc_local, form_b_pessoas.doc_emi, form_b_pessoas.doc_val, form_b_pessoas.doc_vital, form_b_pessoas.pessoa_foto, form_b_pessoas.id_foto, form_b_pessoas.pessoa_assin, form_b_pessoas.contacto, form_c_titulares.foundparty||form_c_parcelas.parcelid::text AS key 
FROM public.table_doc_identificacao AS table_doc_identificacao RIGHT OUTER JOIN public.table_genero_pessoa AS table_genero_pessoa RIGHT OUTER JOIN public.form_b_pessoas AS form_b_pessoas LEFT OUTER JOIN public.form_c_titulares AS form_c_titulares ON form_b_pessoas.id_party = form_c_titulares.foundparty ON table_genero_pessoa.code = form_b_pessoas.pessoa_gen ON table_doc_identificacao.code = form_b_pessoas.pessoa_doc , public.form_c_parcelas AS form_c_parcelas WHERE form_c_titulares.parentuid = form_c_parcelas.inst_id) AS a

WHERE a.key NOT IN (SELECT key FROM party);

DELETE FROM public.party a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.party b
                 WHERE  a.key = b.key);
				 
alter table party add primary key (key);

-----------------------
CREATE TABLE public.udcertification
(
  geom geometry(MultiPolygon,32736),
  upn integer NOT NULL,
  district character varying,
  regiao character varying,
  posto character varying,
  bloco character varying,
  party_type character varying,
  area double precision,
  x_min double precision,
  x_max double precision,
  y_min double precision,
  y_max double precision
)
WITH (
  OIDS=TRUE
);
ALTER TABLE public.udcertification
  OWNER TO postgres;
GRANT ALL ON TABLE public.udcertification TO public;
GRANT ALL ON TABLE public.udcertification TO postgres;


INSERT INTO public.udcertification(
            geom, upn, district, regiao, posto, bloco, party_type, area, x_min, 
            x_max, y_min, y_max)
SELECT geom, upn, district, regiao, posto_admin, bloco, party_type, area, x_min, 
            x_max, y_min, y_max FROM (SELECT ST_Transform( parcels_hluvukani.geom, 32736 ) AS geom, parcels_hluvukani.upn, parcels_hluvukani.district, form_c_parcelas.regionid AS regiao, parcels_hluvukani.posto_admin, table_bloco.bloco, table_party_type.party_type, parcels_hluvukani.area_h AS area, parcels_hluvukani.min_x AS x_min, parcels_hluvukani.max_x AS x_max, parcels_hluvukani.min_y AS y_min, parcels_hluvukani.max_y AS y_max 
FROM public.parcels_hluvukani AS parcels_hluvukani, 
public.normalise_form_d_occ AS normalise_form_d_occ, 
public.form_c_parcelas AS form_c_parcelas, 
public.table_bloco AS table_bloco, 
public.table_party_type AS table_party_type 
WHERE parcels_hluvukani.upn = normalise_form_d_occ.parcel_id AND 
form_c_parcelas.parcelid = parcels_hluvukani.upn AND 
table_bloco.code = form_c_parcelas.blocoid AND 
table_party_type.code = form_c_parcelas.partytype AND 
normalise_form_d_occ.desicion = 'certify' AND 
(form_c_parcelas.partytype = 'sing'  or 
form_c_parcelas.partytype = 'cotitular')  
ORDER BY parcels_hluvukani.upn ASC) AS a;

DELETE FROM public.udcertification a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.udcertification b
                 WHERE  a.upn = b.upn);

DELETE from public.udcertification
WHERE EXISTS (SELECT 1 FROM public.certification 
WHERE upn = public.udcertification.upn);				 


ALTER TABLE udcertification ADD COLUMN produced date;
UPDATE udcertification SET produced = 'now';

INSERT INTO public.certification(
            geom, upn, district, regiao, posto_admin, bloco, party_type, area, x_min, 
            x_max, y_min, y_max, produced)
SELECT geom, upn, district, regiao, posto, bloco, party_type, area, x_min, 
       x_max, y_min, y_max, produced
  FROM public.udcertification;

DROP TABLE public.udcertification;

UPDATE certification
set area =  ST_Area FROM (SELECT ST_Area(geom), upn  FROM certification) AS a
WHERE certification.upn = a.upn;

UPDATE certification
set x_min = ST_XMin FROM (SELECT ST_XMin(geom), upn from certification)as a
where certification.upn = a.upn;

UPDATE certification
set y_min = ST_YMin FROM (SELECT ST_YMin(geom), upn from certification)as a
where certification.upn = a.upn;


UPDATE certification
set y_max = ST_YMax FROM (SELECT ST_YMax(geom), upn from certification)as a
where certification.upn = a.upn;

UPDATE certification
set x_max = ST_XMax FROM (SELECT ST_XMax(geom), upn from certification)as a
where certification.upn = a.upn;

---------------end
