# Gestion de archivos en 10x Genomics Datasets a 10x Genomics Cloud 

Tenemos diferentes opciones para gestionar archivos desde la plataforma  de *10x Genomics Datasets* a la plataforma en la nube de *10x Genomics Cloud*, o entre entornos locales y la nube. 

Algunas de estas opciones son descarga directa desde el navegador, descarga por línea de comandos con `curl` o `wget`, y descarga con la CLI de 10x Genomics Cloud. 

Los siguientes pasos describen cómo realizar estas operaciones, incluyendo la carga de archivos FASTQ a 10x Genomics Cloud para su posterior procesamiento con Cell Ranger.

## 1) Descarga directa desde el navegador

Descargas los archivos desde `10x Genomics Datasets` a tu computadora local con la opcion de descarga del navegador. 

Usaremos el siguiente ejemplo:

>Dataset: [**Peripheral blood mononuclear cells (PBMCs) from healthy humans**](https://www.10xgenomics.com/datasets/5k_Human_Donor1_PBMC_3p_gem-x)

## 2) Descargar por línea de comandos con curl o wget
#### Donor 1

```bash
# FASTQs
curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor1_PBMC_3p_gem-x_Multiplex/5k_Human_Donor1_PBMC_3p_gem-x_Multiplex_fastqs.tar

# Config file
curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor1_PBMC_3p_gem-x_Multiplex/5k_Human_Donor1_PBMC_3p_gem-x_Multiplex_config.csv
```

#### Donor 2

```bash
curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor2_PBMC_3p_gem-x_Multiplex/5k_Human_Donor2_PBMC_3p_gem-x_Multiplex_fastqs.tar

curl -O https://cf.10xgenomics.com/samples/cell-exp/9.0.0/5k_Human_Donor2_PBMC_3p_gem-x_Multiplex/5k_Human_Donor2_PBMC_3p_gem-x_Multiplex_config.csv
```

#### Alternativa usando `wget`

```bash
wget https://cf.10xgenomics.com/archivo.fastq.tar
```

Si tus archivos estan comprimidos en `.tar`, descomprime con:

```bash
tar -xvf archivo_fastqs.tar
```

## 3) Descarga con Cloud CLI  

La descarga de 10x Genomics Cloud CLI depende del sistema operativo. En macOS, puede descargarse y descomprimirse desde la terminal:

Documentación oficial por sistema operativo:

- [macOS](https://www.10xgenomics.com/support/software/cloud-analysis/latest/tutorials/CA-cloud-cli-documentation-for-mac)
- [Linux](https://www.10xgenomics.com/support/software/cloud-analysis/latest/tutorials/CA-cloud-cli-documentation-for-linux)
- [Windows](https://www.10xgenomics.com/support/software/cloud-analysis/latest/tutorials/CA-cloud-cli-documentation-for-windows)

Por ejemplo, en macOS:

```bash
curl -f -o txg-macos-v4.3.0.zip https://cf.10xgenomics.com/cloud-cli/v4.3.0/txg-macos-v4.3.0.zip
unzip txg-macos-v4.3.0.zip
cd txg-macos-v4.3.0
```

Una vez **descargado y descomprimido**, puedes ejecutar la CLI desde el directorio que contiene el ejecutable `txg`.

Recuerda `txg` es el ejecutable de 10x Genomics Cloud CLI. 

**Tip:** Sí lo descargaste y no lo encuentras?

En MAC/Linux, puedes buscarlo en la terminal con:

```bash
find ~ -type f -name "txg" 2>/dev/null
````

En Windows, puedes buscarlo en el explorador de archivos con el nombre `txg.exe`
 

### Gestión de archivos con Cloud CLI

A continuación se presentan ejemplos de gestion de archivos con la CLI de 10x Genomics Cloud. 

Los ejemplos siguientes corresponden a macOS y Linux. En Windows, el ejecutable se llama `txg.exe`, lee cuidadosamente los ejemplos.

### Verificar la instalación y consultar la ayuda

Primero, verifica que versión instalaste y que la ayuda de comandos este disponible:

En **MAC/Linux**, desde el directorio que contiene el ejecutable `txg`, ejecuta:

```bash
./txg --version
./txg --help
```

**Tip:** También puedes añadirlo al `PATH` para ejecutarlo desde cualquier ubicación.

En **Windows**, utilizando PowerShell desde la carpeta que contiene el ejecutable, los comandos equivalentes son:

```powershell
.\txg.exe --version
.\txg.exe --help
```

### Configurar la autenticación

La primera vez que utilices la **CLI**, deberás configurar el token de acceso de tu cuenta de 10x Genomics Cloud.

El **token de acceso** autentica al usuario: indica quién realiza la operación y permite que `txg` se conecte a tu cuenta. Normalmente, se configura una sola vez.

```bash
./txg auth setup
```

El comando solicitará ingresar el token disponible en la sección de **seguridad** de la **cuenta de 10x Genomics Cloud**.

Para verificar que la autenticación funciona correctamente, ejecuta:

En MAC/Linux:
```bash
./txg auth verify
```

En Windows (PowerShell):
```powershell
.\txg.exe auth verify
```

> El token es una credencial personal. No lo compartas ni lo incluyas en capturas de pantalla.

### Identificar el `Project ID`

El **Project ID** determina en qué proyecto de 10x Genomics Cloud se realizará la operación. No es una credencial y es diferente para cada proyecto.

Puedes obtenerlo desde la interfaz web del proyecto o mediante la CLI:

```bash
./txg projects list
```

Para evitar escribirlo repetidamente, puedes guardarlo temporalmente en una variable de entorno:

```bash
export PROJECT_ID="####################"
```

Verifica el valor guardado:

```bash
echo "$PROJECT_ID"
```

**Tip:** La variable estará disponible mientras permanezca abierta esa sesión de la terminal. Si deseas conservarla para sesiones futuras, puedes añadir el comando `export` a `~/.zshrc` o `~/.bashrc`, según el shell que utilices.

**Importante**: Cuando creas un proyecto nuevo, aparecerá automáticamente en la lista de proyectos de tu cuenta porque está asociado. 

Sin embargo, para ejecutar una operación debes proporcionar explícitamente su Project ID:

Ejemplo de comando para subir archivos FASTQ a un proyecto específico:

En MAC/Linux:
```bash
./txg files upload --project-id PROJECT_ID ruta/a/los/FASTQ/
```

## Práctica: cargar archivos FASTQ a 10x Genomics Cloud

Desde el directorio que contiene `txg`, ejecuta:

En MAC/Linux:
```bash
./txg files upload \
  --project-id "$PROJECT_ID" \
  ~/ruta/a/los/FASTQ//10XGenomics_data/5k_Human_Donor1_PBMC_3p_gem-x_*
```

En Windows (PowerShell):
```powershell
.\txg.exe files upload `
  --project-id "$PROJECT_ID" `
  C:\ruta\a\los\FASTQ\5k_Human_Donor1_PBMC_3p_gem-x_*
```


El comando contiene tres componentes:

- `./txg`: ubicación del ejecutable de la CLI.
- `--project-id "$PROJECT_ID"`: proyecto de 10x Cloud que recibirá los archivos.
- `~/ruta/a/los/FASTQ/5k_Human_Donor1_PBMC_3p_gem-x_*`: ruta y patrón de los FASTQ que se cargarán.

Antes de ejecutar el comando, confirma que la variable corresponde al proyecto correcto:

```bash
echo "$PROJECT_ID"
```

También conviene confirmar la ruta a los archivos que se van a cargar:

```bash
ls ~/ruta/a/los/FASTQ/5k_Human_Donor1_PBMC_3p_gem-x_*
```

### Confirmar la carga

Antes de iniciar la transferencia, la CLI mostrará:

- el proyecto de destino;
- el número de archivos seleccionados;
- la lista de archivos;
- el tamaño total de la carga;
- la solicitud de confirmación `[y/N]`.

Para iniciar la carga, escribe:

```text
y
```

Para cancelar el proceso, presiona:

```text
Ctrl + C
```

10x Genomics enviará una notificación al correo asociado con la cuenta cuando la carga haya finalizado.

**Importante:** Para un análisis convencional de expresión génica, Cell Ranger utiliza principalmente los FASTQ correspondientes a `R1` y `R2`. La presencia y el uso de archivos adicionales, como `I1` o `I2`, dependen del producto, la preparación de la biblioteca y el flujo de secuenciación.

**No elimines archivos antes de confirmar el tipo de experimento y los requisitos del pipeline.**

## Resumen del flujo

```text
10x Genomics Dataset
        ↓
Descarga de los FASTQ
        ↓
Descompresión de los archivos descargados, si corresponde
        ↓
Descarga de 10x Genomics Cloud CLI
        ↓
Configuración del token de acceso
        ↓
Identificación del Project ID
        ↓
Carga de los FASTQ
        ↓
Procesamiento con Cell Ranger en 10x Genomics Cloud
```


### Buenas Prácticas

- Verificar espacio en disco antes de descargar.
- Confirmar integridad con md5sum si está disponible.
- No compartir access tokens.
- Organizar directorios por donador.
- Documentar el projecto (ID) utilizado.

### Siguiente tema

- [Ir a - descarga de datos procesados en `Cell Ranger on the Cloud`](/docs/03b_download_10X_cloud.md)
- [Ir a - índice del taller](./guia_curso.md)


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