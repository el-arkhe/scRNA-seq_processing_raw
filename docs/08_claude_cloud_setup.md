
# Guía básica: Configuración de 10x Genomics Cloud con Claude Desktop

## 1. Objetivo

Configurar la interfaz basada en prompts (*prompt-based interface*) de **10x Genomics Cloud** para interactuar con la plataforma utilizando instrucciones en lenguaje natural desde **Claude Desktop**.

Esta conexión utiliza el protocolo **Model Context Protocol (MCP)**, que permite a Claude acceder a herramientas de 10x Cloud para consultar proyectos, administrar archivos y configurar análisis con Cell Ranger.

> **Importante:** Claude funciona como interfaz de interacción. Los pipelines bioinformáticos se ejecutan en la infraestructura de 10x Genomics Cloud.

## 2. Requisitos previos

- Una cuenta activa de [10x Genomics Cloud](https://cloud.10xgenomics.com/).
- Un token de acceso (*Access Token*) de 10x Cloud.
- [Claude Desktop](https://claude.ai/download) instalado en tu computadora.

## 3. Configuración paso a paso

### Paso 1. Obtener el token de acceso de 10x Cloud

1. Ingresa a [10x Genomics Cloud](https://cloud.10xgenomics.com/).
2. Inicia sesión con tu cuenta.
3. Accede a **Account Settings**.
4. Abre la sección **Security**.
5. Localiza tu **Cloud Access Token** y cópialo. Si todavía no tienes uno, créalo siguiendo las opciones disponibles.

Este token permite autenticar las operaciones realizadas desde Claude Desktop.

> **Seguridad:** El token es una credencial privada. No lo compartas en GitHub, capturas de pantalla ni conversaciones públicas.

### Paso 2. Instalar Claude Desktop

1. Ingresa a [Claude Desktop](https://claude.ai/download).
2. Descarga la versión correspondiente a tu sistema operativo (macOS o Windows).
3. Instala la aplicación.
4. Abre Claude Desktop e inicia sesión.

Para esta práctica utilizaremos la interfaz gráfica de Claude Desktop; no es necesario instalar Claude Code.

### Paso 3. Instalar la extensión 10x Genomics Cloud MCP

Existen dos alternativas.

**Opción A. Instalación desde Claude Desktop (recomendada)**

1. Abre Claude Desktop.
2. Accede a **Settings → Extensions**.
3. Selecciona **Browse extensions**.
4. Busca `10x Genomics Cloud`.
5. Haz clic en **Install**.

**Opción B. Instalación manual**

Si la extensión no aparece en el catálogo:

1. Accede a [10x Genomics Cloud MCP — GitHub Releases](https://github.com/10XGenomics/cloud-mcp/releases).
2. Descarga el archivo `.mcpb` de la versión más reciente.
3. Abre el archivo con doble clic o arrástralo a **Settings → Extensions** en Claude Desktop.
4. Confirma la instalación.

### Paso 4. Configurar la conexión

Una vez instalada la extensión:

1. Abre la configuración de **10x Genomics Cloud MCP** en Claude Desktop.
2. Localiza el campo **10x Cloud Access Token**.
3. Introduce el token obtenido en el Paso 1.
4. Guarda la configuración siguiendo las indicaciones.
5. Cambia el estado de la extensión de **Disabled** a **Enabled**.

La extensión debería quedar disponible para utilizarse en las conversaciones de Claude.

> **Nota:** El token utilizado para Cloud CLI (`txg`) corresponde al mismo sistema de autenticación de 10x Cloud, pero debe configurarse también en la extensión MCP.

## 4. Verificar que la conexión funciona

Abre una nueva conversación en Claude Desktop y escribe:

**Prompt 1. Verificar herramientas disponibles**

```text
What 10x Cloud tools do you have access to?
```

Claude debería mostrar las herramientas de 10x Genomics Cloud a las que tiene acceso.

**Prompt 2. Consultar proyectos**

```text
List all the projects available in my
10x Genomics Cloud account.

Show their names and project IDs.
Do not modify any resources.
```

**Prompt 3. Consultar referencias genómicas**

```text
List the pre-built human transcriptome
references available in 10x Genomics Cloud.

Do not create or run any analyses.
```

### Resultado esperado

Si la configuración es correcta, Claude podrá consultar información de tu cuenta mediante las herramientas MCP.

Para verificar los resultados, puedes abrir [10x Genomics Cloud](https://cloud.10xgenomics.com/) y comparar la información.

## 5. Configuración opcional: acceso a archivos locales

Para facilitar operaciones que requieren archivos almacenados en la computadora, 10x Genomics recomienda considerar la extensión **Filesystem**.

Esta extensión permite a Claude acceder a directorios locales autorizados.

Para configurarla:

1. Abre **Settings → Extensions** en Claude Desktop.
2. Busca la extensión **Filesystem**.
3. Instálala y habilítala.
4. Configura únicamente las carpetas a las que deseas permitir acceso.

Esta configuración puede ser útil cuando necesitemos cargar archivos FASTQ o CSV desde nuestra computadora.

> **Importante:** Autoriza solamente los directorios necesarios para la práctica.

## 6. Problemas frecuentes

| Problema | Posible solución |
|---|---|
| Claude no reconoce las herramientas de 10x Cloud | Verificar que la extensión esté instalada y habilitada. |
| Error de autenticación | Revisar el token configurado en la extensión. |
| No aparecen los proyectos esperados | Comprobar que el token corresponda a la cuenta correcta. |
| Claude no puede acceder a archivos locales | Revisar los permisos y directorios autorizados en Filesystem. |
| La extensión no aparece en el catálogo | Intentar la instalación manual mediante el archivo `.mcpb`. |

Si los problemas persisten, consulta la documentación oficial o contacta a `support@10xgenomics.com`.

## 7. Lista de verificación final

Antes de continuar con el análisis de datos scRNA-seq:

- Puedo iniciar sesión en 10x Genomics Cloud.
- Tengo Claude Desktop instalado y funcionando.
- Instalé la extensión 10x Genomics Cloud MCP.
- Configuré correctamente mi token de acceso.
- La extensión está habilitada.
- Claude reconoce las herramientas de 10x Cloud.
- Puedo consultar mis proyectos mediante prompts.

**¡Configuración completada!**

En la siguiente práctica utilizaremos prompts para preparar un análisis de datos scRNA-seq mediante `cellranger count`.

---

## Referencias

**10x Genomics. Prompt-Based Interface for the 10x Genomics Cloud.** Guía oficial de instalación, configuración y ejemplos de prompts.  
https://www.10xgenomics.com/support/software/cloud-analysis/latest/tutorials/cloud-mcp-server

**10x Genomics. Cloud Analysis Documentation.** Documentación general de la plataforma, productos compatibles y ejecución de análisis.  
https://www.10xgenomics.com/support/software/cloud-analysis/latest

---

© El Arkhe · MultiOmics