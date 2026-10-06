# Carga y Descarga de archivos single-cell desde `10x Genomics Datasets` a `10x Genomics on the Cloud`

Tenemos diferentes opciones para descargar y subir archivos de datos de secuenciación de células individuales (scRNA-seq) desde el repositorio público de 10x Genomics a la plataforma en la nube de 10x Genomics, o entre entornos locales y la nube. 

Algunas de las más comúnes son:

## Descargar datos desde `10x Genomics Datasets` a tu computadora local

Dataset Ejemplo: 

**Peripheral blood mononuclear cells (PBMCs) from healthy humans**

Este dataset está compuesto por **4 donadores control (~20k células en total)**.

Dataset base: https://www.10xgenomics.com/datasets/5k_Human_Donor1_PBMC_3p_gem-x

## Descarga vía navegador

Descarga los archivos directamente desde el botón de descarga en la página oficial del dataset. Sin mayor complicación.

## Descarga vía línea de comandos (recomendado)
### Donor 1

```bash
# FASTQs
curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor1_PBMC_3p_gem-x_Multiplex/5k_Human_Donor1_PBMC_3p_gem-x_Multiplex_fastqs.tar

# Config file
curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor1_PBMC_3p_gem-x_Multiplex/5k_Human_Donor1_PBMC_3p_gem-x_Multiplex_config.csv
```

### Donor 2

```bash
curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor2_PBMC_3p_gem-x_Multiplex/5k_Human_Donor2_PBMC_3p_gem-x_Multiplex_fastqs.tar

curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor2_PBMC_3p_gem-x_Multiplex/5k_Human_Donor2_PBMC_3p_gem-x_Multiplex_config.csv
```

### Alternativa usando `wget`

```bash
wget https://cf.10xgenomics.com/archivo.fastq.tar
```

### Donor 3 y Donor 4

Repetir el procedimiento para las muestras restantes del experimento del donador 3 y 4:

- https://www.10xgenomics.com/datasets/5k_Human_Donor3_PBMC_3p_gem-x
- https://www.10xgenomics.com/datasets/5k_Human_Donor4_PBMC_3p_gem-x

Si descargaste archivos `.tar`:

```bash
tar -xvf archivo_fastqs.tar
```

## Carga y Descarga con CLI

### Descarga de 10x 10x Genomics Cloud CLI

La instalación depende del sistema operativo. Por ejemplo este es el comando de descarga de CLI para macOS

```bash
curl -f -o txg-macos-v4.0.0.zip https://cf.10xgenomics.com/cloud-cli/v4.0.0/txg-macos-v4.0.0.zip
unzip txg-macos-v4.0.0.zip
```

Instrucciones para Linux y Windows:
https://www.10xgenomics.com/support/software/cloud-analysis/latest/tutorials/CA-cloud-cli-documentation-for-mac#downloading-and-unpacking-47097c


## Autenticación

Al ejecutar la CLI por primera vez, deberás configurar tu token de acceso.

```bash
txg auth setup
```

También puedes obtenerlo desde tu proyecto en perfil de la cuenta -> Seguridad -> Token
https://cloud.10xgenomics.com/account/security

⚠️ No compartas tu access token públicamente.


## Subir archivos a 10x Genomics Cloud usando CLI

Ejemplo en macOS:

```bash
txg-macos-v4.0.0/txg files upload \
  --project-id TU_PROJECT_ID \
  ruta/a/fastqs/*
```

Ejemplo real:

```bash
txg-macos-v4.0.0/txg files upload \
  --project-id 7eYppMyRTh90r4Ai44csJ2g \
  scRNAseq/scrnaseq-workshop/data/10XGenomics_data/5k_Human_Donor4_PBMC_3p_gem-x_*
```

Observa que tienes que apuntar al direcorio donde descargaste CLI (txg) y al directorio donde estan los FASTQs, en mi caso CLI esta en `txg-macos-v4.0.0/txg` y mis FASTQs estan en `scRNAseq/scrnaseq-workshop/data/10XGenomics_data/5k_Human_Donor4_PBMC_3p_gem-x_*` 


### Confirmación de subida

El sistema mostrará:

- Número total de archivos
- Tamaño total (ej. 16.12 GB)
- Confirmación manual `[y/N]`

Presiona:

```bash
y
```

Recibirás un email cuando la carga finalice.

Para cancelar:

```bash
Ctrl + C
```


### Notas Importantes

En muchos análisis de expresión génica (GEX), los archivos I1 / I2 son opcionales en Cell Ranger.

Sin embargo, **no los elimines sin verificar el tipo de experimento**.


## Resumen del Flujo

```
10x Dataset
    ↓
Descarga FASTQs (curl/wget)
    ↓
Descompresión (.tar)
    ↓
Instalar 10x Cloud CLI
    ↓
Configurar access token
    ↓
Upload FASTQs
    ↓
Procesamiento con Cell Ranger Cloud
```

## Buenas Prácticas

- Verificar espacio en disco antes de descargar.
- Confirmar integridad con md5sum si está disponible.
- No compartir access tokens.
- Organizar directorios por donador.
- Documentar el projecto (ID) utilizado.

## Siguiente tema

- [Ir a - descarga de datos procesados en `Cell Ranger on the Cloud`](/docs/main_docs/day1/03b_download_10X_cloud.md)
- [Ir a - índice del taller](/docs/README.md#índice-del-taller)


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


© El Arkhe · MultiOmics