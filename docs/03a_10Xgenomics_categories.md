# Categorías de datos en `10x Genomics Datasets`

A la fecha, *10x Genomics Datasets* lista diferentes categorias de datos de celúla única, en lo que se refiere a datos RNA Chromium se  dividen en cinco categorias: *3' Gene Expression (v3.1, Next GEM)*, *5' Gene Expression*, *Fixed RNA Profiling*, *Nuclei RNA (Single Cell Multiome)* y *Targeted Gene Expression*.  

En esta curso nos enfocaremos en **Chromium 3' Gene Expression**, ya que esté tipo de datos corresponden a experimentos de **secuenciación de transcriptoma completo**, el cuál es además el formato más común en estudios de scRNA-seq por el momento.


### Datos con secuencias sin procesar versus datos procesados

En experimentos de scRNA-seq es importante distinguir entre **datos sin procesar (raw data)** y **datos procesados**, ya que cumplen funciones distintas dentro del flujo de análisis.

* Los **datos sin procesar** corresponden principalmente a archivos FASTQ y contienen las lecturas de secuenciación originales. Estos datos son el punto de partida para el análisis primario y permiten reprocesar el experimento utilizando diferentes parámetros, referencias o versiones de software.

* Los **datos procesados** son el resultado del análisis primario (por ejemplo, con Cell Ranger) e incluyen matrices de conteo, archivos BAM y reportes de calidad. Estos datasets están listos para análisis downstream, como control de calidad, clustering e identificación de tipos celulares.

>Cell Ranger genera datos procesados a partir de los datos sin procesar, y es fundamental entender esta relación para planificar el análisis de scRNA-seq.


## Siguiente tema

- [Ir a - modos de ejecución de `Cell Ranger`](/docs/02b_run_modes_cellranger.md)
- [Ir a - índice del taller](./guia_curso.md)

---

© El Arkhe · MultiOmics