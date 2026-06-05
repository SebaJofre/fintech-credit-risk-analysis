# Glosario de Términos: Fintech Credit Risk Analysis

## 1. Términos de Negocio y Riesgo Financiero
* **Default (Incumplimiento / Impago):** Situación en la que un cliente no cumple con la obligación legal de devolver el préstamo según el acuerdo. En nuestro dataset, se activa cuando el cliente lleva más de 90 días sin pagar.

* **Bad Loan Ratio (Tasa de Morosidad):** El porcentaje de préstamos en estado de `Default` o mora crítica respecto al total del capital colocado. Es el `KPI` de control de riesgo más importante del proyecto.

* **Good Loan vs. Bad Loan:** Clasificación binaria de la cartera. Un `Good Loan` es un crédito activo o liquidado al día; un `Bad Loan` es un crédito con alta probabilidad de pérdida financiera.

* **DTI (Debt-to-Income Ratio / Ratio Deuda-Ingreso):** Métrica que mide qué porcentaje de los ingresos brutos del cliente está comprometido para pagar deudas. Un `DTI` elevado indica sobreendeudamiento.

* **Credit Score (Puntuación de Crédito):** Indicador numérico que evalúa la solvencia de una persona y su probabilidad de pagar sus deudas a tiempo, basado en su historial financiero.

* **Loan Intent (Propósito del Préstamo):** La razón declarada por el cliente para solicitar el financiamiento (ej. consolidación de deudas, educación, gastos médicos). Ayuda a segmentar el riesgo por comportamiento.

* **Interest Rate (Tasa de Interés):** El precio que cobra la FinTech por prestar el dinero, expresado como un porcentaje del capital por período.

* **Mitigación del Riesgo:** Conjunto de estrategias y reglas de negocio automatizadas basadas en datos para reducir las pérdidas financieras antes de que ocurra el desembolso.
---

## 2. Datos y Modelado Relacional (PostgreSQL)

* **Esquema en Estrella (Star Schema):** Enfoque de modelado de datos para analítica donde una tabla central de **Hechos** se conecta con múltiples tablas de **Dimensiones** mediante claves relacionales. Es la estructura óptima para optimizar el rendimiento en Power BI.
* **Tabla de Hechos (Fact Table):** Tabla central que almacena las métricas cuantitativas, numéricas y transaccionales del negocio (en nuestro caso, `Fact_Prestamos`). Contiene las llaves foráneas para conectar con las dimensiones.
* **Tabla de Dimensiones (Dimension Table):** Tablas que contienen los atributos contextuales, de texto o descriptivos de los hechos (ej. `Dim_Cliente`, `Dim_Calendario`). Permiten filtrar, agrupar y segmentar los datos analíticos.
* **CTE (Common Table Expression):** Estructura en SQL que permite definir un conjunto de resultados temporales con nombre, mejorando drásticamente la legibilidad, orden y mantenimiento de queries complejas frente a las subconsultas tradicionales.
* **Window Functions (Funciones de Ventana):** Funciones analíticas de SQL (como `LEAD`, `LAG`, `RANK`, o `PARTITION BY`) que realizan cálculos a través de un conjunto de filas de la tabla que están directamente relacionadas con la fila actual, sin colapsar el dataset.
* **DDL (Data Definition Language):** Sentencias de SQL utilizadas para definir, modificar o destruir la estructura de los objetos de la base de datos (ej. `CREATE TABLE`, `ALTER TABLE`, `DROP`).
*   **Normalización de Datos:** El proceso técnico de organizar las columnas y tablas de una base de datos para asegurar que las dependencias de los datos tengan sentido lógico y para reducir la redundancia de datos planos de archivos origen (CSV).

---

## 3. Business Intelligence y Visualización (Power BI)

* **DAX (Data Analysis Expressions):** El lenguaje de fórmulas y consultas nativo de Power BI utilizado para crear cálculos personalizados, métricas avanzadas y manipulación dinámica de datos.
* **Medidas Explícitas (Explicit Measures):** Métricas de negocio escritas manualmente en código DAX (ej. usando `SUM` o `CALCULATE`). Garantizan el control del rendimiento y la escalabilidad del reporte frente a las agregaciones automáticas.
* **Time Intelligence (Inteligencia de Tiempo):** Funciones de DAX especializadas en realizar cálculos acumulativos y comparativos a lo largo del tiempo, como cálculos de mes a la fecha (*MTD*), año a la fecha (*YTD*), o variaciones mensuales (*MoM%*).
* **Filtro Cross-Filtering (Filtrado Cruzado):** El comportamiento interactivo nativo en un reporte de Power BI donde al hacer clic en un elemento de un gráfico, automáticamente se segmentan y actualizan visualmente el resto de los elementos del dashboard.
