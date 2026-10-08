# Creación de datasets pequeños de práctica a partir de FASTQ de 10x Genomics

**Caso de estudio:** PBMC500_Donor1  
**Uso:** práctica educativa de procesamiento de datos scRNA-seq con Cell Ranger y 10x Cloud  
**Sistema:** macOS / Linux, Python 3 (biblioteca estándar)

> **Advertencia metodológica.** Este procedimiento selecciona lecturas asociadas a barcodes celulares **previamente identificados** por Cell Ranger. Produce un subconjunto artificial de FASTQ para entrenamiento, **no** una biblioteca experimental independiente de 500 células. El filtrado exacto excluye lecturas con barcodes erróneos que Cell Ranger podría corregir, y elimina gran parte de las gotas vacías. Por ello, las métricas de QC y el número de células redetectadas pueden diferir del experimento original. No utilizar este subconjunto para evaluar el desempeño experimental o realizar inferencias biológicas comparativas.

## 1. Dataset de origen

- **Fuente:** 10x Genomics, *5k Human Donor 1 PBMC, GEM-X 3' Gene Expression*.
- **Página original:** https://www.10xgenomics.com/datasets/5k_Human_Donor1_PBMC_3p_gem-x
- **Entradas:** FASTQ demultiplexados de cuatro lanes (`L001`–`L004`), pares `R1`/`R2`.
- **Datos procesados requeridos:** `sample_filtered_feature_bc_matrix/barcodes.tsv.gz`, obtenido de los resultados de Cell Ranger correspondientes al mismo dataset.
- **Estructura de R1 observada:** barcode celular de 16 nt seguido de UMI de 12 nt (28 nt en total). Verificar para cada química antes de reutilizar el procedimiento.

Los archivos de índice `I1` e `I2` no se necesitan para `cellranger count` cuando los FASTQ ya están demultiplexados.

## 2. Preparar los archivos

Organización de ejemplo, desde un directorio de trabajo:

```text
proyecto/
├── raw_fastqs_Donor1/
│   ├── 5k_Human_Donor1_PBMC_3p_gem-x_GEX_S1_L001_R1_001.fastq.gz
│   ├── 5k_Human_Donor1_PBMC_3p_gem-x_GEX_S1_L001_R2_001.fastq.gz
│   └── ... (R1/R2 de L002, L003 y L004)
└── *filtered_feature_bc_matrix.tar.gz
```

Inspeccionar el archivo comprimido de la matriz:

```bash
tar -tzf *filtered_feature_bc_matrix.tar.gz
```

En este caso la ruta interna fue `sample_filtered_feature_bc_matrix/barcodes.tsv.gz`. Extraer solo ese archivo:

```bash
tar -xzf *filtered_feature_bc_matrix.tar.gz \
  sample_filtered_feature_bc_matrix/barcodes.tsv.gz
```

Verificar cantidad y formato de barcodes:

```bash
gzip -dc sample_filtered_feature_bc_matrix/barcodes.tsv.gz | wc -l
gzip -dc sample_filtered_feature_bc_matrix/barcodes.tsv.gz | head -n 5
```

Ejemplo: `AAACCAAAGGTGACGA-1`. El sufijo `-1` es un identificador de biblioteca usado en la matriz, no forma parte de los primeros 16 nt de R1.

## 3. Seleccionar barcodes reproduciblemente

El siguiente ejemplo selecciona **500** barcodes sin reemplazo con semilla **42**. Modificar `N_CELLS` para generar otro tamaño.

```bash
python3 - <<'PY'
import gzip
import random

N_CELLS = 500
SEED = 42
INPUT = 'sample_filtered_feature_bc_matrix/barcodes.tsv.gz'
OUTPUT = f'pbmc{N_CELLS}_barcodes.txt'

with gzip.open(INPUT, 'rt') as handle:
    barcodes = [line.strip().split('-')[0] for line in handle if line.strip()]

if len(set(barcodes)) != len(barcodes):
    raise ValueError('Se encontraron barcodes duplicados al eliminar el sufijo')
if N_CELLS > len(barcodes):
    raise ValueError('N_CELLS excede el número de barcodes disponibles')

selected = random.Random(SEED).sample(barcodes, N_CELLS)
with open(OUTPUT, 'w') as handle:
    handle.write('\n'.join(sorted(selected)) + '\n')

print('Barcodes originales:', len(barcodes))
print('Barcodes seleccionados:', len(selected))
print('Archivo:', OUTPUT)
PY
```

Verificar:

```bash
wc -l pbmc500_barcodes.txt
```

Resultado esperado: `500`. Guardar el archivo de barcodes y la semilla para documentar la selección.

## 4. Comprobar la estructura de R1

```bash
gzip -dc raw_fastqs_Donor1/*L001_R1_001.fastq.gz | head -n 8
```

En el dataset utilizado, los primeros **16 nucleótidos de R1** corresponden al barcode celular y los siguientes **12** al UMI. El filtrado se realiza sobre la secuencia de R1, no sobre el encabezado FASTQ.

## 5. Prueba de coincidencias exactas en una lane

```bash
gzip -dc raw_fastqs_Donor1/*L001_R1_001.fastq.gz |
awk '
  NR==FNR {barcodes[$1]=1; next}
  NR%4==2 {
    total++
    if (substr($0,1,16) in barcodes) matched++
  }
  END {
    print "Lecturas R1:", total
    print "Lecturas coincidentes:", matched
    if (total>0) printf "Porcentaje: %.2f%%\n", 100*matched/total
  }
' pbmc500_barcodes.txt -
```

En nuestro caso: **56,512,895** lecturas originales y **4,354,926** coincidencias exactas (**7.71%**) en L001. El porcentaje de lecturas no equivale al porcentaje de células.

## 6. Filtrar FASTQ sincronizados R1/R2 de las cuatro lanes

Guardar el siguiente script como `filter_pbmc.py` en el directorio de trabajo. Conserva cada par de lecturas si los primeros 16 nt de R1 coinciden exactamente con uno de los barcodes seleccionados; verifica que los identificadores de lectura de R1 y R2 estén sincronizados.

```python
import argparse
import gzip
from pathlib import Path

parser = argparse.ArgumentParser(description='Extraer FASTQ asociados a barcodes seleccionados')
parser.add_argument('--barcodes', required=True, type=Path)
parser.add_argument('--input', required=True, type=Path)
parser.add_argument('--output', required=True, type=Path)
parser.add_argument('--prefix', default='5k_Human_Donor1_PBMC_3p_gem-x_GEX_S1')
parser.add_argument('--lanes', nargs='+', default=['L001', 'L002', 'L003', 'L004'])
args = parser.parse_args()

with args.barcodes.open() as handle:
    selected = {line.strip() for line in handle if line.strip()}
if not selected or any(len(b) != 16 for b in selected):
    raise ValueError('Se requieren barcodes únicos de 16 nucleótidos')
args.output.mkdir(parents=True, exist_ok=True)

def read_record(handle):
    first = handle.readline()
    if not first:
        return None
    rest = [handle.readline() for _ in range(3)]
    if any(not line for line in rest):
        raise ValueError('Registro FASTQ incompleto')
    record = [first, *rest]
    if not first.startswith('@') or not record[2].startswith('+'):
        raise ValueError('Formato FASTQ inválido')
    if len(record[1].strip()) != len(record[3].strip()):
        raise ValueError('Longitud de secuencia y calidad no coincide')
    return record

for lane in args.lanes:
    r1_path = args.input / f'{args.prefix}_{lane}_R1_001.fastq.gz'
    r2_path = args.input / f'{args.prefix}_{lane}_R2_001.fastq.gz'
    if not r1_path.is_file() or not r2_path.is_file():
        raise FileNotFoundError(f'Faltan FASTQ R1/R2 para {lane}')

    out_r1 = args.output / r1_path.name
    out_r2 = args.output / r2_path.name
    total = retained = 0
    print(f'Procesando {lane}...', flush=True)

    with (gzip.open(r1_path, 'rt') as r1,
          gzip.open(r2_path, 'rt') as r2,
          gzip.open(out_r1, 'wt', compresslevel=5) as w1,
          gzip.open(out_r2, 'wt', compresslevel=5) as w2):
        while True:
            rec1, rec2 = read_record(r1), read_record(r2)
            if rec1 is None and rec2 is None:
                break
            if rec1 is None or rec2 is None:
                raise ValueError(f'Diferente número de lecturas en {lane}')
            if rec1[0].split()[0] != rec2[0].split()[0]:
                raise ValueError(f'Lecturas R1/R2 desincronizadas en {lane}')
            total += 1
            if rec1[1][:16] in selected:
                w1.writelines(rec1)
                w2.writelines(rec2)
                retained += 1

    print(f'{lane}: {retained:,}/{total:,} pares ({100*retained/total:.2f}%)')

print('Filtrado completado.')
```

Ejecutar:

```bash
python3 filter_pbmc.py \
  --barcodes pbmc500_barcodes.txt \
  --input raw_fastqs_Donor1 \
  --output pbmc500_fastqs
```

**Nota:** el script procesa los FASTQ completos en flujo, sin cargar las lecturas en memoria. No modifica los originales. Para datasets de otras químicas, ajustar el tamaño y posición del barcode y los nombres de los archivos según corresponda.

## 7. Resultados obtenidos para PBMC500_Donor1

| Lane | Pares originales | Pares retenidos | Porcentaje |
|---|---:|---:|---:|
| L001 | 56,512,895 | 4,354,926 | 7.71% |
| L002 | 56,772,272 | 4,372,222 | 7.70% |
| L003 | 57,007,682 | 4,398,568 | 7.72% |
| L004 | 56,827,660 | 4,380,003 | 7.71% |
| **Total** | **227,120,509** | **17,505,719** | **7.71%** |

- **Barcodes seleccionados:** 500.
- **Pares R1/R2 retenidos:** 17,505,719.
- **Archivos resultantes:** 8 FASTQ `.fastq.gz` (R1 y R2 para cuatro lanes).
- **Tamaño comprimido observado:** aproximadamente **1.1 GB**.
- **Profundidad media aritmética:** aproximadamente 35,011 pares retenidos por barcode seleccionado; **no** equivale a la métrica `Mean Reads per Cell` reportada por un nuevo análisis de Cell Ranger.

## 8. Validar la integridad de los archivos

```bash
# Integridad de compresión
gzip -t pbmc500_fastqs/*.fastq.gz && echo 'OK: FASTQ gzip válidos'

# Igual número de registros R1 y R2 por lane
for lane in L001 L002 L003 L004; do
  echo "$lane"
  for read in R1 R2; do
    file=$(find pbmc500_fastqs -name "*${lane}_${read}_001.fastq.gz")
    gzip -dc "$file" | awk -v read="$read" 'END {
      if (NR % 4 != 0) exit 1
      printf "  %s: %d lecturas\n", read, NR/4
    }'
  done
done

# Tamaño de salida
du -sh pbmc500_fastqs
```

**Validación realizada:** los ocho archivos pasaron `gzip -t` y los conteos R1/R2 coincidieron en las cuatro lanes. El script también comprobó la correspondencia de los identificadores de cada par durante la extracción.

## 9. Opcional: renombrar el identificador de muestra

Mantener la convención de nombres de FASTQ reconocible por Cell Ranger:

```bash
cd pbmc500_fastqs
for file in *.fastq.gz; do
  mv "$file" "${file/5k_Human_Donor1_PBMC_3p_gem-x_GEX/PBMC500_Donor1}"
done
cd ..
```

Los nombres resultantes comienzan por `PBMC500_Donor1_S1_L001_R1_001.fastq.gz`, etc. El cambio de nombre no altera las lecturas.


## Limitaciones e interpretación

1. **Selección condicionada por Cell Ranger:** se eligen células identificadas previamente; no es una selección aleatoria de gotas originales.
2. **Coincidencia exacta:** se pierden lecturas cuyos barcodes requieren corrección de errores. No se reproduce el procedimiento interno de corrección de Cell Ranger.
3. **Pérdida de gotas vacías y ambiente:** puede alterar la estimación de células, `Fraction Reads in Cells`, saturación y otras métricas de QC.
4. **Células redetectadas:** seleccionar 500 barcodes no garantiza obtener exactamente 500 células en un nuevo `cellranger count`.
5. **Finalidad educativa:** útil para practicar transferencia, configuración del pipeline, ejecución y exploración de salidas; no es un benchmark imparcial de recuperación celular.

## Reproducibilidad y distribución

Conservar junto a la documentación: `pbmc500_barcodes.txt`, semilla `42`, script `filter_pbmc.py`, nombres/versión de la química, referencia y versión de Cell Ranger, así como un registro de conteos por lane. Para otros tamaños, repetir la selección con `N_CELLS` distinto y generar un directorio de salida separado.

**Descarga de los FASTQ de práctica (Google Drive):** [Descargar PBMC500_Donor1](https://drive.google.com/drive/folders/1nnfO-J9_yrRJQKF7-p3mhLPtehKRTK_h?usp=sharing
)

## Referencia y atribución

**10x Genomics.** *5k Human Donor 1 PBMC, GEM-X 3' Gene Expression.* Dataset original: https://www.10xgenomics.com/datasets/5k_Human_Donor1_PBMC_3p_gem-x

Este material educativo es un subconjunto derivado de datos proporcionados por **10x Genomics**; no fue generado por 10x Genomics como una biblioteca independiente de 500 células.

---

© El Arkhe · MultiOmics
