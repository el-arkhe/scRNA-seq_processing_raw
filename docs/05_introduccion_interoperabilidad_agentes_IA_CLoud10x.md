# Introducción: Procesamiento de datos scRNA-seq mediante prompts e IA

## 1. ¿Qué es la interfaz basada en prompts de 10x Genomics Cloud?

**10x Genomics Cloud** permite ejecutar pipelines de análisis de datos single-cell RNA-seq (scRNA-seq) mediante una interfaz web o utilizando comandos desde una terminal (Cloud CLI).

Adicionalmente, ofrece una **interfaz basada en prompts**, que permite interactuar con la plataforma utilizando instrucciones escritas en lenguaje natural, sin necesidad de construir manualmente cada comando.

Esta funcionalidad integra tres componentes:

- **Claude Desktop:** aplicación de inteligencia artificial que interpreta nuestras instrucciones.
- **Model Context Protocol (MCP):** protocolo que permite conectar Claude con herramientas y servicios externos.
- **10x Genomics Cloud MCP Server:** proporciona las herramientas necesarias para que Claude interactúe con los proyectos, archivos y análisis de nuestra cuenta de 10x Cloud.

### ¿Cómo funciona?

El usuario escribe una instrucción (*prompt*) → Claude interpreta la solicitud → utiliza las herramientas del servidor MCP → 10x Cloud ejecuta la operación solicitada → Claude comunica los resultados.

> **Importante:** Claude no sustituye a Cell Ranger. Los análisis bioinformáticos continúan ejecutándose mediante los pipelines de 10x Genomics Cloud.

## 2. ¿Qué podemos hacer mediante prompts?

La interfaz permite realizar diferentes operaciones:

| Operación | Ejemplo |
|---|---|
| Gestionar proyectos | Crear proyectos y consultar los existentes |
| Explorar archivos | Listar archivos FASTQ disponibles |
| Transferir datos | Subir archivos a 10x Cloud |
| Configurar análisis | Preparar ejecuciones de Cell Ranger `count` o `multi` |
| Ejecutar pipelines | Iniciar análisis en la nube |
| Supervisar procesos | Consultar el estado de ejecución |
| Recuperar resultados | Descargar archivos de salida |
| Explorar métricas | Solicitar ayuda para interpretar resultados de QC |

Algunas operaciones, como cancelar o eliminar análisis, todavía requieren utilizar directamente la interfaz web de 10x Cloud.

## 3. ¿Qué información debe incluir un buen prompt?

Para obtener respuestas precisas, es importante proporcionar información suficiente sobre los datos y el análisis solicitado.

**Elementos recomendados:**

1. **Datos biológicos:** especie, tipo de muestra (células o núcleos) y condiciones experimentales.
2. **Tecnología:** producto 10x Genomics, modalidad y química utilizada.
3. **Archivos de entrada:** ubicación de FASTQ y archivos adicionales.
4. **Pipeline:** `count`, `multi` o `aggr`, según el experimento.
5. **Parámetros:** referencia genómica, versión del pipeline y configuraciones específicas.
6. **Objetivo:** describir claramente qué operación esperamos realizar.

Cuando desconocemos algún parámetro, podemos solicitar que Claude explique las alternativas y recomiende una configuración con base en la documentación oficial.

## 4. Buenas prácticas al utilizar agentes de IA

- **Ser específicos:** describir claramente los datos y el resultado esperado.
- **Trabajar iterativamente:** comenzar con instrucciones sencillas y agregar complejidad progresivamente.
- **Solicitar explicaciones:** pedir que Claude justifique la selección de pipelines y parámetros.
- **Verificar las operaciones:** comprobar los proyectos, archivos y resultados directamente en 10x Cloud.
- **Validar las recomendaciones:** contrastar la información técnica con la documentación oficial.
- **Confirmar antes de ejecutar:** revisar parámetros y posibles costos de procesamiento antes de iniciar análisis.

> La IA facilita la interacción con herramientas bioinformáticas, pero **la responsabilidad de verificar los parámetros, la calidad de los datos y la interpretación científica permanece en el usuario**.

## 5. Primera práctica: interactuar con 10x Cloud mediante prompts

**Objetivo:** familiarizarnos con las herramientas disponibles en Claude Desktop y aprender a consultar información de nuestra cuenta de 10x Cloud.

Antes de comenzar, debemos contar con:

- Una cuenta activa de 10x Genomics Cloud.
- Un token de acceso configurado.
- Claude Desktop instalado.

## Siguiente tema

- [Ir a - Interoperabilidad entre 10x Cloud and Claude agent](/docs/06_interoperabilidad_Cloud_CLI_AI.md)
- [Ir a - índice del taller](./guia_curso.md)

## Referencias

[Prompt-Based Interface for the 10x Genomics Cloud](https://www.10xgenomics.com/support/software/cloud-analysis/latest/tutorials/cloud-mcp-server)

---

© El Arkhe · MultiOmics