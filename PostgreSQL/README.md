# Proyecto de Análisis de Riesgo Crediticio en PostgreSQL

## 1. Configuración de la Base de Datos e Importación de Datos
El primer paso consistió en preparar el entorno relacional dentro de PostgreSQL. Se creó la base de datos `fintech` y la tabla `credits` estructurada con los tipos de datos adecuados para soportar el volumen de información y garantizar la precisión en los cálculos numéricos.

> 📂 **Código fuente completo:** Puedes consultar el script con la creación de la base de datos y tabla en [01_schema_and_import.sql](./01_schema_and_import.sql).

### Script de Creación de la Base de Datos y Esquema

```sql
-- 1. Creación de la Base de Datos 'fintech'.

CREATE DATABASE fintech;

-- 2. Creación de la tabla  'credits'
CREATE TABLE credits (
	id_credit SERIAL PRIMARY KEY, 		-- ID único
	person_age INT,						-- Edad del solicitante
	person_income INT,					-- Ingreso anual (USD)
	person_home_ownership VARCHAR(30),	-- Tipo de vivienda (RENT, OWN, MORTGAGE, OTHER)
	person_emp_length NUMERIC(5,2),		-- Antigüedad laboral en años
	loan_intent VARCHAR(50),			-- Propósito del préstamo
	loan_grade CHAR(1),					-- Clasificación interna de riesgo del crédito (A, B, C, D, E, F, G)
	loan_amnt INT,						-- Monto solicitado del préstamo (USD)
	loan_int_rate NUMERIC(4,2),			-- Tasa de interés asignada (%)
	loan_status INT,					-- Estado del crédito (0 = Al día / Pagado, 1 = En mora / Impago)
	loan_percent_income NUMERIC(3,2),	-- Porcentaje del ingreso comprometido para el préstamo
	cb_person_default_on_file CHAR(1),	-- Historial previo de mora en buró de crédito (Y = Sí, N = No)
	cb_person_cred_hist_length INT		-- Años de historial crediticio registrado
);
```
### Importación del Dataset
Una vez estructurada la tabla, se realizó el proceso de carga de datos (ETL) desde el archivo CSV limpio (`credit_risk_dataset.csv`) usando el comando nativo `COPY` de PostgreSQL (o la interfaz de importación de pgAdmin):
```sql
-- 3. Ejemplo de carga masiva vía SQL nativo

COPY credits 
FROM '/ruta/del/archivo/credit_risk_dataset.csv' 
DELIMITER ',' 
CSV HEADER;
```
### Verificación inicial de carga
Para comprobar que la estructura se importó correctamente y que los tipos de datos concuerdan con la muestra del dataset:
```sql
-- 4. Confirmar cantidad total de registros importados
SELECT COUNT(*) AS total_registros
FROM credits;

-- 5. Inspeccionar las primeras filas de la tabla
SELECT *
FROM credits
LIMIT 5;
```
---

## 2. Respuestas a las Preguntas de Negocio

> 📂 **Código fuente completo:** Puedes consultar el script con las Preguntas de Negocio en [02_preguntas_de_negocio.sql](./02_preguntas_de_negocio.sql).

### 1. ¿Cuál es la Tasa de Morosidad (Bad Loan Ratio) y cuánto dinero está costando?
#### Objetivo del Negocio
Evaluar la salud financiera general de la cartera de créditos para determinar si la empresa se encuentra por encima del límite de peligro aceptable (establecido internamente en un máximo de 5% de pérdidas) y cuantificar el impacto monetario exacto en millones de dólares de los préstamos en mora.

