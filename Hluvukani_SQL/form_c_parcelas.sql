CREATE TABLE public.update_form_c_parcelas
(
    geom geometry(Point,0),
    subdate timestamp without time zone,
    start timestamp without time zone,
    myformname character varying COLLATE pg_catalog."default",
    intronote character varying COLLATE pg_catalog."default",
    tecnome character varying COLLATE pg_catalog."default",
    data date,
    regionid character varying COLLATE pg_catalog."default",
    blocoid character varying COLLATE pg_catalog."default",
    parcelid integer,
    ocup character varying COLLATE pg_catalog."default",
    ocupoutro character varying COLLATE pg_catalog."default",
    zexcl character varying COLLATE pg_catalog."default",
    partexcl character varying COLLATE pg_catalog."default",
    tipoexcl character varying COLLATE pg_catalog."default",
    conf character varying COLLATE pg_catalog."default",
    tipoconf character varying COLLATE pg_catalog."default",
    descconf character varying COLLATE pg_catalog."default",
    usecat character varying COLLATE pg_catalog."default",
    usetipo character varying COLLATE pg_catalog."default",
    useprin character varying COLLATE pg_catalog."default",
    useother character varying COLLATE pg_catalog."default",
    partytype character varying COLLATE pg_catalog."default",
    repmenor character varying COLLATE pg_catalog."default",
    addpartynumber integer,
    titularescount integer,
    titulares character varying COLLATE pg_catalog."default",
    regpartyyn character varying COLLATE pg_catalog."default",
    regnewpartynumber character varying COLLATE pg_catalog."default",
    novaspessoascount integer,
    novaspessoas character varying COLLATE pg_catalog."default",
    testemnum integer,
    testemunhas_count integer,
    testemunhas character varying COLLATE pg_catalog."default",
    latitude double precision,
    longitude double precision,
    altitude double precision,
    accuracy double precision,
    limitesyn character varying COLLATE pg_catalog."default",
    pontos character varying COLLATE pg_catalog."default",
    endnote character varying COLLATE pg_catalog."default",
    reciboimage character varying COLLATE pg_catalog."default",
    finish timestamp without time zone,
    inst_id character varying COLLATE pg_catalog."default",
    inst_name character varying COLLATE pg_catalog."default",
    key character varying COLLATE pg_catalog."default" NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.update_form_c_parcelas  OWNER to postgres;


COPY public.update_form_c_pontos FROM '/var/lib/share/projects/illovo/working_folder/Hluvukani_C_parcelas.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER;



DELETE FROM public.update_form_c_parcelas a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_c_parcelas b
                 WHERE  a.key = b.key);
				 

DELETE from public.update_form_c_parcelas
WHERE EXISTS (SELECT 1 FROM public.form_c_parcelas
WHERE key = public.update_form_c_parcelas.key );


SELECT UpdateGeometrySRID('form_c_parcelas','geom',0);

INSERT INTO public.form_c_parcelas
SELECT * FROM public.update_form_c_parcelas;

SELECT UpdateGeometrySRID('form_c_parcelas','geom',0);


DROP TABLE public.update_form_c_parcelas;









