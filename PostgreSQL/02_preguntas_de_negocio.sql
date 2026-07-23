-- =========================================================================================================================
-- Preguntas de Negocio a Responder
-- =========================================================================================================================

-- 1. ¿Cuál es la Tasa de Morosidad (Bad Loan Ratio) y cuánto dinero está costando?
-- Se necesita saber si se esta por encima del límite de peligro del negocio (Ej. más de un 5% de pérdidas) y cuántos millones
-- de dólares representan los préstamos que ya se dan por perdidos.

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


-- 2. ¿Qué perfil de cliente es el más peligroso para la empresa?
-- Queremos descubrir qué combinación de variables aumenta drásticamente el riesgo (ej. tipo de vivienda, nivel de ingresos
-- o porcentaje del sueldo comprometido).

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

-- 3.¿Para qué se usa el dinero que no regresa?
-- Queremos analizar el propósito del préstamo (loan_intent) para determinar si ciertos destinos (por ejemplo, Gastos Médicos
-- o Consolidación de Deuda) tienen una probabilidad de impago sustancialmente mayor que otros (como Educación o Inversión).

SELECT loan_intent AS destino_del_credito,
		COUNT(*) AS total_prestamos,
		ROUND(SUM(loan_amnt)/1000000.0,2) AS total_prestado_millones,
		ROUND(SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) / 1000000.0, 2) AS dinero_en_mora_millones,
		ROUND((SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END)::DECIMAL / SUM(loan_amnt)) * 100,2) AS tasa_morosidad_monto
FROM credits
GROUP BY destino_del_credito
ORDER BY tasa_morosidad_monto DESC;


-- 4. ¿Se está cobrando el interés correcto según el riesgo del cliente?
-- Queremos comprobar si la FinTech le está cobrando una tasa de interés más alta a los clientes con peor historial o mayor
-- riesgo, o si está cometiendo el error de aplicar tasas muy similares a todos sin compensar las pérdidas.

--AGRUPADA POR HISTORIAL CREDITICIO
SELECT cb_person_default_on_file AS historial_crediticio,
		COUNT(*) AS total_clientes,
		ROUND(AVG(loan_int_rate),2) AS tasa_interes_promedio,
		ROUND((SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END)::DECIMAL / SUM(loan_amnt)) * 100,2) AS tasa_morosidad_monto
FROM credits
GROUP BY historial_crediticio
ORDER BY tasa_morosidad_monto DESC;
		
--AGRUPADA POR CALIFICACION DE CREDITO
SELECT loan_grade AS calificacion_credito,
		COUNT(*) AS total_clientes,
		ROUND(AVG(loan_int_rate),2) AS tasa_interes_promedio,
		ROUND((SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END)::DECIMAL / SUM(loan_amnt)) * 100,2) AS tasa_morosidad_monto
FROM credits
GROUP BY calificacion_credito
ORDER BY tasa_morosidad_monto ASC;
		















