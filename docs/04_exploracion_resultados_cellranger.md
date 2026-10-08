
# Archivos de salida de Cell Ranger: `cellranger count`

## 1. Introducción

El pipeline **`cellranger count`** de 10x Genomics procesa archivos FASTQ de experimentos single-cell RNA-seq (scRNA-seq) para generar matrices de expresión génica, métricas de calidad y resultados preliminares de análisis.

Durante el procesamiento, Cell Ranger realiza operaciones como:

1. Alineamiento de lecturas contra un genoma de referencia.
2. Identificación de códigos de barras celulares (*cell barcodes*).
3. Cuantificación de moléculas mediante identificadores moleculares únicos (*UMIs*).
4. Identificación de barcodes asociados a células (*cell calling*).
5. Generación de matrices de expresión y métricas de calidad.
6. Análisis exploratorios, como PCA, clustering y UMAP.

<p align="center">
  <img src="./docs/images/cellranger_algorithm.png" alt="Algoritmo de Cell Ranger" width="600"/>
</p>

Los archivos finales se almacenan en el directorio `outs/`.

## 2. Principales archivos de salida

La siguiente estructura corresponde a una ejecución típica de `cellranger count` para datos de expresión génica (GEX):

```text
outs/
├── web_summary.html
├── metrics_summary.csv
│
├── filtered_feature_bc_matrix/
│   ├── barcodes.tsv.gz
│   ├── features.tsv.gz
│   └── matrix.mtx.gz
│
├── filtered_feature_bc_matrix.h5
│
├── raw_feature_bc_matrix/
│   ├── barcodes.tsv.gz
│   ├── features.tsv.gz
│   └── matrix.mtx.gz
│
├── raw_feature_bc_matrix.h5
│
├── analysis/
│   ├── clustering/
│   ├── diffexp/
│   ├── pca/
│   ├── tsne/
│   └── umap/
│
├── cloupe.cloupe
├── molecule_info.h5
├── possorted_genome_bam.bam
└── possorted_genome_bam.bam.bai
```

<p align="center">
  <img src="/docs/images/cell_ranger_analisis_primario_secundario.png" alt="análisis primario y secundario">
</p>

### Descripción de los archivos

| Archivo | Descripción | Utilidad principal |
|---|---|---|
| `web_summary.html` | Reporte interactivo con métricas y gráficos del procesamiento. | Evaluación inicial de calidad (QC). |
| `metrics_summary.csv` | Métricas de procesamiento en formato tabular. | Comparar resultados entre muestras. |
| `filtered_feature_bc_matrix/` | Matriz de conteos de UMIs para barcodes identificados como células. | Análisis downstream en Seurat o Scanpy. |
| `filtered_feature_bc_matrix.h5` | Misma matriz filtrada en formato HDF5. | Importación directa a herramientas bioinformáticas. |
| `raw_feature_bc_matrix/` | Matriz que incluye todos los barcodes detectados, independientemente de su clasificación como células. | Evaluación de gotas vacías y recuperación de células. |
| `raw_feature_bc_matrix.h5` | Matriz sin filtrar en formato HDF5. | Análisis alternativos de cell calling. |
| `analysis/` | Resultados preliminares de PCA, UMAP, t-SNE, clustering y expresión diferencial. | Exploración inicial de poblaciones celulares. |
| `cloupe.cloupe` | Archivo compatible con Loupe Browser. | Visualización interactiva sin programar. |
| `molecule_info.h5` | Información de moléculas y UMIs identificados. | Agregación de muestras mediante `cellranger aggr`. |
| `possorted_genome_bam.bam` | Lecturas alineadas y ordenadas por posición genómica, con anotaciones de barcodes. | Inspección de alineamientos y análisis especializados. |
| `possorted_genome_bam.bam.bai` | Índice del archivo BAM. | Acceso rápido a regiones genómicas. |

> **Nota:** Los archivos disponibles pueden variar según la versión de Cell Ranger y el tipo de biblioteca procesada.

## 3. ¿Qué contienen las matrices de expresión?

Las matrices de expresión constituyen uno de los resultados más importantes de `cellranger count`.

En formato **Matrix Exchange (MEX)**, cada matriz está representada por tres archivos:

| Archivo | Contenido |
|---|---|
| `barcodes.tsv.gz` | Identificadores de los barcodes celulares. |
| `features.tsv.gz` | Identificadores y nombres de genes u otras características cuantificadas. |
| `matrix.mtx.gz` | Matriz dispersa con los conteos de UMIs por gen y barcode. |

**Organización de la matriz:**

- Filas: genes.
- Columnas: barcodes.
- Valores: número de UMIs asociados a cada gen y barcode.

### Diferencia entre `raw` y `filtered`

**`raw_feature_bc_matrix`**

Contiene todos los barcodes detectados, incluyendo aquellos que no fueron clasificados como células. Es útil para métodos alternativos de identificación de células, como `emptyDrops`.

**`filtered_feature_bc_matrix`**

Contiene únicamente los barcodes identificados como células por Cell Ranger.

Generalmente, esta matriz se utiliza como punto de partida para análisis posteriores en Seurat o Scanpy.

> **Importante:** Una matriz `filtered` no significa que los datos hayan pasado por todos los controles de calidad. Todavía es necesario evaluar parámetros como número de genes detectados, UMIs, porcentaje mitocondrial y posibles dobletes.

## 4. ¿Qué archivos utilizaremos después del procesamiento?

Dependiendo del objetivo, seleccionaremos diferentes archivos:

| Objetivo | Archivo recomendado |
|---|---|
| Revisar la calidad del procesamiento | `web_summary.html` |
| Comparar métricas entre muestras | `metrics_summary.csv` |
| Realizar análisis en Seurat o Scanpy | `filtered_feature_bc_matrix.h5` |
| Evaluar métodos alternativos de cell calling | `raw_feature_bc_matrix.h5` |
| Explorar resultados en Loupe Browser | `cloupe.cloupe` |
| Inspeccionar alineamientos | `possorted_genome_bam.bam` |

## 5. Actividad práctica

**Objetivo:** identificar los principales archivos generados por Cell Ranger y comprender cuáles se utilizarán en las siguientes etapas del análisis.

Una vez finalizado el procesamiento en 10x Cloud:

1. Abrir el reporte `web_summary.html`.
2. Identificar las métricas principales de calidad.
3. Explorar los archivos disponibles para descarga.
4. Identificar las matrices de expresión `raw` y `filtered`.
5. Abrir el archivo `.cloupe` en Loupe Browser para explorar los resultados.

**Resultado esperado:** reconocer los archivos necesarios para evaluar la calidad del procesamiento y continuar con el análisis de datos scRNA-seq.

---

## Referencias

1. **10x Genomics. Cell Ranger 10.0 — Outputs Overview.** Descripción general de los archivos generados por los pipelines de Cell Ranger.  
   https://www.10xgenomics.com/support/software/cell-ranger/10.0/analysis/outputs/cr-outputs-overview

2. **10x Genomics. Cell Ranger 10.0 — Gene Expression Outputs.** Descripción específica de los archivos generados por `cellranger count` para bibliotecas de expresión génica.  
   https://www.10xgenomics.com/support/software/cell-ranger/10.0/analysis/outputs/cr-outputs-gex-overview

---

© El Arkhe · MultiOmics