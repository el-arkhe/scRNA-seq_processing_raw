# Comprendiendo los datos: archivos FASTQ y estructura de datos 10x Genomics

Antes de comenzar cualquier análisis de **single-cell RNA-seq (scRNA-seq)**, es fundamental entender el tipo de datos con los que vamos a trabajar.

### ¿Qué es un archivo FASTQ?

Los archivos **FASTQ** contienen las lecturas crudas generadas por el secuenciador. Cada lectura incluye:

- **Identificador de la secuencia**
- **Secuencia de nucleótidos**
- **Separador (+)**
- **Calidad de cada base (Phred score)**

### Estructura de archivos en 10x Genomics

En experimentos con plataformas como **10x Genomics**, los datos suelen organizarse en múltiples archivos FASTQ generados por *lane* y *read*.

### Archivos típicos incluyen: 

- **Read 1 (R1):** contiene el *cell barcode* y el *UMI*  
- **Read 2 (R2):** contiene la secuencia del RNA (transcrito)  
- **Index reads (I1, I2):** contienen índices de multiplexación  

Ejemplo:
```bash
❯ ❯ ls -1
5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L001_I1_001.fastq.gz
5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L001_I2_001.fastq.gz
5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L001_R1_001.fastq.gz
5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L001_R2_001.fastq.gz
5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L002_I1_001.fastq.gz
5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L002_I2_001.fastq.gz
5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L002_R1_001.fastq.gz
5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L002_R2_001.fastq.gz
```

### Archivos R1 y R2

**R1** nos dice → ¿de qué célula y qué molécula?

Ejemplo de **R1**: 
```bash
# Comando para visualizar las primeras 20 líneas de un archivo FASTQ comprimido
zcat archivo.gz | head -n 20
# alternativa para macOS
gunzip -c archivo.gz | head -n 20

## ejemplo específico con un archivo de 10x Genomics
❯ gzcat 5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L001_R1_001.fastq.gz | head
@A00984:1406:HNG35DSXC:1:1101:4562:1000 1:N:0:AATGTATCCA+TAAGCTCATT
NCTAGCTCATTACTCGCGCCTTGATGGG
+
``` 

#### Desglose: Barcode, UMI y cDNA
1. Línea de secuencia (R1):\
   NCTAGCTCATTACTCGCGCCTTGATGGG\
   En 10x 3’, esta secuencia se organiza así:\
   [ Cell Barcode ][     UMI     ][ resto / padding ]
2. Cell Barcode (CB)\
   Longitud típica: 16 bases\
   Función: identificar la célula\
   NCTAGCTCATTACTCG
   - El primer carácter es una N, lo cual indica baja calidad o base no determinada.
   - En la práctica, `Cell Ranger` filtrará o corregirá esto usando listas de barcodes válidos (whitelist)
3. UMI (Unique Molecular Identifier)
   Longitud típica: 10–12 bases (depende de la química)\
   Función: identificar moléculas únicas\
   CGCCTTGATGGG\
   Este fragmento permite distinguir moléculas originales de duplicados por PCR, lo que es crucial para obtener conteos precisos de expresión génica.
4. cDNA sequence
   No está en este archivo\
   El cDNA (transcrito) está en **R2** → *_R2_001.fastq.gz

**R2** nos dice → ¿qué gen es? 

```bash
## ejemplo específico con un archivo de 10x Genomics
❯ gzcat 5k_Human_Donor3_PBMC_3p_gem-x_GEX_S3_L001_R2_001.fastq.gz | head -n 20
@A00984:1406:HNG35DSXC:1:1101:4562:1000 2:N:0:AATGTATCCA+TAAGCTCATT
TTTTAGTTTAGGGTTCTTCCAGTTATCCATTCTAACACTAGTACAAACATAAAAATCCACATTTATGCCACAGGATTTTGCCTGAACCAG
+
```

Ahora sí estamos viendo el lado “biológico” real de la lectura\
Aquí sí está el cDNA (transcrito), es decir, la secuencia que se alineará al genoma.

#### Desglose de la secuencia
1. Línea de secuencia (R2):\
   TTTTAGTTTAGGGTTCTTCCAGTTATCCATTCTAACACTAGTACAAACATAAAAATCCACATTTATGCCACAGGATTTTGCCTGAACCAG
2. Región poli-T (polyT)
   TTTT\
   Es complementaria al polyA tail del mRNA\
   Indica que la captura fue en el extremo 3’ del transcrito\
   Esto es característico de protocolos 3’ scRNA-seq
3. Secuencia de cDNA (transcrito real)
   AGTTTAGGGTTCTTCCAGTTATCCATTCTAACACTAGTACAAACATAAAAATCCACATTTATGCCACAGGATTTTGCCTGAACCAG\
   Representa un fragmento de RNA mensajero\
   Será:
   - alineado al genoma/transcriptoma
   - asignado a un gen

### Entonces ¿Dónde están el barcode y el UMI?

| Elemento     | Ubicación |
| ------------ | --------- |
| Cell Barcode | R1        |
| UMI          | R1        |
| cDNA         | R2        |

#### Cómo se conecta R1 + R2
Ambas lecturas comparten el mismo identificador:
```bash
@A00984:1406:HNG35DSXC:1:1101:4562:1000
```
Esto permite reconstruir:
- R1 → célula + molécula
- R2 → gen

A nivel más avanzado:
- La región polyT puede variar en longitud
- A veces no es perfectamente limpia (errores de secuenciación)
- `Cell Ranger` identifica estas regiones implícitamente durante el procesamiento

#### En resumen:

Estas lecturas incluyen información clave:
- *Barcode celular (Cell Barcode):* identifica de qué célula proviene cada lectura  
- *UMI (Unique Molecular Identifier):* permite distinguir moléculas originales de duplicados por PCR  
- *Secuencia del transcrito (cDNA)*

Cada lectura en esta tecnología no representa una célula completa, sino una **molécula de RNA capturada dentro de una célula**.

Gracias a los **barcodes celulares**, podemos agrupar miles de lecturas y reconstruir el perfil de expresión a nivel de célula individual.

>Nota: no te preocupes sí al principio parece confuso. Con la práctica, entenderás cómo estas lecturas se combinan para reconstruir el perfil de expresión de cada célula.

---

## De FASTQ a matriz de conteos

El objetivo principal del procesamiento es convertir los archivos FASTQ en una **matriz de expresión génica**, donde:

- Filas = genes  
- Columnas = células  
- Valores = número de UMIs (expresión génica)

---

### Pasos principales del procesamiento

1. **Demultiplexado (si aplica)**  
   Separar muestras si fueron secuenciadas juntas  

2. **Asignación de lecturas a células**  
   Usando los *cell barcodes*  

3. **Filtrado de calidad**  
   Eliminar lecturas de baja calidad  

4. **Alineamiento o pseudoalineamiento**  
   Mapear las lecturas al genoma o transcriptoma de referencia  

5. **Conteo de UMIs**  
   Generar la matriz de expresión evitando duplicados  

---

### Herramientas comunes

La herramienta más utilizada para datos de **10x Genomics** es:

- **Cell Ranger** (pipeline oficial)

Este software automatiza todo el flujo:

>FASTQ → alineamiento → filtrado → matriz de conteos


## Salida típica: matriz de conteos

El resultado final es una matriz dispersa (*sparse matrix*), acompañada de archivos adicionales:

- `matrix.mtx` → matriz de conteos  
- `barcodes.tsv` → lista de células  
- `features.tsv` → lista de genes  

Este formato es compatible con herramientas como:

- **Seurat (R)**
- **SingleCellExperiment (R/Bioconductor)**
- **Scanpy (Python)**

## ¿Dondé encontramos estos datos?
Generalmente, estos datos están disponibles en repositorios públicos como:

- 10x Genomics datasets  
- GEO (Gene Expression Omnibus)  
- SRA (Sequence Read Archive)  

En este taller utilizararemos datos sin procesar y preprocesados accesibles públicamente, lo que permite abordar el flujo completo del  análisis, sin omitir pasos.


## Siguiente tema
- Ir a [Plataforma 10x Genomics Chromium](/docs/01b_chromium_platforms.md)
- Ir al [Índice del taller](./guia_curso.md)

## Referencias y recursos adicionales

---
© El Arkhe · MultiOmics