#!/usr/bin/env bash
# Create a small, cell-barcode-enriched FASTQ dataset from 10x 3' R1/R2.
# Requires: bash, python3, awk, gzip. macOS/Linux.

# Nota metodológica: el script conserva lecturas con coincidencia exacta del barcode en R1. 
# No reproduce la corrección de barcodes de Cell Ranger, por lo que los datasets resultantes 
# son subconjuntos artificiales para entrenamiento. Además, el script selecciona nuevamente 
# los barcodes; para reproducir exactamente los FASTQ que ya generamos, conviene conservar 
# el archivo original pbmc500_barcodes.txt.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash create_small_scrnaseq_dataset.sh \
    --fastq-dir DIR --barcodes FILE --output-dir DIR \
    [--cells 500] [--seed 42] [--barcode-length 16]

Example:
  bash create_small_scrnaseq_dataset.sh \
    --fastq-dir raw_fastqs_Donor1 \
    --barcodes sample_filtered_feature_bc_matrix/barcodes.tsv.gz \
    --output-dir PBMC500_Donor1_fastqs \
    --cells 500 --seed 42

BARCODES may be .tsv or .tsv.gz from filtered_feature_bc_matrix.
Only paired R1/R2 FASTQs are written. Original inputs are untouched.
EOF
}
FASTQ_DIR='' BARCODES='' OUTPUT_DIR='' CELLS=500 SEED=42 BARCODE_LENGTH=16
while (($#)); do
  case "$1" in
    --fastq-dir) FASTQ_DIR=${2:?}; shift 2;;
    --barcodes) BARCODES=${2:?}; shift 2;;
    --output-dir) OUTPUT_DIR=${2:?}; shift 2;;
    --cells) CELLS=${2:?}; shift 2;;
    --seed) SEED=${2:?}; shift 2;;
    --barcode-length) BARCODE_LENGTH=${2:?}; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2;;
  esac
done
[[ -d "$FASTQ_DIR" && -f "$BARCODES" && -n "$OUTPUT_DIR" ]] || { usage >&2; exit 2; }
[[ "$CELLS" =~ ^[1-9][0-9]*$ && "$SEED" =~ ^[0-9]+$ && "$BARCODE_LENGTH" =~ ^[1-9][0-9]*$ ]] || { echo 'Invalid numeric option' >&2; exit 2; }
[[ ! -e "$OUTPUT_DIR" ]] || { echo "Output exists; choose a new directory: $OUTPUT_DIR" >&2; exit 2; }
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR=$(cd "$OUTPUT_DIR" && pwd)
FASTQ_DIR=$(cd "$FASTQ_DIR" && pwd)
BARCODES=$(cd "$(dirname "$BARCODES")" && pwd)/$(basename "$BARCODES")
SELECTED="$OUTPUT_DIR/selected_barcodes.txt"
python3 - "$BARCODES" "$SELECTED" "$CELLS" "$SEED" <<'PY'
import gzip, random, sys
src, dst, n, seed = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
reader = gzip.open if src.endswith('.gz') else open
with reader(src, 'rt') as fh:
    barcodes = list(dict.fromkeys(line.strip().split('-')[0] for line in fh if line.strip()))
if len(barcodes) < n:
    raise SystemExit(f'Only {len(barcodes)} distinct barcodes; requested {n}')
selected = sorted(random.Random(seed).sample(barcodes, n))
with open(dst, 'w') as out:
    out.write('\n'.join(selected) + '\n')
print(f'Selected {n} of {len(barcodes)} barcodes (seed={seed})')
PY

shopt -s nullglob
r1_files=("$FASTQ_DIR"/*_L???_R1_001.fastq.gz)
((${#r1_files[@]})) || { echo 'No *_L???_R1_001.fastq.gz found' >&2; exit 1; }
printf 'lane\tinput_pairs\tretained_pairs\tpercent\n' > "$OUTPUT_DIR/filter_summary.tsv"
for r1 in "${r1_files[@]}"; do
  name=$(basename "$r1")
  r2="$FASTQ_DIR/${name/_R1_/_R2_}"
  [[ -f "$r2" ]] || { echo "Missing matching R2 for $name" >&2; exit 1; }
  lane=$(printf '%s\n' "$name" | grep -o 'L[0-9][0-9][0-9]' | tail -1)
  # Change only the sample prefix; preserve _S#_L###_R#_001.fastq.gz naming.
  suffix=${name#*_S}
  out1="$OUTPUT_DIR/SmallDataset_S${suffix}"
  out2="${out1/_R1_/_R2_}"
  echo "Filtering $lane ..."
  # awk reads R1 records from stdin and R2 records through a second stream.
  # Writes matched records to gzip pipes; detects mismatched/partial records.
  gzip -dc "$r1" | awk -v bcfile="$SELECTED" -v r2file="$r2" \
    -v out1="$out1" -v out2="$out2" -v len="$BARCODE_LENGTH" \
    -v summary="$OUTPUT_DIR/filter_summary.tsv" -v lane="$lane" '
    BEGIN {
      while ((getline bc < bcfile) > 0) keep[bc]=1
      close(bcfile)
      cmd2="gzip -dc \"" r2file "\""
      cmdout1="gzip -c > \"" out1 "\""
      cmdout2="gzip -c > \"" out2 "\""
    }
    {
      h1=$0
      if ((getline s1) <= 0 || (getline p1) <= 0 || (getline q1) <= 0) {
        print "Incomplete R1 record" > "/dev/stderr"; exit 1
      }
      if ((cmd2 | getline h2) <= 0 || (cmd2 | getline s2) <= 0 ||
          (cmd2 | getline p2) <= 0 || (cmd2 | getline q2) <= 0) {
        print "R2 shorter or incomplete" > "/dev/stderr"; exit 1
      }
      split(h1,a," "); split(h2,b," ")
      if (a[1]!=b[1] || substr(h1,1,1)!="@" || substr(h2,1,1)!="@" ||
          substr(p1,1,1)!="+" || substr(p2,1,1)!="+") {
        print "FASTQ headers out of sync or invalid" > "/dev/stderr"; exit 1
      }
      total++
      if (substr(s1,1,len) in keep) {
        print h1 "\n" s1 "\n" p1 "\n" q1 | cmdout1
        print h2 "\n" s2 "\n" p2 "\n" q2 | cmdout2
        retained++
      }
    }
    END {
      if (cmd2 != "" && (cmd2 | getline extra) > 0) {
        print "R2 has extra records" > "/dev/stderr"; exit 1
      }
      if (cmd2 != "") close(cmd2)
      if (cmdout1 != "") close(cmdout1)
      if (cmdout2 != "") close(cmdout2)
      if (total>0) {
        printf "%s\t%d\t%d\t%.4f\n",lane,total,retained,100*retained/total >> summary
        printf "%s: %d / %d pairs (%.2f%%)\n",lane,retained,total,100*retained/total
      }
    }
  '
done
printf '\nValidating gzip streams ...\n'
gzip -t "$OUTPUT_DIR"/*.fastq.gz
printf 'Done. Files: %s\n' "$OUTPUT_DIR"
