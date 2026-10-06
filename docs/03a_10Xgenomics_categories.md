# Comprendiendo las categorías de datos en `10x Genomics Datasets`

A la fecha, *10x Genomics Datasets* lista diferentes categorias de datos de celúla única, en lo que se refiere a datos RNA Chromium se  dividen en cinco categorias: *3' Gene Expression (v3.1, Next GEM)*, *5' Gene Expression*, *Fixed RNA Profiling*, *Nuclei RNA (Single Cell Multiome)* y *Targeted Gene Expression*.  

En esta práctica nos enfocaremos en **Chromium 3' Gene Expression**, ya que esté tipo de datos corresponden a experimentos de **secuenciación de transcriptoma completo**, el cuál es además el formato más común en estudios de scRNA-seq.

   Nota: independientemente de sí el dato es 3', 5' o Fixed RNA, el flujo de trabajo inicial en *Seurat* suele seguir los mismos pasos esenciales. 

   En el caso de Fixed RNA Profiling (Flex), notarás que *Seurat* identifica sondas en lugar de lecturas directas de transcritos, pero el objeto final se comporta igual. Si usas 5' RNA, también podrías cargar los datos de V(D)J (TCR/BCR) como un "Assay" adicional.


### Datos con secuencias sin procesar versus datos procesados

En experimentos de scRNA-seq es importante distinguir entre **datos sin procesar (raw data)** y **datos procesados**, ya que cumplen funciones distintas dentro del flujo de análisis.

Los datos sin procesar corresponden principalmente a archivos FASTQ y contienen las lecturas de secuenciación originales. Estos datos son el punto de partida para el análisis primario y permiten reprocesar el experimento utilizando diferentes parámetros, referencias o versiones de software.

Los datos procesados son el resultado del análisis primario (por ejemplo, con Cell Ranger) e incluyen matrices de conteo, archivos BAM y reportes de calidad. Estos datasets están listos para análisis downstream, como control de calidad, clustering e identificación de tipos celulares.


## Siguiente tema

- [Ir a - modos de ejecución de `Cell Ranger`](/docs/main_docs/day1/02b_run_modes_cellranger.md)
- [Ir a - índice del taller](/docs/README.md#índice-del-taller)

---

© El Arkhe · MultiOmics