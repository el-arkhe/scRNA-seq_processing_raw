
# Análisis de resultados con y sin submuestreo (subsampling)  
## Cell Ranger Multi v9.0.1

### Datos generales

Dataset: **10X Genomics PBMC 5k**  
Referencia: GRCh38-2024-A  

Run IDs:
- 5k_Human_Donor3_PBMC_3p_gem-x  
- 5k_Human_Donor4_PBMC_3p_gem-x  

---

### Donador 3 sin subsampling
Configuración

```bash
[gene-expression]
reference,/path/to/references/GRCh38-2024-A
create-bam,false

[libraries]
fastq_id,fastqs,lanes,feature_types
5k_Human_Donor3_PBMC_3p_gem-x_GEX,/path/to/fastqs/5k_Human_Donor3_PBMC_3p_gem-x_GEX_fastqs,1|2|3|4,Gene Expression
```

### Reportes de Cell Ranger

[Reporte CSV de Cell Ranger](../support/5k_Human_Donor3_PBMC_3p_gem-x_5k_Human_Donor3_PBMC_3p_gem-x_metrics_summary.csv)

[Reporte HTML de Cell Ranger](../support/5k_Human_Donor3_PBMC_3p_gem-x_5k_Human_Donor3_PBMC_3p_gem-x_web_summary.html)

Secondary Analysis: 
- Clusters (Graph-based): 11 


### Donador 4 sin subsampling
Configuración

```bash
[gene-expression]
reference,/path/to/references/GRCh38-2024-A
create-bam,false

[libraries]
fastq_id,fastqs,lanes,feature_types
5k_Human_Donor4_PBMC_3p_gem-x_GEX,/path/to/fastqs/5k_Human_Donor4_PBMC_3p_gem-x_GEX_fastqs,1|2|3|4,Gene Expression
```

### Reportes de Cell Ranger

[Reporte CSV de Cell Ranger](../support/5k_Human_Donor4_PBMC_3p_gem-x_5k_Human_Donor4_PBMC_3p_gem-x_metrics_summary.csv)

[Reporte HTML de Cell Ranger](../support/5k_Human_Donor4_PBMC_3p_gem-x_5k_Human_Donor4_PBMC_3p_gem-x_web_summary.html)

Secondary Analysis:
- Clusters (Graph-based): 14

---

## Subsampling 
### Donador 3 con subsampling al 25% 
Configuración

```bash
[gene-expression]
reference,refdata-cellranger-GRCh38-2024-A
chemistry,auto
include-introns,true
no-secondary,false
create-bam,true
check-library-compatibility,true
tenx-cloud-token-path,tenx_cloud_token.txt
cell-annotation-model,auto
skip-cell-annotation,false

[libraries]
fastq_id,fastqs,lanes,feature_types,subsample_rate
5k_Human_Donor3_PBMC_3p_gem-x_GEX,da79956b-f1f3-4ef9-bf3d-36650b9bfe73/009f2725-d697-4ce4-9f9e-4b4da29b0cfc,any,Gene Expression,0.25
5k_Human_Donor3_PBMC_3p_gem-x_GEX,da79956b-f1f3-4ef9-bf3d-36650b9bfe73/f5785769-f17f-4685-bd6f-504ecf40c45b,any,Gene Expression,0.25
5k_Human_Donor3_PBMC_3p_gem-x_GEX,da79956b-f1f3-4ef9-bf3d-36650b9bfe73/5b2e3fb2-289a-4a53-b814-1d6c0881c759,any,Gene Expression,0.25
5k_Human_Donor3_PBMC_3p_gem-x_GEX,da79956b-f1f3-4ef9-bf3d-36650b9bfe73/fc4bdd39-99b9-4973-91c6-4b9aac6dac9c,any,Gene Expression,0.25
```

### Reportes de Cell Ranger

[Reporte CSV de Cell Ranger](../support/5k_Human_Donor_PBMC_on_the_cloud/5k_Human_Donor3_metrics_summary.csv)

[Reporte HTML de Cell Ranger](../support/5k_Human_Donor_PBMC_on_the_cloud/5k_Human_Donor3_web_summary.html)

Secondary Analysis:
- Clusters (Graph-based): 8
- Run Time: 34 Minutos


### Donador 3+4 con subsampling al 25%
Configuración

```bash
[gene-expression]
reference,refdata-cellranger-GRCh38-2024-A
chemistry,SC3Pv4
include-introns,true
no-secondary,true
create-bam,false
check-library-compatibility,true
tenx-cloud-token-path,tenx_cloud_token.txt
cell-annotation-model,auto
skip-cell-annotation,false

[libraries]
fastq_id,fastqs,lanes,feature_types,subsample_rate
5k_Human_Donor3_PBMC_3p_gem-x_GEX,4c4328a1-f273-4633-ae67-4e7529f898ea/009f2725-d697-4ce4-9f9e-4b4da29b0cfc,any,Gene Expression,0.25
5k_Human_Donor3_PBMC_3p_gem-x_GEX,4c4328a1-f273-4633-ae67-4e7529f898ea/f5785769-f17f-4685-bd6f-504ecf40c45b,any,Gene Expression,0.25
5k_Human_Donor3_PBMC_3p_gem-x_GEX,4c4328a1-f273-4633-ae67-4e7529f898ea/5b2e3fb2-289a-4a53-b814-1d6c0881c759,any,Gene Expression,0.25
5k_Human_Donor3_PBMC_3p_gem-x_GEX,4c4328a1-f273-4633-ae67-4e7529f898ea/fc4bdd39-99b9-4973-91c6-4b9aac6dac9c,any,Gene Expression,0.25
5k_Human_Donor4_PBMC_3p_gem-x_GEX,4c4328a1-f273-4633-ae67-4e7529f898ea/21543a03-0ac8-42a1-b4e2-51ad8d041bd2,any,Gene Expression,0.25
5k_Human_Donor4_PBMC_3p_gem-x_GEX,4c4328a1-f273-4633-ae67-4e7529f898ea/ef24f391-acba-4a34-8703-0ce91f5b0dbb,any,Gene Expression,0.25
5k_Human_Donor4_PBMC_3p_gem-x_GEX,4c4328a1-f273-4633-ae67-4e7529f898ea/88ff6554-7d50-470b-a436-c1d1ded19985,any,Gene Expression,0.25
5k_Human_Donor4_PBMC_3p_gem-x_GEX,4c4328a1-f273-4633-ae67-4e7529f898ea/3b30358f-4a68-48a4-b386-fb1032283a60,any,Gene Expression,0.25
```

### Reportes de Cell Ranger

[Reporte CSV de Cell Ranger](../support/5k_Human_Donor_PBMC_on_the_cloud/5k_Human_Donor3_Donor4_metrics_summary.csv)

[Reporte HTML de Cell Ranger](../support/5k_Human_Donor_PBMC_on_the_cloud/5k_Human_Donor3_Donor4_web_summary.html)

Secondary Analysis:
- Clusters (Graph-based): ?
- Run Time: 34 Minutos

    Nota que al especificar `create-bam,false` el tiempo de ejecución reduce significativamente.


## Siguiente tema

- [Ir a - práctica 1.P3: análisis comparativo de resultados de submuestreo](/scripts/day1_practice_P3.md)
- [Ir a - índice del taller](/docs/README.md#índice-del-taller)

---

© El Arkhe · MultiOmics
