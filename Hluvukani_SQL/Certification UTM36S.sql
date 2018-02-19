
/*DROP TABLE public.certification;

CREATE TABLE public.certification
(
  geom geometry(MultiPolygon),
  upn integer NOT NULL,
  district character varying,
  regiao character varying,
  bloco character varying,
  party_type character varying,
  area double precision,
  x_min double precision,
  x_max double precision,
  y_min double precision,
  y_max double precision,
  CONSTRAINT certification_pkey PRIMARY KEY (upn)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.certification
  OWNER TO postgres;
GRANT ALL ON TABLE public.certification TO public;
GRANT ALL ON TABLE public.certification TO postgres;


*/

INSERT INTO public.certification(
            geom, upn, area, x_min, x_max, y_min, y_max,  district, regiao, bloco, party_type)
select * FROM (SELECT ST_Transform(parcels_hluvukani.geom, 32736) AS utm_geom, parcels_hluvukani.upn, parcels_hluvukani.area_h, parcels_hluvukani.min_x, parcels_hluvukani.max_x, parcels_hluvukani.min_y, parcels_hluvukani.max_y, parcels_hluvukani.district, table_regiao.regiao, table_bloco.bloco, table_party_type.party_type FROM  public.table_party_type AS table_party_type RIGHT OUTER JOIN public.table_bloco AS table_bloco RIGHT OUTER JOIN public.table_regiao AS table_regiao RIGHT OUTER JOIN public.form_c_parcelas AS form_c_parcelas ON table_regiao.code = form_c_parcelas.regionid ON table_bloco.code = form_c_parcelas.blocoid ON table_party_type.code = form_c_parcelas.partytype , public.normalise_form_d_occ AS normalise_form_d_occ, public.parcels_hluvukani AS parcels_hluvukani WHERE normalise_form_d_occ.parcel_id = parcels_hluvukani.upn AND form_c_parcelas.parcelid = parcels_hluvukani.upn AND normalise_form_d_occ.desicion = 'certify' ORDER BY parcels_hluvukani.upn ASC, parcels_hluvukani.district ASC, table_regiao.regiao ASC, table_bloco.bloco ASC)as a
WHERE a.upn NOT IN (SELECT upn FROM certification);


-- SELECT UpdateGeometrySRID('certification','geom',32736);

UPDATE certification
set area =  ST_Area FROM (SELECT ST_Area(geom), upn  FROM certification) AS a
WHERE certification.upn = a.upn

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



