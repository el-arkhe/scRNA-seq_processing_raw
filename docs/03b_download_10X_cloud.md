# Descarga de archivos desde `10X Genomics on the Cloud`

Una vez concluido el procesamiento de tus datos con **Cell Ranger**, este genera múltiples archivos de salida. Para un **downstream analysis estándar** (por ejemplo en Seurat/Scanpy), normalmente solo son necesarios:

- **Reporte HTML**: `web_summary.html` (inspección rápida de métricas)
- **Matriz de conteos H5**: `sample_filtered_feature_bc_matrix.h5` (matriz para análisis)

---

## Selección de archivos a descargar

En **10X Genomics on the Cloud**:

1. Abre tu job terminado (status *Complete*).
2. En la sección **Outputs / Results**, selecciona los archivos a descargar.
3. Elige una de estas opciones:

- **(1) Download in Browser**: descarga desde el navegador.
- **(2) Download with CLI**: descarga por línea de comandos (recomendado).

---

### Paso 1. Download in Browser

Útil si:

- Descargas pocos archivos
- Son archivos relativamente pequeños
- No te preocupa reiniciar/continuar descargas

Limitaciones comunes:

- Puede fallar con archivos grandes
- Depende de la estabilidad del navegador y la conexión

---

### Paso 2. Download with CLI (Recomendado)

Al seleccionar **Download with CLI**, la plataforma te mostrará un comando listo para copiar/pegar, usando `curl` o `wget`, según tu elección.

Verás una línea de comando similar a:

```bash
curl -f -L -o config.csv "https://cloud.10xgenomics.com/api/cloud-analysis/downloads-api/v1/319533aa-9ba0-484e-a8da-9eed3b38d99d/?token=TOKEN"; \
curl -f -L --create-dirs -o per_sample_outs/Human-PBMC-Test/count/sample_filtered_feature_bc_matrix.h5 "https://cloud.10xgenomics.com/api/cloud-analysis/downloads-api/v1/6782e243-d7cc-4068-be3b-8d48abedc6c1/?token=TOKEN"; \
curl -f -L --create-dirs -o per_sample_outs/Human-PBMC-Test/web_summary.html "https://cloud.10xgenomics.com/api/cloud-analysis/downloads-api/v1/96f7b93e-cf47-430e-9b30-365ead7634e1/?token=TOKEN"
```

En general, la URL incluye un token temporal, y quien tenga este enlace puede descargar estos archivos, mientras el token sea válido.

## Buenas prácticas para colaboración
Aunque compartir la línea con el token puede ser práctico, por seguridad se recomienda:
- Descargar tú los archivos
- Subirlos a un repositorio compartido (Drive, Globus, S3, etc.)
- O generar un nuevo enlace justo antes de enviarlo


## Ejemplo de descarga de archivos (HTML y H5) usando curl -O:

```bash
# Output Files HTML y H5
curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor1_PBMC_3p_gem-x_5k_Human_Donor1_PBMC_3p_gem-x_web_summary.html

curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor1_PBMC_3p_gem-x_5k_Human_Donor1_PBMC_3p_gem-x_count_sample_filtered_feature_bc_matrix.h5
```

## Siguiente paso

Inspecciona los reportes de calidad y si satisfacen tus expectativas estas listo para iniciar  **downstream analysis**.


## Referencias y recursos adicionales

- **Cell Ranger Documentation (Official 10x Genomics Docs)**  
  Guía completa sobre procesamiento de datos scRNA-seq con Cell Ranger.  
  https://www.10xgenomics.com/support/software/cell-ranger/latest

- **10x Genomics Cloud – Support & Documentation**  
  Documentación oficial sobre análisis en la nube y gestión de jobs.  
  https://www.10xgenomics.com/support/cloud-analysis

- **10x Genomics Datasets (Public Data Portal)**  
  Repositorio oficial de datasets públicos para práctica y benchmarking.  
  https://www.10xgenomics.com/datasets

## Siguiente tema

- [Ir a - submuestreo (subsampling) con datos scRNA-seq](/docs/main_docs/day1/04_subsampling.md)
- [Ir a - índice del taller](/docs/README.md#índice-del-taller)

---

© El Arkhe · MultiOmics

