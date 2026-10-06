# Modos de ejecución de `Cell Ranger`

Cell Ranger puede ejecutarse de diferentes formas dependiendo de la infraestructura disponible:

- Local
- HPC
- Cloud

Cada modo tiene sus ventajas y limitaciones, y la elección depende de factores como:
- Tamaño del dataset
- Recursos computacionales disponibles
- Presupuesto
- Familiaridad con la línea de comandos o interfaces gráficas

## Cell Ranger en Galaxy

Es posible ejecutar `Cell Ranger` dentro de **Galaxy**, pero con consideraciones importantes:

- Cell Ranger es software propietario de 10x Genomics
- Las instancias públicas de Galaxy **no siempre lo incluyen por defecto**
- Su disponibilidad depende de licencias y recursos locales

Ejemplo:
- Galaxy Australia ofrece Cell Ranger bajo **acceso controlado** mediante solicitud específica.

Como alternativa dentro de entornos Galaxy, es común utilizar herramientas open-source, como **STARsolo**:

- Requiere FASTQ (R1, R2, I1)
- Produce salidas compatibles con el formato de Cell Ranger

## Referencias y recursos adicionales

- Modos de ejecución Cell Ranger:  
  https://cyntsc.github.io/single_cell_RNA-seq/RunModes/


## Siguiente tema

- [Ir a - descarga y carga de archivos FASTQ desde `10x Genomics Datasets` a `10x Genomics on the Cloud`](/docs/main_docs/day1/03a_upload_files.md)
- [Ir a - índice del taller](/docs/README.md#índice-del-taller)

---

© El Arkhe · MultiOmics