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


