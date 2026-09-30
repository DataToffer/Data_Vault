# CompluBeer Snowflake BI

Caso docente reproducible para trabajar el ciclo de vida del dato con Snowflake, SQL y Tableau a partir de una empresa ficticia: **CompluBeer**.

El objetivo del caso es que el alumnado trabaje un flujo analítico completo, desde la carga del dato bruto hasta la construcción de una capa preparada para análisis y visualización.

## Serie: Modelado Medallion con CompluBeer

El caso se desarrolla capa a capa:

```text
BRONZE -> SILVER -> GOLD -> TABLEAU
```

La primera entrega está centrada en la capa **BRONZE**:

- carga de CSV;
- creación de tablas RAW;
- validación inicial;
- trazabilidad;
- análisis exploratorio previo a la transformación.

## Estructura publicada

```text
projects/complubeer-snowflake-bi/
├── README.md
├── sql/
│   ├── 00_bronze_setup_load.sql
│   └── 01_analisis_exploratorio_bronze.sql
└── linkedin/
    └── README_carrusel_bronze_v4.md
```

## Nota sobre el carrusel

El carrusel visual resume la lógica de trabajo. El repositorio conserva el SQL de referencia para que el caso pueda reproducirse y ampliarse en las siguientes capas del modelo Medallion.

## Idea didáctica

Bronze no es una papelera. Es la capa donde se preserva el dato, se mantiene la trazabilidad y se diagnostican los problemas que deberán resolverse después en Silver.

Si el dato se carga mal, el modelo nace mal. Si no se entiende la granularidad, los KPIs no cuadran. Si no se detectan inconsistencias, el dashboard puede contar una historia equivocada.
