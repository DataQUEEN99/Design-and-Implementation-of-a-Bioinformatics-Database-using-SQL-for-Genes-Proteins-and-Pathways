GENES TABLE
CREATE TABLE genes (
    gene_id SERIAL PRIMARY KEY,
    gene_name VARCHAR(50),
    organism VARCHAR(50),
    sequence TEXT,
    length INT
);
--PROTEIN TABLE
CREATE TABLE proteins (
    protein_id SERIAL PRIMARY KEY,
    protein_name VARCHAR(50),
    gene_id INT REFERENCES genes(gene_id),
    sequence TEXT,
    length INT
);

--KEGG PATHWAYS 
CREATE TABLE pathways (
    pathway_id SERIAL PRIMARY KEY,
    pathway_name VARCHAR(100),
    kegg_id VARCHAR(20)
);


--GENE PATHWAY MAPPINGS
CREATE TABLE gene_pathway (
    gene_id INT REFERENCES genes(gene_id),
    pathway_id INT REFERENCES pathways(pathway_id),
    PRIMARY KEY (gene_id, pathway_id)
);

--GO ANNOTATION TABLE
CREATE TABLE go_annotations (
    go_id SERIAL PRIMARY KEY,
    gene_id INT REFERENCES genes(gene_id),
    go_term VARCHAR(200),
    go_category VARCHAR(50)  
);

--INSERT SAMPLE DATA
-- Genes
INSERT INTO genes (gene_name, organism, sequence, length)
VALUES 
('BRCA1', 'Homo sapiens', 'ATCGATCGATCG...', 1200),
('TP53', 'Mus musculus', 'ATGCGTACGTA...', 950),
('MYC', 'Homo sapiens', 'ATATCGCGTATCG...', 1500);

-- Proteins
INSERT INTO proteins (protein_name, gene_id, sequence, length)
VALUES
('BRCA1_protein', 1, 'MTEYKLVVVGG...', 180),
('TP53_protein', 2, 'AGGHKLVVV...', 95),
('MYC_protein', 3, 'MTDGHVVCC...', 120);

-- Pathways
INSERT INTO pathways (pathway_name, kegg_id)
VALUES
('DNA repair', 'hsa03410'),
('Cell cycle', 'hsa04110');

-- Gene-Pathway Mapping
INSERT INTO gene_pathway (gene_id, pathway_id) VALUES (1, 1); -- BRCA1 in DNA repair
INSERT INTO gene_pathway (gene_id, pathway_id) VALUES (3, 2); -- MYC in Cell cycle

-- GO Annotations
INSERT INTO go_annotations (gene_id, go_term, go_category)
VALUES
(1, 'DNA binding', 'Molecular Function'),
(2, 'Apoptotic process', 'Biological Process'),
(3, 'Regulation of transcription', 'Biological Process');

--USEFUL BIOINFORMATICS QUERIES
--PROTEIN LONGER THAN 100 AMINO ACIDS
SELECT protein_name, length
FROM proteins
WHERE length>100;


--SHOW ALL PATHWAYS ASSOCIATED WITH A GENE
SELECT g.gene_name, p.pathway_name
FROM genes g
JOIN gene_pathway gp ON g.gene_id = gp.gene_id
JOIN pathways p ON gp.pathway_id = p.pathway_id
WHERE g.gene_name = 'BRCA1';

--COUNT PROTEINS PER ORGANISMS
SELECT g.organism, COUNT(p.protein_id) AS protein_count
FROM proteins p
JOIN genes g ON p.gene_id = g.gene_id
GROUP BY g.organism;

---RETRIVE GO TERMS FOR A SPECIFIC GENE

SELECT g.gene_name, ga.go_term, ga.go_category
FROM genes g
JOIN go_annotations ga ON g.gene_id = ga.gene_id
WHERE g.gene_name = 'TP53';


--FIND THE LONGEST GENE IN EACH ORGANISM
SELECT organism, gene_name, length
FROM genes g1
WHERE length = (
    SELECT MAX(length) FROM genes g2 WHERE g1.organism = g2.organism
);
--LIST ALL THE PROTEINS INVOLVED IN DNA REPAIR  PATHWAYS

SELECT p.protein_name, g.gene_name
FROM proteins p
JOIN genes g ON p.gene_id = g.gene_id
JOIN gene_pathway gp ON g.gene_id = gp.gene_id
JOIN pathways pw ON gp.pathway_id = pw.pathway_id
WHERE pw.pathway_name = 'DNA repair';













