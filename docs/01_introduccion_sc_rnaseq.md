# Introducción a Single-Cell RNA-seq (scRNA-seq)


## ¿Qué es scRNA-seq?

La **secuenciación de RNA a nivel de célula individual (single-cell RNA-seq, scRNA-seq)** es una tecnología que permite medir la expresión génica **de miles a millones de células individuales en paralelo**.  
A diferencia del RNA-seq tradicional (bulk), donde la señal corresponde a un promedio de muchas células, scRNA-seq permite **revelar la heterogeneidad celular**, identificar **subpoblaciones raras** y estudiar **estados celulares dinámicos** dentro de tejidos complejos.

Esta tecnología ha transformado áreas como inmunología, neurociencia, biología del desarrollo y cáncer, donde entender la diversidad celular es clave.

    Analogía conceptual:
    Imagina que observas una ciudad desde el cielo. Te dicen que la temperatura promedio es templada, agradable, equilibrada. Todo parece estar en calma.
    Pero decides descender. Entras edificio por edificio. Y entonces descubres otra historia: oficinas donde el aire es sofocante, departamentos helados, cocinas ardiendo, sótanos húmedos y fríos.
    El promedio aunque correcto, no cuenta los detalles.
    El RNA-seq bulk es esa vista aérea: una cifra que simplifica una medición.
    El scRNA-seq es caminar la ciudad por dentro: revelar que cada célula vive su propia temperatura molecular.


## ¿Por qué usar scRNA-seq?

scRNA-seq permite responder preguntas que no pueden abordarse con datos bulk, por ejemplo:

- ¿Qué **tipos celulares** existen en un tejido?
- ¿Existen **estados transicionales** o poblaciones raras?
- ¿Cómo cambia la expresión génica entre condiciones, regiones o etapas de desarrollo?
- ¿Cómo se organiza la heterogeneidad celular en sistemas biológicos complejos?

Gracias a su resolución, scRNA-seq se ha convertido en la base de **atlases celulares** y estudios multi-ómicos modernos.


## Principio general de la tecnología (10x Genomics)

Una de las plataformas más utilizadas para scRNA-seq es la tecnología de microfluídica desarrollada por 10x Genomics. Su principio básico es el siguiente:

1. Las **células individuales** se encapsulan en microgotas.
2. Cada célula se combina con una **gel bead** que contiene oligonucleótidos con:
   - Un **barcode celular** (identifica la célula)
   - Un **UMI (Unique Molecular Identifier)** (identifica moléculas individuales)
   - Un oligo-dT para capturar mRNA poliadenilado
3. Dentro de cada gota (GEM, *Gel Bead-in-Emulsion*), el RNA se retrotranscribe y queda **etiquetado de forma única por célula**.
4. El cDNA se amplifica, se construyen librerías y se secuencia.
5. Los barcodes permiten reconstruir computacionalmente **qué genes provienen de cada célula**.


## Plataformas y mejoras tecnológicas

Las versiones recientes de la plataforma Chromium (por ejemplo **Chromium X / GEM-X**) permiten:

- Mayor **recuperación de células**
- Menor tasa de **dobletes**
- Mejor escalabilidad (cientos de miles a millones de células)
- Compatibilidad con distintos tipos de muestra (células frescas, congeladas o núcleos)

Existen distintos tipos de ensayos según el diseño experimental:

- **Single Cell 3’ Gene Expression**
- **Single Cell 5’ Gene Expression**
- **Single Cell Flex** (muestras fijadas)
- Integración con **multi-omics** (RNA + ATAC, proteínas, etc.)


## Del experimento al análisis de datos

El flujo típico de un experimento scRNA-seq incluye:

1. Preparación de la muestra (disociación celular o aislamiento de núcleos)
2. Generación de librerías scRNA-seq
3. Secuenciación
4. Procesamiento primario (alineamiento, conteo y control de calidad)
5. Análisis downstream:
   - Control de calidad celular
   - Normalización
   - Reducción de dimensión
   - Clustering
   - Identificación de genes marcadores
   - Anotación de tipos celulares


## Siguiente tema
- Ir a [Archivos FASTQ y matrices de datos](/docs/01a_fastq_matrices_datos.md)
- Ir al [Índice del taller](./guia_curso.md)

## Referencias y recursos adicionales

- Introducción a single-cell:  
  https://cyntsc.github.io/single_cell_RNA-seq/starting/

- Introducción a scRNA-seq (10x Genomics):  
  https://www.10xgenomics.com/blog/single-cell-rna-seq-an-introductory-overview-and-tools-for-getting-started

- ¿Qué es una GEM?:  
  https://www.10xgenomics.com/resources/videos/what-is-a-gem

- Visión general de scRNA-seq (10x Genomics):  
  https://www.10xgenomics.com/solutions/single-cell-gene-expression  

- Ensayos Single Cell Flex:  
  https://www.10xgenomics.com/products/single-cell-flex

- Revisión en *Nature Reviews Genetics* sobre fundamentos y retos del análisis de scRNA-seq:  
  https://www.nature.com/articles/s41576-023-00586-w

- Recursos educativos de 10x Genomics:  
  https://www.10xgenomics.com/resources

- Videos y explicaciones visuales:  
  https://www.10xgenomics.com/resources/videos

---

© El Arkhe · MultiOmics
