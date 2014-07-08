# SQL statements

- (wrong) SQL to get the protein coding genes. Problems:
	* it is not a unique list: there are duplications (solve with DISTINCT)
	* There are 74 extra genes that do not appear in the ``gp2protein`` file
	
```
SELECT DISTINCT dbxref.accession gene_id, gene.feature_id, gene.name
FROM cgm_chado.feature gene
JOIN organism ON organism.organism_id=gene.organism_id
JOIN dbxref on dbxref.dbxref_id=gene.dbxref_id
JOIN cgm_chado.cvterm gtype on gtype.cvterm_id=gene.type_id
JOIN cgm_chado.feature_relationship frel ON frel.object_id=gene.feature_id
JOIN cgm_chado.feature mrna ON frel.subject_id=mrna.feature_id
JOIN cgm_chado.cvterm mtype ON mtype.cvterm_id=mrna.type_id
WHERE gtype.name='gene' 
        AND mtype.name='mRNA' 
        AND organism.common_name = 'dicty' 
        AND gene.is_deleted = 0 
        AND gene.name NOT LIKE '%\_ps%' ESCAPE '\'
```

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

- Mapping DDB_G_ID to UNIPROT id (this is an incomplete, not accurate search. Go to the next one)

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

- Mapping DDB_G_ID to Uniprot id, but this time the gene model and chado model is taken into account, which means that if the gene has been curated. Even though there is a little problem with this SQL: it does not select all the protein coding genes than the gp2protein file contains. that files has an additional 54 proteins that belongs to the transposable elements.

```
SELECT gxref.accession geneid, dbxref.accession uniprot
FROM dbxref
    JOIN db ON db.db_id = dbxref.db_id
    JOIN feature_dbxref fxref ON fxref.dbxref_id = dbxref.dbxref_id
    JOIN feature polypeptide ON polypeptide.feature_id = fxref.feature_id
    JOIN feature_relationship frel ON polypeptide.feature_id = frel.subject_id
    JOIN feature transcript ON transcript.feature_id = frel.object_id
    JOIN feature_dbxref fxref2 ON fxref2.feature_id = transcript.feature_id
    JOIN dbxref dbxref2 ON fxref2.dbxref_id = dbxref2.dbxref_id
    JOIN db db2 ON db2.db_id = dbxref2.db_id
    JOIN feature_relationship frel2 ON frel2.subject_id = transcript.feature_id
    JOIN feature gene ON frel2.object_id = gene.feature_id
    JOIN cvterm ptype ON ptype.cvterm_id = polypeptide.type_id
    JOIN cvterm mtype ON mtype.cvterm_id = transcript.type_id
    JOIN cvterm gtype ON gtype.cvterm_id = gene.type_id
    JOIN dbxref gxref ON gene.dbxref_id = gxref.dbxref_id
WHERE 
    ptype.name = 'polypeptide'
    AND mtype.name = 'mRNA'
    AND gtype.name = 'gene'
    AND db2.name = 'GFF_source'
    AND db.name = 'DB:SwissProt'
    AND dbxref2.accession = 'dictyBase Curator'
    AND transcript.is_deleted = 0
```

- Get for a gene name the ``GFF source`` (i.e., if it's from the sequencing center or from the curator).

```
SELECT gxref.accession, gene.uniquename, transcript.uniquename, dbxref.accession, db.name
FROM feature gene
JOIN feature_relationship frel ON gene.feature_id = frel.object_id
JOIN feature transcript ON frel.subject_id = transcript.feature_id
JOIN cvterm ON cvterm.cvterm_id = transcript.type_id
JOIN feature_dbxref fxref ON fxref.feature_id = transcript.feature_id
JOIN dbxref ON dbxref.dbxref_id = fxref.dbxref_id
JOIN db ON db.db_id = dbxref.db_id
JOIN dbxref gxref ON gene.dbxref_id = gxref.dbxref_id
WHERE gene.name = 'sadA'
AND cvterm.name = 'mRNA'
AND db.name = 'GFF_source'
```

```
SELECT gxref.accession, gene.uniquename, transcript.uniquename, dbxref.accession, db.name, transcript.IS_DELETED
FROM feature gene
JOIN feature_relationship frel ON gene.feature_id = frel.object_id
JOIN feature transcript ON frel.subject_id = transcript.feature_id
JOIN cvterm ON cvterm.cvterm_id = transcript.type_id
JOIN feature_dbxref fxref ON fxref.feature_id = transcript.feature_id
JOIN dbxref ON dbxref.dbxref_id = fxref.dbxref_id
JOIN db ON db.db_id = dbxref.db_id
JOIN dbxref gxref ON gene.dbxref_id = gxref.dbxref_id
WHERE cvterm.name = 'mRNA'
AND db.name = 'GFF_source'
AND gxref.accession = 'DDB_G0290109'
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

