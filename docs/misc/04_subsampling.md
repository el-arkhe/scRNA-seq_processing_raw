# Submuestreo (subsampling) con datos scRNA-seq
## Qué es el subsampling

En scRNA-seq, **subsampling** (también llamado *downsampling*) es el proceso de **tomar una fracción aleatoria de lecturas (reads)** o de **UMIs/cells** para simular un dataset con menor profundidad o menor tamaño. El objetivo es (mejorar) **evaluar sensibilidad, robustez y efectos técnicos**, o **reducir costo computacional** durante exploraciones iniciales.

### Tipos comunes de subsampling

- **Por reads**: reduce lecturas antes del conteo (impacta directamente UMIs/genes detectados).
- **Por UMIs**: reduce conteos en la matriz (aproxima menor profundidad).
- **Por cells**: selecciona un subconjunto de células (útil para rapidez, pero no simula menor profundidad).


### Impacto del subsampling

En general, al disminuir reads:

- ↓ `nCount_RNA` (UMIs por célula)
- ↓ `nFeature_RNA` (genes detectados por célula)
- ↓ detección de genes de baja expresión
- ↓ poder estadístico (especialmente para differential expression)

Lo que suele conservarse (si el subsampling no es extremo):

- Estructura global de clusters
- Patrones de genes altamente expresados
- Topología general en PCA/UMAP

> Nota: el subsampling agrega una capa extra de muestreo sobre un proceso ya estocástico (captura de RNA), por lo que **no será idéntico** al dataset completo, aunque puede ser un reflejo útil a nivel global.

### ¿Cuándo utilizar subsampling?

Algunos casos típicos son:

- Quieres comparar muestras con distinta profundidad (depth matching)
Si una muestra tiene muchas más lecturas por célula que otra, puede parecer “mejor” solo por mayor profundidad. Subsampling permite igualar profundidad para comparar de forma más justa.

- Benchmarking de pipelines para evaluar:
  - Estabilidad de clustering
  - Robustez de marcadores
  - Sensibilidad a menor profundidad

  Ejemplo común: 100% → 75% → 50% → 25% y comparar resultados.

- Quieres evaluar estabilidad de resultados:
Si el resultado cambia drásticamente con una reducción moderada, probablemente estabas en el límite de detección o sobreinterpretando señal débil.

- Quieres una exploración rápida en datasets grandes
Para iterar parámetros (QC, HVFs, clustering) antes de correr el análisis completo.


### ¿Cuándo NO conviene utilizar subsampling?

En lo general evita subsampling cuando:

- Necesitas detectar poblaciones raras
- Buscas genes de muy baja expresión
- Harás differential expression fino
- Tu dataset ya es de baja profundidad


## Estabilidad del número de células 

¿Cambia el número de células cuando aplicamos subsampling?

La respuesta no es simple, y depende del nivel de aplicación. La tabla de abajo  vislumbra un poco el posible resultado, pero no es una guía definitiva.

| Nivel | ¿Puede cambiar el número de células detectadas? |
|-------|-----------------------------------------------|
| FASTQ + nuevo cell calling | Sí |
| Re-ejecución completa de Cell Ranger | Sí |
| Subsampling en matriz filtrada | No |

El número de células detectadas es el resultado de un modelo estadístico de *cell calling*, basado en la distribución de UMIs por barcode. Reducir reads puede hacer que barcodes marginales caigan por debajo del umbral.

Una célula detectada no es una observación directa, sino una inferencia basada en:

- Distribución de UMIs
- Modelado de background (ambient RNA)
- Separación estadística entre señal y ruido
- Thresholds del algoritmo

Por lo tanto, el número de células detectadas depende de:

- Profundidad
- Ruido técnico
- Parámetros del pipeline

Reducir reads no cambia la biología subyacente, pero sí la evidencia estadística disponible.


### Interpretación técnica del subsampling en `Cell Ranger`

En Cell Ranger la opción de subsampling actúa a nivel de reads, no a nivel de UMIs ni de células.

Cell Ranger toma una fracción aleatoria de lecturas (reads) del FASTQ y ejecuta nuevamente el pipeline completo (cellranger count) con esas lecturas reducidas. Como consecuencia, se recalcula el cell calling bajo la nueva profundidad de secuenciación.

Al actuar sobre los reads, el subsampling:

- Disminuye el mean reads per cell
- Disminuye el median genes per cell
- Reduce la probabilidad de detectar UMIs adicionales
- Puede modificar la estimación de sequencing saturation
- Puede cambiar el número de células detectadas si algunas quedan por debajo del umbral de cell calling

En esencia, se trata de una re-ejecución completa del modelo con menor evidencia molecular.

### Métricas relevantes en el `Web Summary Report`

El `Web Summary Report` de Cell Ranger reporta métricas clave para evaluar profundidad y rendimiento del experimento, entre ellas:

- Mean reads per cell
- Median genes per cell
- Sequencing saturation
- Fraction of reads in cells

Estas métricas permiten explorar la calidad del dataset y anticipar el efecto del subsampling.

Por ejemplo, `Sequencing saturation`, estima la fracción de lecturas adicionales que  producirían nuevos UMIs únicos. Está directamente relacionada con la tasa de duplicación de moléculas.

En una `Saturación alta` (ej. >70–80%) la mayoría de las moléculas ya han sido capturadas; incrementar reads aportará poca información adicional. Mientras en una `Saturación baja` aún es probable detectar nuevas moléculas únicas con mayor profundidad.

Aproximadamente: 

`1 / (1 - saturación de secuenciación) puede interpretarse como el número de lecturas adicionales necesarias para detectar una nueva transcripción.`

    Por ej. sí la saturación de secuenciación es del 50 % (1 / 1-0.50), significa que hay 1 UMI (unique transcript in a cell barcode) por cada 2 lecturas (en códigos de barras celulares y mapeadas con precisión al transcriptoma). Por el contrario, una saturación de secuenciación del 90 % significa que hay 1 UMI por cada 10 lecturas. Si la saturación de secuenciación es alta, la secuenciación adicional no recuperaría mucha información nueva para la biblioteca.


Por tanto, la estabilidad del número de células detectadas dependerá de qué tan separada esté la distribución de señal celular del background.

El `cell calling` en Cell Ranger se basa en un modelo estadístico que intenta distinguir barcodes con señal celular real de aquellos dominados por RNA ambiental. De manera conceptualmente similar al enfoque de `EmptyDrops`, el algoritmo evalúa si el perfil de expresión de un barcode difiere significativamente de una distribución esperada de fondo. 

Por ello, la detección de células es una inferencia probabilística dependiente de la profundidad y de la separación señal/ruido; al reducir reads mediante subsampling, algunos barcodes marginales pueden perder soporte estadístico y dejar de clasificarse como células.


## Referencias y recursos adicionales

- Cell Ranger´s Gene Expression Algorithm  

  https://www.10xgenomics.com/support/software/cell-ranger/latest/algorithms-overview/cr-gex-algorithm  

- Cell Ranger count Web Summary

  https://www.10xgenomics.com/support/software/cell-ranger/latest/analysis/outputs/cr-outputs-web-summary-count

- How much sequencing saturation should I aim for?

  https://kb.10xgenomics.com/s/article/115002474263-How-much-sequencing-saturation-should-I-aim-for 

- EmptyDrops: distinguishing cells from empty droplets  

  Lun ATL et al., Genome Biology (2019). Modelo estadístico para separar células reales de droplets vacíos.  
  https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1662-y  


## Siguiente tema

- [Ir a - análisis de resultados con y sin submuestreo](/docs/main_docs/day1/04a_subsampling.md)
- [Ir a - índice del taller](../guia_curso.md)

---

© El Arkhe · MultiOmics