# Análisis de Riesgo Crediticio de una FinTech

## Objetivo del Proyecto.
Determinar los segmentos tomadores de préstamos que representan mayores riesgos para la compañía.

Se busca realizar un análisis que permita determinar qué segmentos es el más propenso a no pagar los créditos. Esto permitirá denegarles prestamos a aquellos segmentos específicos.

En palabras sencillas, es crear un sistema de analítica inteligente que le permita a la empresa seguir prestando dinero para crecer, pero bloqueando o evitando automáticamente a los clientes que tienen una alta probabilidad de no pagar, ahorrando millones en pérdidas.

---

## Herramientas a utilizar:
1. `Microsoft Excel`: Utilizado para el prototipado rápido, limpieza manual inicial y validación de hipótesis de negocio mediante tablas dinámicas y fórmulas.
2. `Python (Pandas)`: El motor de automatización para la auditoría inicial del dataset y la aplicación de algoritmos de imputación de datos faltantes.
3. `PostgreSQL`: La base de datos relacional encargada de estructurar los datos limpios bajo un esquema sólido, optimizar consultas pesadas y almacenar vistas lógicas de negocio.
4. `Power BI`: La herramienta de Business Intelligence para conectar la base de datos de PostgreSQL y diseñar el dashboard de control para la toma de decisiones directivas.

---

## Origen y Procedencia de los Datos (Data Sourcing)

Los datos transaccionales de préstamos utilizados en este proyecto son de acceso público y han sido obtenidos de la plataforma `Kaggle`:

* **Fuente del Dataset Principal:** [Kaggle - Credit Risk Dataset por Laotse](https://www.kaggle.com/datasets/laotse/credit-risk-dataset)
* **Volumen de Datos:** 32,581 registros y 12 variables financieras y demográficas.
* **Datos de Negocio Adicionales (Metas Financieras):** Adicionalmente, se integra un control de presupuestos mensuales simulado en **Microsoft Excel** para enriquecer el análisis comparativo del rendimiento del negocio en Power BI.

---

## Preguntas de Negocio a Responder

**1. ¿Cuál es la Tasa de Morosidad (Bad Loan Ratio) y cuánto dinero está costando?**
   
Se necesita saber si se esta por encima del límite de peligro del negocio (Ej. más de un 5% de pérdidas) y cuántos millones de dólares representan los préstamos que ya se dan por perdidos.

**2. ¿Qué perfil de cliente es el más peligroso para la empresa?**

Se pretende descubrir qué variables aumentan el riesgo. Por ejemplo: ¿Los usuarios que alquilan vivienda y tienen ingresos menos de $30.000 al año tienen una tasa de impago inaceptable? Si la respuesta es afirmativa se deben modificar las reglas de aprobación de créditos.

**3. ¿Para qué se usa el dinero que no regresa?**

Se analizará el propósito del préstamos (loan intent). Por ejemplo: Si se determina que los créditos solicitados para la "Gastos Médicos" fallan el triple que los de "Educación".

**4. ¿Se está cobrando el interés correcto según el riesgo del cliente?**

Es importante dar respuesta a esta pregunta porque en finanzas, a mayor riesgo, mayor tase de interés. Se debe comprobar que si la FinTech le está cobrando una tasa más alta a los clientes con peor historial, o si se esta cometiendo el error de cobrarle lo mismo a todos.

**5. ¿Cómo va el rendimiento del mes frente a las metas que se plantea la empresa?**

Se cruzan los datos reales con las metas mensuales para ver si se esta cumpliendo con el presupuesto de colocación sin disparar la morosidad

Para conocer en detalle los conceptos financieros y técnicos utilizados en este proyecto, consulta el [Glosario de Términos (GLOSARIO.md)](./GLOSARIO.md).

---

## Análisis de Datos en Microsoft Excel

Se realiza un primer análisis en Excel para aplicar un proceso ETL (Extract, Transform and Loan) de los datos, que permita comprender la estructura de la base de datos y obtener respuestas concisas y de calidad.

El archivo [credit_risk_dataset.xlsx](./MS%20EXCEL/credit_risk_dataset.xlsx) consta de 4 hojas:

**1. credit_risk_dataset:** es la base de datos descargada, sin transformar.

**2. About Dataset:** esta hoja contiene una tabla con la información de las columnas de la BD, que le permite al usuario realizar consultas.

**3. Working Sheet:** Es la hoja contenedora de la BD, a la cual se le ha realizado un proceso ETL, para luego trabajar con la misma.

**4. Working Analysis:** Hoja que contiene el análisis de datos financieros. La misma esta compuesta por tablas dinámicas, gráficos y cuadros de texto con la explicación e información secuencial del análisis realizado.

---

## Análisis en Python

En esta etapa de desarrollo, se utilizó **Python (Pandas & Jupyter Notebooks)** para diseñar un proceso automatizado y reproducible de auditoría, diagnóstico y limpieza pesada sobre el dataset original. El objetivo principal fue garantizar la calidad y la integridad física de los datos antes de su almacenamiento relacional.

El contenido detallado de esta fase se encuentra en [Python/README.md](./Python/README.md) y consta de:

* **1_exploracion_y_limpieza.ipynb:** Cuaderno de Jupyter donde se documenta el flujo de ingeniería de datos:
  * **Auditoría de Calidad:** Diagnóstico preliminar que detectó valores nulos críticos y datos físicamente imposibles (valores atípicos como una edad de 144 años o una antigüedad laboral de 123 años).
  * **Imputación de Datos:** Sustitución metodológica de valores nulos mediante el uso de la mediana para la antigüedad y el promedio agrupado por calificación de riesgo (`loan_grade`) para las tasas de interés.
  * **Exportación de Producción:** Generación del archivo unificado `credit_risk_dataset_clean.csv`, 100% libre de nulos y atípicos, listo para producción.

---

## Modelado y Análisis Estadístico en PostgreSQL

Una vez depurada la información, se migró el pipeline a **PostgreSQL** para simular la arquitectura de datos relacional que utilizaría la FinTech en un entorno real. En esta fase, el enfoque cambió de la limpieza algorítmica al modelado estructurado de base de datos y la optimización de consultas estadísticas a gran escala.

El contenido detallado de esta fase se encuentra en [PostgreSQL/README.md](./PostgreSQL/README.md) y abarca:

* **Esquema de Producción:** Creación de la tabla física `credits` con restricciones de integridad, asignación de llaves primarias (`PRIMARY KEY` autogeneradas mediante `SERIAL`) y definición precisa de tipos de datos financieros (como `DECIMAL` para cálculos exactos de tasas e ingresos).
* **Vistas de Negocio (`VIEW`):** Creación de vistas lógicas parametrizadas (como `v_credits_age_groups`) para simplificar el acceso a datos segmentados por rango etario sin duplicar información en disco.
* **Consultas de Control e Indicadores:** Desarrollo de scripts de análisis avanzado en SQL para calcular de forma agregada las tasas de morosidad global, volúmenes de impago y cruce analítico de perfiles de riesgo mediante funciones de agregación y agrupamientos eficientes.

---
