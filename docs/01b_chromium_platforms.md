# Plataforma 10x Genomics Chromium  

La plataforma Chromium de 10x Genomics es el estándar actual para análisis de single-cell RNA-seq (scRNA-seq) de alto rendimiento.

Actualmente, la química vigente para expresión génica 3′ es **GEM-X Universal 3′ Gene Expression v4**. Sin embargo, una gran proporción de datasets públicos fueron generados con **Next GEM v3.1**, por lo que es importante comprender ambas generaciones.


## Innovaciones Fundamentales de la Plataforma Chromium

### 1. Captura Celular Basada en Microgotas (GEM Technology)

El sistema Chromium utiliza microfluídica (Droplet-Based Cell Capture) para encapsular células individuales en gotas nanolíticas llamadas **GEMs (Gel Bead-in-Emulsions)**

Cada GEM contiene:

- Una célula individual
- Una perla de gel con oligonucleótidos barcoded
- Reactivos de reverse transcription

Este diseño permite miles de reacciones paralelas independientes en minutos.

### 2. Barcoding Celular y UMIs

Cada perla contiene millones de copias de oligonucleótidos con:

- **Cell barcode** (identificador único por célula)
- **UMI (Unique Molecular Identifier)**
- Secuencia **poly(dT)** para capturar mRNA poliadenilado
- Secuencias necesarias para PCR

Cuando la célula se lisa dentro del GEM:

- Todo su mRNA recibe el mismo *cell barcode*
- Cada molécula individual recibe un UMI distinto

Esto permite:

- Mezclar miles de células tras la captura
- Secuenciar todo en una sola corrida
- Asignar lecturas a su célula de origen
- Contar moléculas reales y eliminar duplicados de PCR

### 3. Alto Rendimiento

La plataforma permite:

- Capturar 500–20,000 células por muestra
- Detectar 1,000–5,000 genes por célula en promedio
- Procesar hasta 8 muestras simultáneamente
- Alta reproducibilidad experimental

## Flujo Experimental Completo

### Paso 1: Preparación de Muestra

- Aislamiento de células o núcleos
- Viabilidad ideal >85%
- Concentración: 700–1,200 células/μL
- Eliminación de células muertas si es necesario

### Paso 2: Generación de GEMs

- Células + gel beads + aceite → formación de GEMs
- ~6–7 minutos para 8 muestras
- Lisis celular dentro de la gota
- Captura inmediata del mRNA

### Paso 3: Síntesis y Amplificación de cDNA

- Reverse transcription dentro del GEM
- Ruptura de emulsión
- Amplificación del cDNA

Resultado: cDNA con barcodes y UMIs incorporados.

### Paso 4: Preparación de Librerías

- Fragmentación enzimática
- Adición de adaptadores Illumina
- Selección por tamaño (400–600 bp)
- Cuantificación

### Paso 5: Secuenciación

Plataformas comunes:

- NovaSeq
- NextSeq
- HiSeq

Estructura conceptual de reads (3′ Gene Expression):

- Read 1 (~28 bp): Cell barcode + UMI
- Read 2 (~90–100 bp): Secuencia de cDNA
- Index reads (lecturas): Identificación de muestra

Profundidad recomendada:

20,000–50,000 reads por célula

### Paso 6: Procesamiento Computacional

El flujo de procesamiento (pipeline) de secuencias sin procesar con el software estándar de Cell Ranger incluye:

1. Demultiplexación
2. Control de calidad
3. Alineación al genoma de referencia
4. Conteo de UMI
5. Generación de matriz de expresión
6. Llamadas a celulas (cell calling)


## Diagrama conceptual del flujo de procesamiento con Cell Ranger de 10x Genomics

```bash
┌───────────────────────────────┐
│        MUESTRA BIOLÓGICA      │
│  (tejido, sangre, núcleos)    │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│  AISLAMIENTO CELULAR / QC    │
│  Viabilidad >85%              │
│  700–1200 células/µL          │
└───────────────┬───────────────┘
                │
                ▼
┌──────────────────────────────────────────────┐
│      INSTRUMENTO CHROMIUM (Microfluídica)    │
│                                              │
│  Células + Gel Beads + Oligos → GEMs         │
│                                              │
│   ┌──────────────┐   ┌──────────────┐        │
│   │   GEM 1      │   │   GEM 2      │  ...   │
│   │ [1 célula]   │   │ [1 célula]   │        │
│   │ [1 barcode]  │   │ [1 barcode]  │        │
│   └──────────────┘   └──────────────┘        │
└───────────────┬──────────────────────────────┘
                │
                ▼
┌───────────────────────────────┐
│  LISIS + REVERSE TRANSCRIPTION│
│  mRNA + poly(dT)              │
│  Incorporación de:            │
│   - Cell Barcode              │
│   - UMI                       │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│  RUPTURA DE GEMs              │
│  Pool de cDNA amplificado     │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│  PREPARACIÓN DE LIBRERÍA      │
│  Fragmentación + Adaptadores  │
│  Tamaño ~400–600 bp           │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│       SECUENCIACIÓN           │
│                               │
│  Read 1 → Barcode + UMI       │
│  Read 2 → cDNA (gen)          │
│  Index → Muestra              │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│    PROCESAMIENTO COMPUTACIONAL│
│                               │
│  Demultiplexing               │
│  Alignment                    │
│  UMI counting                 │
│  Cell calling                 │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│  MATRIZ DE EXPRESIÓN GÉNICA   │
│  Genes × Células              │
└───────────────────────────────┘
```

## Comparación de Químicas: Next GEM v3.1 vs GEM-X Universal 3′ v4

| Característica | Next GEM v3.1 | GEM-X Universal 3′ v4 |
|---------------|---------------|------------------------|
| Periodo principal | 2021–2023 | 2023–presente |
| Plataforma | Chromium Controller | Chromium X |
| Estado actual | Amplio uso en datasets públicos | Versión vigente actual |
| Recuperación celular | Alta | Muy alta (~80%) |
| Sensibilidad | Mejorada vs v3 | Mayor robustez |
| Read 2 típico | 91–98 bp | ~90–100 bp |
| Compatibilidad Cell Ranger | Total | Total (requiere versión reciente) |
| Uso recomendado | Dataset legado | Nuevos experimentos |

## Diferencias Clave

- GEM-X v4 mejora eficiencia de captura celular.
- Mayor consistencia experimental.
- Optimizada para arquitectura Chromium X.
- Mantiene el mismo principio conceptual de barcoding + UMI.

## Implicaciones para el análisis *Downstream*

Desde el punto de vista computacional:

- El modelo conceptual no cambia.
- Se mantiene el esquema barcode + UMI.
- El *pipeline* analítico es equivalente.
- Las diferencias impactan sensibilidad experimental, no la lógica de análisis.

## Nota para el taller

1. Trabajaremos con datos **Next GEM v3.1**, ya que:
    - Es uno de los formatos más abundantes en repositorios públicos.
    - Es ideal para enseñanza.
    - Permite reproducibilidad.
    - El análisis downstream es equivalente a GEM-X v4.

    Para nuevos experimentos, **GEM-X Universal 3′ v4 es la versión recomendada actualmente**.

2. Consultar siempre:
    - Documentación oficial de 10x Genomics
    - Guías de usuario de Chromium
    - Documentación de Cell Ranger
    - Benchmarks recientes de tecnologías single-cell
    - Publicaciones metodológicas sobre microdroplet-based scRNA-seq

3. Verificar siempre:
    - Versión de química utilizada
    - Versión de Cell Ranger
    - Estructura de reads
    - Profundidad de secuenciación

## En resumen

La plataforma Chromium combina:

- Microfluídica de precisión
- Barcoding masivo
- Identificación molecular por UMI

---

## Siguiente tema
- [Ir a - Procesamiento de datos scRNA-seq con `Cell Ranger`](/docs/main_docs/day1/02_preprocessing_scrnaseq_datasets.md)
- [Ir a - Índice del taller](/docs/README.md#índice-del-taller)

---

© El Arkhe · MultiOmics

