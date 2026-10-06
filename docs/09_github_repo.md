# Pasos para clonar el repositorio del taller

Clonaremos el repositorio del curso desde GitHub (remoto) a tu computadora local.  
Trabajaremos siempre desde esta copia local durante todo el taller.

### Paso 1. Abrir la terminal

Abre la terminal de tu sistema:

- macOS → Terminal
- Linux → Terminal
- Windows → Git Bash o WSL


### Paso 2. Navegar al directorio de trabajo

Muévete al directorio donde quieres guardar el proyecto.  
Por ejemplo:

```bash
cd ~/Documents
```

### Paso 3: Clonar el repositorio del taller

#### Opción A. Clonar usando HTTPS
```bash
git clone https://github.com/el-arkhe/scrnaseq-workshop_portal.git
```

#### Opcion B. Clonar usando SSH

```bash
git clone git@github.com:el-arkhe/scrnaseq-workshop_portal.git
```
Este método requiere que tengas configurada una llave SSH en GitHub.

Git puede solicitar:
- Usuario de GitHub
- Token de acceso personal (PAT) 

Puedes generar un token siguiendo los pasos descritos aquí: https://github.com/settings/tokens

### Paso 4. Verificar que todo se descargó correctamente

Entrar al durectorio del proyecto y listar su contenido:

```bash
cd scrnaseq-workshop_portal
ls
```

Deberás ver directorios simlares a los siguiente:
- docs
- scripts
- data
- environment

**Notas importantes**

- Si git clone falla con SSH, usa la opción HTTPS.
- Todos los scripts del taller deben ejecutarse desde la raíz del proyecto.
- No modifiques la estructura de carpetas.
- Para actualizar el repositorio durante el taller, utiliza:
```bash
git pull
```

---

### Comandos básicos que usamos durante el taller

```bash
git clone   # Clonar un repositorio
git pull    # Actualizar el repositorio
git status  # Ver el estado del repositorio
git add     # Preparar cambios
git commit  # Guardar cambios
git push    # Subir cambios a GitHub
```
---

### ¡Felicidades! Tu clone esta listo. 

Ahora puedes ...

- [Preparar mí entorno de desarrollo](/docs/software_setup.md)

- [Comenzar día 1: Introducción a scRNA-seq y procesamiento con Cell Ranger](/docs/main_docs/day1/01_introduccion_sc_rnaseq.md)

- [Ir al índice del taller](/docs/README.md)

---

### Recursos de consulta

- Documentación oficial de Git:  
  https://git-scm.com/docs

- GitHub Docs – Clonar un repositorio:  
  https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository

- GitHub Docs – Generar una llave SSH:  
  https://docs.github.com/en/authentication/connecting-to-github-with-ssh

- GitHub Docs – Crear un Personal Access Token (PAT):  
  https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

- Git Cheat Sheet (resumen de comandos básicos):  
  https://education.github.com/git-cheat-sheet-education.pdf


---

CSC. Abril, 2026
