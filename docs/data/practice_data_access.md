# Acceso y descarga de datos scRANA-seq

Los datasets Chromium de 10x Genomics referidos en este curso pueden ser de gran tamaño y presentar algunas  limitantes para algunos participantes, como la velocidad de descarga o la capacidad de almacenamiento local. 

Por ello, se han preparado **datasets de práctica** a partir de datasets públicos de 10x Genomics para que los participantes del curso puedan **transferir archivos FASTQ a 10x Cloud**, ejecutar **Cell Ranger count** y explorar los resultados sin necesidad de descargar datasets completos, los llameremos (conceptualmente) *dataset-practica-500*.

Puedes consultar los datasets originales de 10x Genomics utilizados en esta práctica en el siguiente enlace: 

Accede a [10x Genomics Datasets](https://www.10xgenomics.com/datasets/5k_Human_Donor1_PBMC_3p_gem-x)

| Dataset y enlace directo | Células detectadas |
|---|---:|
| [5k Human PBMCs — Donor 1](https://www.10xgenomics.com/datasets/5k_Human_Donor1_PBMC_3p_gem-x) | 5,709 |
| 5k Human PBMCs — Donor 2 | 5,987 |
| 5k Human PBMCs — Donor 3 | 4,773 |
| 5k Human PBMCs — Donor 4 | 5,721 |
| Total | 22,190 |

## Datasets de práctica

Descargar desde Google Drive el *dataset-practica-500* a traves del siguiente enlace:

**Google Drive:** [Descargar dataset-practica-500](https://drive.google.com/drive/folders/1nnfO-J9_yrRJQKF7-p3mhLPtehKRTK_h?usp=sharing
)

Si los problemas de conectividad, descarga o almacenamiento persisten, puedes:
- Descargar los archivos de manera individual desde el mismo enlace.
 

Si la transferencia de archivos a *10x Cloud* es lenta,  puedes crear un dataset más pequeño a partir de los *dataset-practica-500*. 

- Como ya tenemos sus FASTQ generados y validados; basta con copiar los dos archivos correspondientes (R1/R2) a L001 a otro directorio.

```bash
mkdir -p PBMC500_L001

cp pbmc500_fastqs/*L001_R[12]_001.fastq.gz \
   PBMC500_L001/
```

Basicamente, este comando copia los dos archivos FASTQ de la lane 1 a un nuevo directorio llamado `PBMC500_L001`. 

Luego puedes subir este directorio a *10x Cloud* y ejecutar *Cell Ranger count* con estos archivos. El cual contendra las mismas celulas que el dataset completo, pero con menos profundidad de secuenciación por celula. Esto es útil para practicar la transferencia de archivos y la ejecución de *Cell Ranger* sin necesidad de descargar todo el dataset.


## Bono extra 

*Quieres practicar con otros datasets de 10x Genomics?*

Puedes crear tus propios subconjuntos de datos de práctica  siguiendo el procedimiento descrito en la **sección 4** del documento [PBMC500 Donor 1 — Dataset de práctica para Cell Ranger](../07_dataset_PBMC500_donor1.md) o con el *script* que comparto a continuación.

Este *bash script* (macOS y Linux) automatiza la creación de datasets pequeños de scRNA-seq a partir de FASTQ originales y los barcodes identificados por Cell Ranger. 

Esto permite generar subconjuntos de práctica similares a PBMC500_Donor1 a partir de otros datasets públicos de 10x Genomics. Así creé **PBMC1000_Donor1**, **PBMC5000_Donor2** y otros para los cursos.

*Script*: [subsample_fastqs.sh](./scripts/create_small_scrnaseq_dataset.sh)

**Funcionalidades**
- Selecciona aleatoriamente 100, 500, 1,000 o cualquier número válido de barcodes.
- Utiliza una semilla fija (42) para reproducibilidad.
- Procesa automáticamente las cuatro lanes, o las que encuentre.
- Conserva la sincronización entre R1 y R2.
- Genera FASTQ comprimidos compatibles con Cell Ranger.
- Verifica la integridad gzip y genera filter_summary.tsv.
- No modifica los archivos originales.

>No dejes de prácticar con estos datasets de práctica y experimentar con la transferencia de archivos y la ejecución de *Cell Ranger count* en 10x Cloud.

---

© El Arkhe · MultiOmics