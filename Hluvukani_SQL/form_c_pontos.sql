CREATE TABLE public.update_form_c_pontos
(
    
    geom geometry(Point, 0),
    latitude double precision,
    longitude double precision,
    altitude double precision,
    accuracy double precision,
    upngpslimit character varying COLLATE pg_catalog."default",
	parentuid character varying COLLATE pg_catalog."default" NOT NULL,
    key character varying COLLATE pg_catalog."default"
    )
    WITH ( OIDS=FALSE );
	
	GRANT ALL ON TABLE public.update_form_c_pontos TO postgres;
	
	COPY public.update_form_c_pontos FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_C_pontos.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER;
	
	DELETE FROM public.update_form_c_pontos a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_c_pontos b
                 WHERE  a.key = b.key);
	
	DELETE FROM public.update_form_c_pontos
WHERE EXISTS (SELECT 1 FROM public.form_c_pontos 
WHERE key = public.update_form_c_pontos.key );


SELECT UpdateGeometrySRID('form_c_pontos','geom',0);

INSERT INTO public.form_c_pontos ( geom, latitude, longitude, altitude, accuracy, upngpslimit, parentuid, key)
SELECT  geom, latitude, longitude, altitude, accuracy, upngpslimit, parentuid, key
FROM public.update_form_c_pontos;

SELECT UpdateGeometrySRID('form_c_pontos','geom',4326);

DROP TABLE public.update_form_c_pontos;

