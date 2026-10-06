# Procesamiento de datos scRNA-seq con `Cell Ranger`


Para experimentos de **scRNA-seq** generados con la plataforma **10x Genomics Chromium**, el flujo de trabajo estándar de preprocesamiento se realiza utilizando **Cell Ranger**.

**Cell Ranger** es un conjunto de herramientas bioinformáticas diseñado para procesar datos de secuenciación crudos y generar matrices de expresión génica listas para análisis downstream (por ejemplo, en Seurat o Scanpy).

Este paso corresponde al **análisis primario** y es crítico para garantizar:
- Identificación correcta de células reales  
- Asignación precisa de barcodes y UMIs  
- Métricas de calidad confiables  

## ¿Qué es Cell Ranger?

Cell Ranger procesa datos provenientes de experimentos scRNA-seq de 10x Genomics y automatiza tareas clave como:

- Conversión de archivos BCL a FASTQ  
- Alineación a un genoma de referecia o transcriptoma  
- Clasificación de celulas (Cell calling)   
- Conteo de UMIs por gen y por célula  
- Generación de reportes de calidad  

## Flujo de procesamiento estandar de `Cell Ranger`

El flujo de trabajo típico de Cell Ranger se compone de varios comandos, cada uno con un propósito específico:

| Paso | Comando | Función principal | Output |
|----|--------|------------------|--------|
| 1 | `cellranger mkfastq` | Convierte archivos BCL en FASTQ y realiza demultiplexing por muestra y lane | FASTQ files |
| 2 | `cellranger count` | Función principal: alineación, identificación de barcodes y UMIs, cell calling y conteo | Gene-Barcode Matrix, BAM, Web Summary HTML, `.cloupe` |
| 3 | `cellranger aggr` | Agrega múltiples corridas independientes en una sola matriz | Aggregated Gene-Barcode Matrix |

### Paso 1: `cellranger mkfastq`

Este comando:
- Toma como entrada archivos **BCL** generados por el secuenciador
- Realiza **demultiplexing**
- Produce archivos **FASTQ comprimidos**

Salida principal:
- FASTQ files (R1, R2, I1)

Es equivalente conceptualmente a `bcl2fastq`
(*), pero optimizado para flujos de trabajo de 10x Genomics.

*Software de Illumina basado en Linux que convierte archivos BCL (llamadas de bases) generados por secuenciadores en archivos FASTQ estándar.

### Paso 2: `cellranger count`

Este comando dirige el flujo de procesamiento central, con las siguientes funciones principales:
- Alineación de lecturas a un reference genome/transcriptome  
- Identificación de **Cell Barcodes (CBs)** y **Unique Molecular Identifiers (UMIs)**  
- Clasificación de células (cell calling)  
- Conteo de moléculas por gen y por célula  

Salida clave:
- Matriz de conteos  (Gene-Barcode Matrix) en formato `HDF5` o `MTX`
- Archivo BAM con alineamientos
- Reporte de calidad en formato HTML (`web_summary.html`)
- Archivo `.cloupe` para visualización en Loupe Browser 
- Lista de células (barcodes.tsv) y genes (features.tsv)

#### ¿Por qué la matrriz de conteos esta en dos formatos (HDF5 y MTX)?
- **HDF5**: formato binario jerárquico optimizado para almacenamiento eficiente y acceso rápido. Es el formato recomendado para análisis downstream en R o Python.
- **MTX**: formato de texto plano (Matrix Market) que es más accesible para inspección manual o uso en herramientas que no soportan HDF5. Sin embargo, es menos eficiente para datasets grandes. Se compone de 3 archivos separados: matrix.mtx, barcodes.tsv y features.tsv

La diferencia NO es el contenido, sino cómo se almacena y accede a los datos. Ambos formatos contienen la misma información biológica. 

#### ¿Cuándo usar cada uno?
- **Usa H5 sí:**
  - Trabajas en R/Seurat o Python/Scanpy
  - Quieres eficiencia y velocidad
- **Usa MTX sí:**
  - Necesitas inspeccionar/modificar datos manualmente
  - Estás depurando o enseñando (más didáctico)

## Análisis secundario generado en `Cell Ranger`

A los resultados anteriores le llamamos *análisis primario* (alineación, conteo de UMIs y *cell calling*).  Además de estos, `cellranger count`, `cellranger aggr` y `cellranger reanalyze` generan resultados de *análisis secundarios* que permiten explorar la estructura global de los datos.

<p align="center">
  <img src="/docs/images/cell_ranger_analisis_primario_secundario.png" alt="análisis primario y secundario">
</p>

Estos análisis se ejecutan sobre la **matriz de expresión filtrada y normalizada** e incluyen:

- **Principal Component Analysis (PCA)** para reducir la dimensionalidad de los datos.
- **t-SNE o UMAP** para visualizar las células en un espacio bidimensional.
- **Clustering** para agrupar células con perfiles de expresión similares.

En primer lugar se está haciendo **PCA** usando como variables los niveles de expresión de los genes (feature-barcode matrix), para proyectar cada célula en un espacio de menor dimensionalidad. Por defecto se calculan los primeros componentes principales que capturan la mayor variación en los datos.

A partir de esta representación en espacio PCA se generan visualizaciones 2-D mediante **t-SNE** o **UMAP**, lo que permite explorar la estructura  global de las células.

Posteriormente se realiza el **clustering**, donde Cell Ranger aplica dos estrategias:

- **Graph-based clustering**, que identifica comunidades celulares sin especificar previamente el número de clusters.
- **K-means clustering**, evaluando distintos valores de **K** (número de clusters), típicamente entre **K = 2 y 10**.

⚠️ **Nota:** estos resultados son exploratorios y sirven principalmente para inspección inicial de los datos. El análisis *downstream* detallado se realiza posteriormente.

## Proceso de análisis secundario con `cellranger aggr`

El comando `cellranger aggr` permite **integrar múltiples datasets previamente procesados con `cellranger count`** en un único conjunto de datos combinado.

Este comando toma como entrada las matrices de expresión generadas por `cellranger count`, y realiza los siguientes pasos:
- Normaliza por profundidad de secuenciación (sequencing depth)
- Opcionalmente aplica downsampling para igualar el número de lecturas por célula entre muestras
- Luego recalcula PCA, UMAP/t-SNE y clustering

Se utiliza principalmente cuando se desea:
- Integrar múltiples muestras o donadores  
- Combinar corridas provenientes de diferentes *lanes*  
- Analizar experimentos replicados  

Salida principal:

- **Aggregated Gene-Barcode Matrix**
- **Web Summary agregado**

Cabe aclarar que la integración de los datasets NO tienen corrección de *batch effect*. El comando solo normaliza y corrige diferencias técnicas simples como:
- Más o menos lecturas por célula
- Diferente saturación de secuenciación

Pero NO corrige diferencias sistemáticas entre muestras (batch effects) como:
- Diferentes donadores
- Diferencias en preparación de librerías
- Cambios de química o plataforma
- Variación biológica no deseada, etc.

    Analogía conceptual:
    aggr = “igualemos el volumen de todos los micrófonos” 🎚️
    Batch correction = “alineemos todas las voces aunque se grabaron en estudios distintos” 🎙️

## En resumen:

El resultado central del preprocesamiento es obtener la matriz de conteos **Filtered feature-barcode matrix** (H5 o MTX) y el `Web Summary` con métricas de calidad con paso inicial exploratorio.

## Referencias y recursos adicionales

- Comenzando con Cell Ranger:\
  https://www.10xgenomics.com/support/software/cell-ranger/latest/getting-started
- Analysis steps:\
  https://www.10xgenomics.com/support/software/cell-ranger/latest/analysis/running-pipelines/cr-gex-count#analysis-steps

## Siguiente tema
- [Ir a - comprendiendo las químicas chromium 3′](/docs/02a_seleccion_datos_chromium_sc.md)
- [Ir a - índice del taller](/docs/README.md#índice-del-taller)

---

© El Arkhe · MultiOmics
