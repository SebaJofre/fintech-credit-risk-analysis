# Módulo de Visualización e Indicadores KPI (Power BI)

Este repositorio contiene el desarrollo del proyecto de análisis, procesamiento de datos y diseño del **Dashboard Ejecutivo de Riesgo Crediticio** en **Power BI**, orientado al monitoreo de la morosidad, evaluación del scoring crediticio y perfilamiento de clientes.

---

## Resumen del Proyecto

El objetivo principal de este informe es evaluar la salud de la cartera de créditos, identificar los factores de mayor riesgo de impago (segmentados por destino del crédito, tipo de vivienda, nivel de ingresos y scoring) y monitorear los indicadores clave de desempeño (KPIs) para la toma de decisiones financieras.

---

## Resumen del Flujo de Trabajo

El proceso de construcción del reporte se estructuró en las siguientes etapas clave:

1. **Carga e Ingesta de Datos:** Exportación del dataset procesado desde **Pandas** en formato `.csv` e ingesta directa en Power BI.
2. **Transformación y Limpieza (Power Query):** Modificación y verificación estricta de los tipos de datos (Data Types) para asegurar la compatibilidad numéricas y temporales.
3. **Modelado:** Proyecto estructurado bajo un esquema de **Tabla Única (Flat Table)**, eliminando la necesidad de relaciones jerárquicas o tablas dimensionales adicionales.
4. **Cálculo de Métricas (DAX):** Creación de un conjunto de medidas explícitas para alimentar los elementos visuales y el seguimiento frente a metas.
5. **Diseño de Interfaz e Indicadores:** Implementación de objetos visuales (*KPI Cards*, gráficos de tendencia y tarjetas comparativas) adaptados para el análisis explícito de objetivos.

---

## 1. Ingesta y ETL en Power Query

### Carga de Datos
* **Fuente:** Dataset procesado previamente mediante un pipeline de limpieza e ingeniería de datos en **Pandas** (`.csv`).
* **Ingesta:** Conexión mediante el conector nativo de texto/CSV de Power BI.
* **Verificación y Ajuste de Tipos de Datos:** En **Power Query Editor** se validó que cada columna tuviese asignado el tipo de dato óptimo para el cálculo dinámico

---
## 2. Medidas DAX Implementadas

Para alimentar las **KPI Cards** y controlar el cumplimiento del **Objetivo del 2%**, se definieron las siguientes medidas explícitas:

```dax
// 1. Total Dinero Prestado:
Total Dinero Prestado = SUM(credit_risk_dataset[loan_amnt])

// 2. Total Clientes:
Total Clientes = COUNT(credit_risk_dataset[loan_status])

// 3. Tasa Interes Promedio:
Tasa Interes Promedio = AVERAGE(credit_risk_dataset[loan_int_rate])

// 4. Monto en Mora:
Monto en Mora = CALCULATE(SUM(credit_risk_dataset[loan_amnt]),credit_risk_dataset[loan_status]=1)

// 5. Cantidad Morosos:
Cantidad Morosos = CALCULATE(COUNT(credit_risk_dataset[loan_status]),credit_risk_dataset[loan_status]=1)

// 6. Porcentaje de Morososidad en Monto:
% Morososidad Monto = DIVIDE([Monto en Mora],[Total Dinero Prestado],0)
```
**Formato:**
* Las medidas `[Total Dinero Prestado]` y `[Monto en Mora]` fueron formateadas explícitamente como **Moneda (`$`)** sin decimales dentro de la vista de datos de Power BI.
* Las medidas `[Total Clientes]` y `[Cantidad Morosos]` fueron formateadas explícitamente como **Número entero** sin decimales dentro de la vista de datos de Power BI.
* Las medidas `[Tasa Interes Promedio]` y `[Porcentaje de Morososidad en Monto]` fueron formateadas explícitamente como **Porcentaje (`%`)** con 2 decimales dentro de la vista de datos de Power BI.

---
## 3. Estructura del Dashboard y Objetos Visuales

El reporte interactivo se divide en tres bloques analíticos estratégicos:

### A. Tarjetas KPI Superiores (Resumen Ejecutivo)
* **Total Créditos:** \$312 mill. (Volumen total prestado)
* **Monto en Mora:** \$77 mill. (Deuda en riesgo/impago)
* **% Morosidad:** **24.68%** (Métrica principal de control)
* **Cantidad Morosos:** 7,107 clientes
* **Créditos Total Operaciones:** 32.6 mil contratos

### B. Análisis de Tendencia y Comportamiento de Impago
* **Monto en Créditos Otorgados y % de Morosidad por Destino:**
  * Combinación de columnas cargadas con la línea del `% Morosidad Monto`.
  * *Hallazgo:* Los créditos destinados a Consolidación de Deuda (`DEBTCONSOLIDATION`) registran la mayor tasa de morosidad (33.1%).
* **Monto en Créditos Otorgados y % de Morosidad por Propiedad de Vivienda:**
  * Evaluación del riesgo según la tenencia de vivienda (`OWN`, `MORTGAGE`, `RENT`, `OTHER`).
  * *Hallazgo:* La categoría `RENT` presenta el pico mayor de tasa de mora (38.3%).

### C. Segmentación de Riesgo y Perfilamiento de Ingresos
* **% de Morosidad por Scoring Crediticio (Grado A - G):**
  * Gráfico de columnas que demuestra la validez predictiva del modelo de scoring, observándose una escala ascendente de morosidad desde la categoría **A** (11.1%) hasta la categoría **G** (99.9%).
* **% de Morosidad por Rango de Ingresos (Treemap):**
  * Distribución del riesgo según el nivel socioeconómico:
    * **Ingreso Bajo:** 53.05% de la morosidad total.
    * **Ingreso Medio:** 29.86%.
    * **Ingreso Alto:** 14.52%.
---
![Reporte de Riesgo Crediticio](Reporte%20Credit%20Risk.png)
[Reporte de Riesgo Crediticio](Reporte%20Credit%20Risk.png)
