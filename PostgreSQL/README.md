# Proyecto de Análisis de Riesgo Crediticio en PostgreSQL

## 1. Configuración de la Base de Datos e Importación de Datos
El primer paso consistió en preparar el entorno relacional dentro de PostgreSQL. Se creó la base de datos `fintech` y la tabla `credits` estructurada con los tipos de datos adecuados para soportar el volumen de información y garantizar la precisión en los cálculos numéricos.

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
