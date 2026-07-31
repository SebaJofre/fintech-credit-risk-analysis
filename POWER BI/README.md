# Módulo de Visualización e Indicadores KPI (Power BI)

Este repositorio contiene la configuración, transformación de datos y modelado en **Power BI** para el panel de control de seguimiento de métricas operativas y análisis de desempeño.

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


---
[Reporte de Riesgo Crediticio](Reporte%20Credit%20Risk.png)
