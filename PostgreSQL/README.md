# Análisis de Riesgo Crediticio con PostgreSQL

Este módulo contiene la extracción, limpieza, transformación y análisis exploratorio de datos (EDA) realizado directamente en la base de datos PostgreSQL. El objetivo principal es evaluar la salud financiera de la cartera de créditos, identificar factores determinantes de la morosidad (*Bad Loan Ratio*) y proveer *insights* accionables para la toma de decisiones estratégicas.

---

## Objetivos del Análisis en SQL

* **Diagnosticar el Estado de la Cartera:** Calcular la tasa de morosidad general tanto en volumen de dinero como en cantidad de operaciones.
* **Evaluación de Factores de Riesgo:** Analizar el comportamiento del impago cruzando variables clave como el nivel de compromiso del ingreso (`loan_percent_income`), historial previo de mora (`cb_person_default_on_file`), tipo de vivienda y antigüedad laboral.
* **Segmentación y Scoring:** Detectar patrones de alto riesgo y casos atípicos (*outliers*) para proponer políticas de aprobación más estrictas.

---

## 📊 Principales Hallazgos de Negocio (*Insights*)

| Métrica / Variable | Resultado Obtenido | Diagnóstico & Impacto de Negocio |
| :--- | :--- | :--- |
| **Cartera Total Contratada** | **$312.32M USD** | Volumen total de capital originado en el portafolio analizado. |
| **Capital en Mora** | **$77.09M USD** | Capital expuesto a pérdida directa por impago (`loan_status = 1`). |
| **Tasa de Morosidad (por Monto)** | **24.68%** | **CRÍTICO:** Excede ampliamente el umbral de tolerancia habitual (3% - 5%). |
| **Tasa de Morosidad (por Cantidad)** | **21.82%** | **CRÍTICO:** Aproximadamente 1 de cada 5 clientes entra en mora. |
| **Monto vs. Cantidad** | **24.68% > 21.82%** | Los créditos que caen en mora corresponden, en promedio, a montos más elevados (*high ticket*). |

### 💡 Conclusiones Clave:
1. **Nivel de Compromiso del Ingreso (`loan_percent_income`):** Es el **predictor directo más sólido** del impago. Clientes que comprometen más del 30% de su sueldo presentan una tasa de mora drásticamente superior.
2. **Historial Previo de Mora (`cb_person_default_on_file`):** La probabilidad de caer en impago casi se duplica en clientes con antecedentes registrados (`'Y'`: ~37.8% de mora) frente a aquellos sin antecedentes (`'N'`: ~18.4% de mora).
3. **Antigüedad Laboral (`person_emp_length`):** No mostró una relación directa ni predictiva contra la morosidad; años de antigüedad en el empleo no garantizan por sí solos el pago de la deuda.

---

## 🛠️ Tecnologías y Funcionalidades de SQL Utilizadas

Para llevar a cabo las consultas se aplicaron técnicas avanzadas e intermedias de SQL:

* **Agregaciones y Filtros:** `GROUP BY`, `HAVING`, `WHERE` condicionales.
* **Lógica Condicional:** `CASE WHEN` para pivotear datos y categorizar rangos de riesgo dinámicamente.
* **Estructuras Avanzadas:** 
  * *Common Table Expressions* (`WITH / CTE`) para modularizar consultas complejas.
  * *Window Functions* (`ROW_NUMBER() OVER(PARTITION BY ... ORDER BY ...)`) para clasificar perfiles de riesgo y rankings.
* **Transformación de Datos:** Uso de *type casting* (`::DECIMAL`) y redondos (`ROUND`) para precisión en cálculos financieros.

---

## 📂 Estructura de Scripts de la Base de Datos

```text
├── sql/
│   ├── 01_schema_and_import.sql      # Creación de tabla 'credits' e importación de datos
│   ├── 02_eda_diagnostico_general.sql # Tasa de morosidad global y totales expuestos
│   ├── 03_analisis_riesgo_factores.sql # Evaluaciones por ingreso, vivienda e historial
│   └── 04_queries_avanzadas_ctes.sql   # Funciones de ventana, CTEs y detección de outliers
