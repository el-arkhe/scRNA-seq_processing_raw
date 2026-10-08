# PBMC500 Donor 1 — Dataset de práctica para Cell Ranger

## 1. Descripción

**PBMC500_Donor1** es un **subconjunto artificial para entrenamiento** de lecturas FASTQ derivado del dataset público **5k Human Donor 1 PBMC, Chromium GEM-X Single Cell 3′ Gene Expression** de 10x Genomics. Se diseñó para practicar la transferencia de archivos a **10x Genomics Cloud**, la ejecución de **Cell Ranger count** y la interpretación de los archivos de salida.

Se seleccionaron aleatoriamente **500 barcodes celulares** de la matriz filtrada previamente generada por Cell Ranger (semilla aleatoria `42`). Posteriormente, se conservaron de los FASTQ originales únicamente los pares de lecturas R1/R2 cuyo barcode de 16 nucleótidos al inicio de R1 coincidía **exactamente** con uno de los barcodes seleccionados.

**Importante:** este material **no representa una biblioteca experimental independiente de 500 células**. 

## 2. Acceso y descarga

**Google Drive:** [Descargar PBMC500_Donor1](https://drive.google.com/drive/folders/1nnfO-J9_yrRJQKF7-p3mhLPtehKRTK_h?usp=sharing
)

1. Abre el enlace de Google Drive.
2. Descarga los **ocho archivos `.fastq.gz`** de la carpeta `pbmc500_fastqs/` (o descarga la carpeta completa)
3. Conserva los nombres de archivo, incluidos los identificadores de lane (`L001`–`L004`) y lectura (`R1`/`R2`)
4. No descomprimas los FASTQ antes de subirlos a 10x Cloud

**Tamaño total comprimido:** aproximadamente **1.1 GB**.

## 3. Archivos incluidos

El conjunto consta de ocho archivos FASTQ comprimidos: cuatro pares R1/R2, uno por lane de secuenciación.

```text
pbmc500_fastqs/
├── PBMC500_Donor1_S1_L001_R1_001.fastq.gz
├── PBMC500_Donor1_S1_L001_R2_001.fastq.gz
├── PBMC500_Donor1_S1_L002_R1_001.fastq.gz
├── PBMC500_Donor1_S1_L002_R2_001.fastq.gz
├── PBMC500_Donor1_S1_L003_R1_001.fastq.gz
├── PBMC500_Donor1_S1_L003_R2_001.fastq.gz
├── PBMC500_Donor1_S1_L004_R1_001.fastq.gz
└── PBMC500_Donor1_S1_L004_R2_001.fastq.gz
```

>El tiempo estimado de transferencia de los ocho archivos a 10x Cloud es de **5–10 minutos** con una conexión de banda ancha estable.

> Los nombres mostrados corresponden al esquema de renombrado propuesto para el curso. Si la carpeta publicada conserva el prefijo original `5k_Human_Donor1_PBMC_3p_gem-x_GEX`, los archivos siguen siendo válidos; usa sus nombres reales al cargarlos.

- **R1:** contiene el barcode celular (primeros 16 nt) y el UMI (siguientes 12 nt).
- **R2:** contiene la lectura correspondiente al transcrito.
- Los FASTQ de índices **I1/I2** no se incluyen: no son necesarios para este ejercicio con FASTQ ya demultiplexados.

## 4. Procedencia y construcción del subconjunto

**Dataset original:** [5k Human Donor 1 PBMC — 10x Genomics](https://www.10xgenomics.com/datasets/5k_Human_Donor1_PBMC_3p_gem-x), ensayo Chromium GEM-X Single Cell 3′ Gene Expression.

**Atribución:** datos originales proporcionados por **10x Genomics**. El Arkhe realizó únicamente el submuestreo educativo descrito a continuación; no generó la biblioteca biológica ni las lecturas originales.

**Procedimiento:**

1. Se obtuvo el archivo `barcodes.tsv.gz` de `sample_filtered_feature_bc_matrix` generado por Cell Ranger.
2. Se eliminaron los sufijos de barcode (por ejemplo, `-1`).
3. Se seleccionaron **500 barcodes únicos** mediante `random.sample` de Python con `random.seed(42)`.
4. Para cada lane, se leyeron sincronizadamente los FASTQ R1 y R2.
5. Se retuvieron ambos registros de cada par cuando los primeros 16 nt de R1 coincidían exactamente con un barcode seleccionado.
6. Los archivos resultantes se escribieron en formato `.fastq.gz`.

Este procedimiento **no reconstruye la corrección de barcodes** que realiza Cell Ranger; las lecturas con errores corregibles en el barcode pueden haberse excluido.

## 5. Resultados del filtrado

| Lane | Pares originales | Pares conservados | Porcentaje conservado |
|---|---:|---:|---:|
| L001 | 56,512,895 | 4,354,926 | 7.71% |
| L002 | 56,772,272 | 4,372,222 | 7.70% |
| L003 | 57,007,682 | 4,398,568 | 7.72% |
| L004 | 56,827,660 | 4,380,003 | 7.71% |
| **Total** | **227,120,509** | **17,505,719** | **7.71%** |

Los archivos conservan aproximadamente **35,011 pares de lecturas por barcode seleccionado**, en promedio. Esto **no equivale** a lecturas por célula efectivamente recuperada después de un nuevo análisis de Cell Ranger.

### Validación realizada

- Los **ocho archivos** pasaron `gzip -t`.
- Los conteos de registros FASTQ de **R1 y R2 coincidieron en las cuatro lanes**.
- El filtrado se completó en las cuatro lanes.

## 6. Uso en 10x Genomics Cloud

1. Inicia sesión en [10x Genomics Cloud](https://cloud.10xgenomics.com/)
2. Selecciona o crea un proyecto. Por ejemplo, `PBMC500_Practice`
3. Sube los ocho archivos FASTQ desde la interfaz web o mediante **10x Cloud CLI (`txg`)**
4. Verifica que los archivos R1/R2 y las cuatro lanes se agrupen correctamente.
5. Configura una ejecución compatible de **Cell Ranger count** para datos GEM-X Single Cell 3′ Gene Expression, seleccionando la referencia apropiada.
6. Revisa el `web_summary.html`, las métricas de QC y la matriz de expresión filtrada.

Ejemplo orientativo de carga desde macOS, con Cloud CLI v4.3.0:

```bash
./txg fastqs upload \
  --project-id TU_PROJECT_ID \
  /ruta/completa/pbmc500_fastqs/
```

Sustituye `TU_PROJECT_ID` y la ruta por los valores correspondientes a tu equipo. Ejecuta el comando desde el directorio donde se encuentra `txg` (o utiliza su ruta absoluta).

## 7. Limitaciones e interpretación de QC

El subconjunto se generó **después de conocer qué barcodes habían sido identificados como células**. Por ello:

- Se eliminaron la mayoría de las lecturas asociadas a gotas vacías y barcodes no seleccionados.
- Se perdieron lecturas que podrían haber sido asignadas a las células mediante corrección de errores de barcode.
- Las métricas como **Fraction Reads in Cells**, **Sequencing Saturation** y la estimación de células recuperadas pueden diferir sustancialmente del dataset original.
- No debe utilizarse este subconjunto para evaluar de forma imparcial el rendimiento del algoritmo de identificación de células, estimar RNA ambiental o comparar la calidad experimental con otras bibliotecas.

**Uso recomendado:** demostración del flujo de procesamiento, transferencia a la nube, ejecución de Cell Ranger y exploración de resultados. No es un dataset de referencia para benchmarking científico.

Referencias y atribución

1. [10x Genomics — 5k Human Donor 1 PBMC, GEM-X 3′ (dataset original)](https://www.10xgenomics.com/datasets/5k_Human_Donor1_PBMC_3p_gem-x).
2. [10x Genomics — Cell Ranger: archivos de salida](https://www.10xgenomics.com/support/software/cell-ranger/10.0/analysis/outputs/cr-outputs-overview).

**Atribución:** los datos originales pertenecen a la publicación de referencia de 10x Genomics. Este subconjunto se preparó con fines educativos para El Arkhe. Antes de redistribuir los FASTQ, verificar los términos de uso y redistribución aplicables al dataset original.

## Siguiente tema

- [Ir a - Práctica con 10x Genomics Cloud y Cell Ranger](/docs/08_practica_cloud_cellranger.md)
- [Ir a - índice del taller](./guia_curso.md)

---

**El Arkhe — Material educativo de práctica | Octubre de 2026**

© El Arkhe · MultiOmics