# Selección de datos Chromium single-cell de 10x Genomics

Las tecnologías Chromium single-cell de 10x Genomics permiten perfilar la expresión génica a nivel de célula individual utilizando distintas químicas, diseñadas para responder a preguntas biológicas y restricciones experimentales específicas. 

A continuación se describen las más comunes: **Universal 3′**, **Universal 5′** y **Chromium Flex**.

## Universal 3′ Gene Expression

Esta química captura el extremo 3′ del mRNA mediante poly-A capture, generando un conteo de UMIs por gen.

Características principales:

* Transcriptoma completo (gene-level)
* Captura basada en cola poly-A
* No permite distinguir isoformas
* No recupera secuencias completas de TCR/BCR (*)

Uso recomendado
* Atlas celulares
* Identificación de tipos y estados celulares
* Análisis de clustering, integración y expresión diferencial

Es la opción estándar y más utilizada en estudios de scRNA-seq.

(*)TCR y BCR se refieren a los receptores de los linfocitos, es decir, las moléculas que usan las células del sistema inmune para reconocer antígenos

## Universal 5′ Gene Expression

Esta química captura el extremo 5′ del mRNA, manteniendo la posibilidad de realizar perfiles inmunológicos mediante la recuperación de secuencias completas de TCR y BCR.

Características principales:

* Transcriptoma completo
* Captura basada en poly-A
* El kit permite medir la expresión génica general y mapear los receptores inmunitarios TCR/BCR al mismo tiempo en cada célula

Uso recomendado
* Inmunología
* Cáncer
* Estudios de clonalidad - esto define el clonotipo real y funcional sin errores de combinación aleatoria
* Integración de expresión génica con identidad del receptor inmune

Es ideal cuando se necesita combinar expresión génica + información inmunológica.

## Chromium Flex (Fixed RNA Profiling)

Chromium Flex es un enfoque orientado, basado en sondas, diseñado para trabajar con muestras fijadas.

Flex toma las células vivas y les aplicas un fijador (formaldehído) de inmediato. El fijador crea enlaces químicos que "congelan" instantáneamente la estructura celular y el ARN en su estado biológico exacto. La célula ya no está viva (no respira ni cambia), pero su perfil transcriptómico quedó perfectamente encapsulado y protegido de la degradación.

Características principales:

* No depende de poly-A - probe-based en lugar de captura por poli-T
* Utiliza paneles de genes predefinidos
* Compatible con células o núcleos
* Alta reproducibilidad entre lotes

Limitaciones
* No captura el transcriptoma completo, usa sondas específicas para genes de interés: 18,000 genes humanos y 20,000 genes de ratón
* El análisis depende del diseño del panel

Uso recomendado
* Muestras clínicas - desactivando agentes patógenos y preservando la integridad del RNA
* Compatibilidad con tejidos difíciles - permite obtener transcriptomas de alta calidad a partir de muestras en tejidos archivados en FFPE (bloques de parafina) o células extremadamente frágiles que no sobrevivirían a una disociación en vivo
* Biobancos - preservación a largo plazo
* Estudios longitudinales - permite fijar y almacenar las muestras de diferentes puntos de tiempo para secuenciarlas juntas en una misma corrida (multiplexación de hasta 16 muestras). Garantiza comparaciones temporales exactas y reduce drásticamente los costos
* Situaciones donde la logística o preservación de la muestra es crítica - elimina la necesidad de tener un instrumento Chromium o un secuenciador al lado del quirófano o del sitio de colecta de campo


<p align="center">
  <img src="/docs/images/cell_ranger_universal_3_5_methods.png" alt="cell ranger universal transcriptome methods">
</p>

## Comparación general

| Característica | Universal 3′ | Universal 5′ | Flex |
|---------------|--------------|--------------|------|
| Tipo de captura | 3′ end | 5′ end | Sondas |
| Poly-A | Sí | Sí | No |
| Transcriptoma completo | Sí | Sí | No |
| TCR/BCR | No | Sí | No |
| Muestras fijadas | No | No | Sí |
| Enfoque | Descubrimiento | Inmunología | Orientado / clínico |


### Guía rápida de decisión

La selección de la química (Universal 3′, Universal 5′ o Flex) define cómo se captura el RNA, mientras que las “Additional applications” (proteínas, multiplexing, CRISPR, throughput) determinan qué capas adicionales de información estarán disponibles para el análisis.

Como guía básica de seleccion inicial puedes preguntarte:

* Quiero explorar el transcriptoma completo → `Universal 3′`
* Quiero transcriptoma + clonotipos inmunes → `Universal 5′`
* Trabajo con muestras fijadas o clínicas → `Chromium Flex`


## Siguiente tema
- [Ir a - Comprendiendo las categorías de datos en 10x Genomics Datasets](/docs/03a_10Xgenomics_categories.md)
- [Ir a - índice del taller](/docs/README.md#índice-del-taller)

## Referencias y recursos adicionales

- Chromium Single Cell 3′ Gene Expression
    Documentación técnica de la química 3′, captura poly-A y casos de uso.
    https://www.10xgenomics.com/products/single-cell-gene-expression

-  Chromium GEM-X Single Cell 3' v4 Gene Expression User Guide
    https://cdn.10xgenomics.com/image/upload/v1725314293/support-documents/CG000731_ChromiumGEM-X_SingleCell3v4_UserGuide_RevB.pdf

- Chromium Single Cell 5′ Gene Expression & Immune Profiling
    Descripción de la química 5′ y su integración con V(D)J sequencing (TCR/BCR).
    https://www.10xgenomics.com/products/single-cell-immune-profiling

- Chromium Single Cell Fixed RNA Profiling (Flex)
    Descripción oficial del enfoque targeted basado en sondas y muestras fijadas.
    https://www.10xgenomics.com/products/flex-gene-expression

---

© El Arkhe · MultiOmics
