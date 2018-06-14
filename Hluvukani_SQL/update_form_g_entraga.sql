
CREATE TABLE public.update_form_g_entraga
(
metaversion integer,
metauiversion character varying,
meta_subdate timestamp without time zone,
meta_complete character varying,
meta_date_complete timestamp without time zone,
begin timestamp without time zone,
form_name character varying,
intro_note character varying,
tec_nome character varying,
date date,
upn integer,
upn_confirm integer,
resultado character varying,
preloadfail character varying,
preloadnote character varying,
id_confirm character varying,
noidnote character varying,
fotoexample character varying,
pessoa_foto character varying,
id_foto_1 character varying,
id_foto_2 character varying,
pessoa_assin character varying,
recibo_image character varying,
finish timestamp without time zone,
inst_id character varying,
inst_name character varying,
meta_id character varying
)
WITH (
  OIDS=TRUE
);
ALTER TABLE public.update_form_g_entraga  OWNER TO postgres;
GRANT ALL ON TABLE public.update_form_g_entraga TO postgres;
GRANT ALL ON TABLE public.update_form_g_entraga TO public;

COPY public.update_form_g_entraga FROM '/var/lib/share/projects/illovo/dbupdate/Hluvukani_G_entraga.csv'  USING DELIMITERS ',' NULL AS '' CSV HEADER ENCODING 'latin1';

DELETE FROM public.update_form_g_entraga a
WHERE a.ctid <> (SELECT min(b.ctid)
                 FROM   public.update_form_g_entraga b
                 WHERE  a.meta_id = b.meta_id);
				 
DELETE from public.update_form_g_entraga
WHERE EXISTS (SELECT 1 FROM public.form_g_entraga 
WHERE meta_id = public.update_form_g_entraga.meta_id);


UPDATE public.update_form_g_entraga SET pessoa_foto = '<img src="'||pessoa_foto||'" style="width:1024px;height:1024px;">';
UPDATE public.update_form_g_entraga SET id_foto_1 = '<img src="'||id_foto_1||'" style="width:1024px;height:1024px;">';
UPDATE public.update_form_g_entraga SET id_foto_2 = '<img src="'||id_foto_2||'" style="width:1024px;height:1024px;">';
UPDATE public.update_form_g_entraga SET pessoa_assin = '<img src="'||pessoa_assin||'" style="width:1024px;height:1024px;">';
UPDATE public.update_form_g_entraga SET recibo_image = '<img src="'||recibo_image||'" style="width:1024px;height:1024px;">';

INSERT INTO public.form_g_entraga(
            metaversion, metauiversion, meta_subdate, meta_complete, meta_date_complete, 
            begin, form_name, intro_note, tec_nome, date, upn, upn_confirm, 
            resultado, preloadfail, preloadnote, id_confirm, noidnote, fotoexample, 
            pessoa_foto, id_foto_1, id_foto_2, pessoa_assin, recibo_image, 
            finish, inst_id, inst_name, meta_id)
SELECT metaversion, metauiversion, meta_subdate, meta_complete, meta_date_complete, 
       begin, form_name, intro_note, tec_nome, date, upn, upn_confirm, 
       resultado, preloadfail, preloadnote, id_confirm, noidnote, fotoexample, 
       pessoa_foto, id_foto_1, id_foto_2, pessoa_assin, recibo_image, 
       finish, inst_id, inst_name, meta_id
FROM public.update_form_g_entraga;
  
  
DROP TABLE public.update_form_g_entraga;