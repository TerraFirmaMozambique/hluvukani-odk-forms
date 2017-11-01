SELECT 
  to_char(parcel_association.parcelid, '000000'),
INITCAP(form_b_pessoas.pessoa_nom||' '||form_b_pessoas.pessoa_app) AS nome,  
  form_b_pessoas.pessoa_app, 
  to_char(form_b_pessoas.pessoa_nasc, 'dd/MM/yyyy'),
  table_doc_identificacao.documento, 
  form_b_pessoas.pessoa_id,
  to_char(form_b_pessoas.doc_emi, 'dd/MM/yyyy'),
  to_char(form_b_pessoas.doc_val, 'dd/MM/yyyy'),
  INITCAP(form_b_pessoas.doc_local), 
  INITCAP(form_b_pessoas.pessoa_natural), 
  form_b_pessoas.contacto 
FROM 
  public.parcel_association, 
  public.form_b_pessoas, 
  public.table_doc_identificacao
WHERE 
  parcel_association.id_party = form_b_pessoas.id_party AND
  form_b_pessoas.pessoa_doc = table_doc_identificacao.code
ORDER BY
  parcel_association.parcelid ASC;
