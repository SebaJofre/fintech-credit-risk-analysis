# PYTHON: Exploración, Limpieza y Preparación de Datos

## 🛠️ Tecnologías y Herramientas Utilizadas
* **IDE:** Visual Studio Code (Jupyter Notebooks)
* **Lenguaje:** Python 3.10 (Librería principal: Pandas)

## Fase 1 y 2: Diagnóstico y Limpieza de Datos
En esta primera etapa en Jupyter Notebook, realicé una auditoría del archivo crudo (`credit_risk_dataset.csv`) para evaluar su calidad antes de migrarlo a la base de datos relacional `PostgreSQL`.

### 1. Hallazgo del Diagnóstico Inicial (Paso 1)

* **Dimensiones:** 32.581 filas y 12 columnas.
* **Valores Nulos Detectados:**
  * `person_emp_length` (Antigüedad laboral): 895 vacíos (2,74%).
  * `loan_int_rate` (Tasa de interés): 3.116 vacíos (9,56%).
* **Errores fácticos/Valores imposibles:**
  * `person_age`: Se detectaron valores absurdos de 144 años.
  * `person_emp_lenght`: Se detectaron valores absurdos de 123 años.

### 2. Estrategia de Limpieza de Datos (Pasos 2 y 3)
Para no dañar la integridad del negocio eliminando registros valiosos, apliqué las siguientes reglas de ingeniería de datos:

 1. **Remoción de Errores Fácticos:** Se filtraron y eliminaron por completo las 7 filas que contenían edades > 100 años o antigüedad > 60 años.
 2. **Imputación de Antigüedad (`person_emp_length`):** Se rellenaron los vacíos utilizando la mediana general de la columna (4.0 años) para evitar distorsiones por valores extremos.
 3. **Imputación avanzada de Tasas de Interés (`loan_int_rate`):** Al ser un procentaje alto (9,56%) se aplicó una imputación agrupada por categoría de riesgo (`loan_grade`). Cada celda vacía se rellenó con el promedio exacto de tasa correspondiente a su nivel de riesgo asignado.

**Resultado Final**: Un Dataset de 32.574 registros con 0 valores nulos, exportado como `credit_risk_dataset.csv`.

*Próximo paso en desarrollo: Creación del modelo relacional y carga de datos en PostgreSQL (Paso 3).*

