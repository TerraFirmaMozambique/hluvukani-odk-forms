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
  
/*  ----------------------------------------
  add column 
  add column count_parcel
  add column count_outcome
  ----------------------------------------*/
  
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

-------- drop and make new each time
