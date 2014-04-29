# SQL statements


- Select all the DDB_G IDS and protein alternative names:

```
SELECT dbxref.accession gene_id, wm_concat(syn.name) gsyn
FROM cgm_chado.feature gene
JOIN dbxref on dbxref.dbxref_id=gene.dbxref_id
LEFT JOIN cgm_chado.feature_synonym fsyn on gene.feature_id=fsyn.feature_id
LEFT JOIN cgm_chado.synonym_ syn on syn.synonym_id=fsyn.SYNONYM_ID
WHERE dbxref.accession LIKE 'DDB_G%'
GROUP BY dbxref.ACCESSION
```

- Select GENE_NAME and DDB_G_ID, given the gene name

```
SELECT gene.name AS GENE_NAME, dbx.accession AS DDB_G_ID
FROM cgm_chado.feature gene
INNER JOIN cgm_chado.dbxref dbx ON gene.dbxref_id = dbx.dbxref_id
WHERE gene.name = 'fam21'
```

- Gene name, primary feature id, and the gene product

```
SELECT g.gene_name, g.primary_feature_dictybaseid, gp.gene_product
FROM cgm_ddb.gene_product gp
INNER JOIN cgm_ddb.locus_gp lgp 	ON 		lgp.gene_product_no = gp.gene_product_no
INNER JOIN cgm_chado.v_gene_dictybaseid g      ON 	lgp.locus_no = g.gene_feature_id
ORDER BY gp.gene_product
```

- The gene name and DDB_G_ID

```
SELECT g.name  AS GENE_NAME, dx.accession AS DDB_G_ID
FROM cgm_chado.v_gene_features g
INNER JOIN cgm_chado.dbxref dx           ON g.dbxref_id = dx.dbxref_id
INNER JOIN cgm_chado.organism o          ON o.organism_id    = g.organism_id
INNER JOIN cgm_chado.feature f 			ON f.dbxref_id = g.dbxref_id
WHERE o.common_name = 'dicty'
```

- 1 and 2 together!

```
SELECT dx.accession AS DDB_G_ID, d.gene_name, d.primary_feature_dictybaseid, gp.gene_product
FROM cgm_ddb.gene_product gp
INNER JOIN cgm_ddb.locus_gp lgp 	ON 		lgp.gene_product_no = gp.gene_product_no
INNER JOIN cgm_chado.v_gene_dictybaseid d      ON 	lgp.locus_no = d.gene_feature_id
INNER JOIN cgm_chado.v_gene_features g 		ON   g.feature_id = d.gene_feature_id
INNER JOIN cgm_chado.dbxref dx              ON g.dbxref_id = dx.dbxref_id
INNER JOIN cgm_chado.organism o             ON o.organism_id    = g.organism_id
INNER JOIN cgm_chado.feature f 			    ON f.dbxref_id = g.dbxref_id
WHERE o.common_name = 'dicty'
ORDER BY dx.accession, gp.gene_product
```

- Mapping DDB_G_ID to UNIPROT id, entire list:

```
SELECT gxref.accession geneid, dbxref.accession uniprot
FROM dbxref
	JOIN db ON db.db_id = dbxref.db_id
	JOIN feature_dbxref fxref ON fxref.dbxref_id = dbxref.dbxref_id
	JOIN feature polypeptide ON polypeptide.feature_id = fxref.feature_id
	JOIN feature_relationship frel ON polypeptide.feature_id = frel.subject_id
	JOIN feature transcript ON transcript.feature_id = frel.object_id
	JOIN feature_relationship frel2 ON frel2.subject_id = transcript.feature_id
	JOIN feature gene ON frel2.object_id = gene.feature_id
	JOIN cvterm ptype ON ptype.cvterm_id = polypeptide.type_id
	JOIN cvterm mtype ON mtype.cvterm_id = transcript.type_id
	JOIN cvterm gtype ON gtype.cvterm_id = gene.type_id
	JOIN dbxref gxref ON gene.dbxref_id = gxref.dbxref_id
WHERE 
	ptype.name = 'polypeptide'
	AND	mtype.name = 'mRNA'
	AND	gtype.name = 'gene'
	AND	db.name = 'DB:SwissProt'
```

- Split genes

```
WITH split_replaced AS( SELECT dbxref.accession acc 
	  FROM cgm_chado.featureprop fprop 
	  JOIN cgm_chado.cvterm on cvterm.cvterm_id=fprop.type_id 
	  JOIN cgm_chado.feature on feature.feature_id=fprop.feature_id 
	  JOIN cgm_chado.cvterm ftype on ftype.cvterm_id=feature.type_id 
	  JOIN cgm_chado.dbxref on feature.dbxref_id=dbxref.dbxref_id 
	 WHERE ftype.name = 'gene' 
	   AND cvterm.name = 'replaced by' 
	   AND feature.is_deleted = 1 
	   AND feature.uniquename like 'DDB_G%'
	 GROUP BY dbxref.accession
	HAVING count(to_char(fprop.value)) > 1  )
SELECT to_char(fprop.value) split_id 
  FROM cgm_chado.feature 
  JOIN cgm_chado.featureprop fprop on fprop.feature_id=feature.feature_id 
  JOIN cgm_chado.dbxref on dbxref.dbxref_id=feature.dbxref_id 
  JOIN cgm_chado.cvterm on cvterm.cvterm_id=fprop.type_id 
  JOIN split_replaced on split_replaced.acc=dbxref.accession 
 WHERE cvterm.name = 'replaced by' 
   AND fprop.value like 'DDB_G%'
```

