SELECT UpdateGeometrySRID('form_a_encontros_sensibilizacao','geom',0);

CREATE TABLE public.update_form_a_encontros_sensibilizacao
(
geom geometry(Point,0),
sub_date timestamp without time zone,
start timestamp without time zone,
form_name character varying,
intronote character varying,
tec_nome character varying,
data date,
region_id character varying,
bloco_id character varying,
num_m integer,
num_h integer,
govp character varying,
govn character varying,
govo character varying,
encont character varying,
encontalt character varying,
tema character varying,
temaalt character varying,
parth character varying,
partm character varying,
partj character varying,
encontfoto character varying,
latitude double precision,
longitude double precision,
altitude double precision,
accuracy double precision,
obs  character varying,
finish timestamp without time zone,
inst_id character varying,
inst_name character varying,
key character varying
)
WITH (
    OIDS = TRUE
);
ALTER TABLE public.update_form_a_encontros_sensibilizacao  OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_a_encontros_sensibilizacao TO postgres;

COPY public.update_form_a_encontros_sensibilizacao FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_A_encontros_sensibilizacao.csv'  USING DELIMITERS ',' WITH NULL AS '' CSV HEADER ENCODING 'latin1';

DELETE FROM public.update_form_a_encontros_sensibilizacao a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_a_encontros_sensibilizacao b
                 WHERE  a.key = b.key);


DELETE from public.update_form_a_encontros_sensibilizacao
WHERE EXISTS (SELECT 1 FROM public.form_a_encontros_sensibilizacao 
WHERE key = public.update_form_a_encontros_sensibilizacao.key);

INSERT INTO public.form_a_encontros_sensibilizacao(
            geom, sub_date, start, form_name, intronote, tec_nome, data, 
            region_id, bloco_id, num_m, num_h, govp, govn, govo, encont, 
            encontalt, tema, temaalt, parth, partm, partj, encontfoto, latitude, 
            longitude, altitude, accuracy, obs, finish, inst_id, inst_name, 
            key)
SELECT geom, sub_date, start, form_name, intronote, tec_nome, data, 
       region_id, bloco_id, num_m, num_h, govp, govn, govo, encont, 
       encontalt, tema, temaalt, parth, partm, partj, encontfoto, latitude, 
       longitude, altitude, accuracy, obs, finish, inst_id, inst_name, 
       key
FROM public.update_form_a_encontros_sensibilizacao;

SELECT UpdateGeometrySRID('form_a_encontros_sensibilizacao','geom',4326);

DROP TABLE public.update_form_a_encontros_sensibilizacao;