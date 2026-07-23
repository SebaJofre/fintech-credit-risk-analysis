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

#### Consulta SQL
Para resolver esta pregunta, se utilizaron funciones de agregación condicionales (CASE WHEN) combinadas con conversiones de tipo (::DECIMAL) y redondos (ROUND) para calcular tanto el volumen de capital expuesto como los porcentajes de morosidad global.
```sql
SELECT 
	-- 1. Cuánto dinero representan los préstamos en mora (en millones)
	ROUND(SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) / 1000000.0,2) AS dinero_en_mora_millones,

	-- 2. Monto total prestado en la cartera (en millones)
	ROUND(SUM(loan_amnt)/1000000.0,2) AS total_prestado_millones,

	-- 3. Tasa de Morosidad por monto (Bad Loan Ratio en %)
	ROUND((SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END)::DECIMAL / SUM(loan_amnt)) * 100,2) AS tasa_morosidad_monto,

	-- 4. Tasa de Morosidad por cantidad de créditos (en %)
	ROUND((SUM(loan_status)::DECIMAL / COUNT(*)) * 100,2) AS tasa_morosidad_cantidad
FROM credits;
```
#### Resultados Obtenidos
| Métrica / Variable | Resultado Obtenido | Diagnóstico & Impacto de Negocio |
| :--- | :--- | :--- |
| **Cartera Total Contratada** | **$312.32M USD** | Volumen total de capital originado en el portafolio analizado. |
| **Capital en Mora** | **$77.09M USD** | Capital expuesto a pérdida directa por impago (`loan_status = 1`). |
| **Tasa de Morosidad (por Monto)** | **24.68%** | **CRÍTICO:** Excede ampliamente el umbral de tolerancia habitual (3% - 5%). |
| **Tasa de Morosidad (por Cantidad)** | **21.82%** | **CRÍTICO:** Aproximadamente 1 de cada 5 clientes entra en mora. |
| **Monto vs. Cantidad** | **24.68% > 21.82%** | Los créditos que caen en mora corresponden, en promedio, a montos más elevados (*high ticket*). |

#### Análisis e Impacto de Negocio

1. **Exceeding Risk Limits (Superación del Límite de Peligro):**
Con una tasa de morosidad del 24.68%, la FinTech opera en una zona de riesgo crítico. El indicador supera por casi cinco veces el umbral máximo tolerable de la industria (5%), lo que evidencia fallas graves en las políticas vigentes de originación y evaluación de riesgo.

2. **Impacto Monetario Directo:**
Existen $77.09 millones de dólares inmovilizados o en inminente riesgo de pérdida total. Esto afecta de manera directa la liquidez de la compañía y exige constituir provisiones de capital extraordinarias.

3. **Discrepancia entre Monto y Cantidad:**
La tasa de morosidad calculada por monto (24.68%) es superior a la calculada por número de operaciones (21.82%). Este hallazgo demuestra que los créditos que caen en mora son, en promedio, de montos más elevados (high ticket), por lo que el impacto financiero recae fuertemente en las operaciones grandes.

### 2. ¿Qué perfil de cliente es el más peligroso para la empresa?
Identificar qué combinación de variables socioeconómicas (tipo de vivienda y rango de ingresos anuales) incrementa drásticamente la tasa de mora para proponer modificaciones inmediatas en los filtros de aprobación automática (*hard filters*).

#### Consulta SQL
```sql
SELECT person_home_ownership AS tipo_de_vivienda,
		CASE 
			WHEN person_income < 30000 THEN 'Ingreso Bajo'
			WHEN person_income > 70000 THEN 'Ingreso Alto'
			ELSE 'Ingreso Medio' 
		END AS ingresos,
		COUNT(*) AS total_clientes,
		(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END)) AS cantidad_morosos,
		ROUND((SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END)::DECIMAL / SUM(loan_amnt)) * 100,2) AS tasa_morosidad_monto
FROM credits
GROUP BY tipo_de_vivienda, ingresos
ORDER BY tasa_morosidad_monto DESC;
```
#### Resultados Obtenidos (Top Segmentos de Riesgo)
| Tipo de Vivienda | Rango de Ingresos | Diagnóstico & Impacto de Negocio |
| :--- | :--- | :--- |

#### Análisis e Impacto de Negocio
El Perfil de Mayor Peligro (RENT + Ingreso Bajo):

Los solicitantes que alquilan vivienda e ingresan menos de $30,000 USD/año registran una tasa de mora del 63.27%. Más de 6 de cada 10 dólares prestados a este segmento resultan impagados.

Volumen vs. Concentración de Riesgo (RENT + Ingreso Medio):

El grupo de alquiler con ingreso medio representa el segmento más grande de la base (10,346 clientes). Sin embargo, presenta una tasa de mora críticamente alta del 42.43% (3,220 morosos), convirtiéndose en la fuente principal de volumen de pérdidas en dinero.

El Factor Protector de la Vivienda Propia (OWN):

Tener vivienda propia demuestra ser el mayor factor de mitigación de riesgo. Incluso en niveles de ingreso medio, los propietarios muestran una tasa de impago de apenas 2.31%, situándose holgadamente por debajo del umbral de peligro del 5%.

#### Recomendación Estratégica
Filtro Estricto para Alquiler/Bajo Ingreso: Bloquear la aprobación automática para la combinación RENT + Ingreso Bajo o exigir un aval/garantía sólida.

Incentivos para Propietarios: Aumentar la tasa de aprobación y ofrecer mejores condiciones a clientes con vivienda propia (OWN), ya que su comportamiento de pago es excepcionalmente estable.
