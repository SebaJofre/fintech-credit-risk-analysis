## Fase Alternativa: Prototipado y Análisis de Riesgo en Excel

Antes de escalar el proceso, utilicé **Microsoft Excel** como entorno de exploración rápida y modelado de negocio en el archivo `credit_risk_dataset_analysis.xlsx`, estructurando el análisis para responder a la pregunta clave del negocio: **¿Qué segmento de clientes tiene la mayor probabilidad de caer en impago (Default)?**

### 1. Preparación e Ingeniería de Variables (`Working Sheet`)
* **Normalización:** Se transformó la variable binaria `loan_status` (0/1) en etiquetas de negocio legibles: `PAID` (Pagado) y `UNPAID` (Impago).
* **Segmentación Estratégica (Nuevas Columnas)** `range_age`: Clasificación etaria de los solicitantes en categorías (`YOUNG`, `ADULT`, `SENIOR`). El **72.16%** de la cartera está concentrada en el segmento joven.
  * `range_income_young`: Agrupación del ingreso exclusivo para el sector joven en tres capas (`LOW INCOME`, `MEDIUM INCOME`, `HIGH INCOME`) usando umbrales lógicos de distribución.

### 2. Hallazgos clave del Análisis Estadístico (`Working Analysis`)
A través de **Tablas Dinámicas** cruzadas y análisis de tasas de morosidad promedio, se logró aislar el perfil crítico de riesgo de la FinTech:

1. **La Radiografía de la Cartera:** La tasa de morosidad global de la empresa es del **21.81%** (7,107 clientes en impago de un total de 32,575).
2. **El Factor Edad:** El segmento `YOUNG` (Jóvenes) representa el grueso del riesgo absoluto de la compañía, acumulando **5,252 clientes en mora** (el 73.8% de todos los impagos de la empresa).
3. **El Disparador de Riesgo Extremo (Vivienda + Intención):** Al profundizar en el segmento joven de bajos ingresos (`LOW INCOME`), se descubrió que:
   * Los jóvenes que viven en propiedades alquiladas (`RENT`) y solicitan créditos para **Mejoras del Hogar (Home Improvement)** o **Consolidación de Deudas (Debt Consolidation)** disparan su tasa de morosidad a niveles alarmantes de entre el **51.3% y el 76.7%**.
   * Si además cuentan con un **historial de default previo** (`cb_person_default_on_file = Y`), la probabilidad de impago roza el **91%**.

> 💡 **Insight de Negocio:** El análisis en Excel demostró que el riesgo no es genérico. Un joven de bajos ingresos que renta tiene un comportamiento aceptable si el crédito es para Educación o Negocios (Venture), pero se vuelve financieramente inviable si busca consolidar deudas o remodelar una casa que no le pertenece.
