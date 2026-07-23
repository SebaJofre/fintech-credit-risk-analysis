/* SELECT COUNT(*) AS total_registros
FROM credits;

SELECT *
FROM credits
LIMIT 5;

SELECT COUNT(*)
FROM credits
WHERE person_age <= 30;

*/

/*
1. Escribe una consulta que devuelva únicamente la tasa de interés promedio (loan_int_rate) y la cantidad total de créditos
para cada una de las calificaciones de préstamo (loan_grade).

Debes ordenar el resultado de tal manera que la calificación con la tasa de interés promedio más alta aparezca primero.
*/

SELECT loan_grade AS categoria,
		ROUND(AVG(loan_int_rate),2) AS promedio_interes,
		COUNT(loan_grade) AS total
FROM credits
GROUP BY loan_grade
ORDER BY 2 DESC;

/* 
2. Necesitamos identificar qué tipo de destinos de crédito (loan_intent) concentran préstamos de montos altos pero con
ingresos moderados.

Escribe una consulta que muestre el destino del préstamo (loan_intent) y el monto promedio de crédito solicitado (loan_amnt),
cumpliendo con las siguientes condiciones:

Solo debes incluir a personas que tengan un ingreso anual (person_income) menor o igual a $50,000.

El resultado debe mostrar únicamente aquellos destinos de préstamo cuyo monto promedio de crédito sea estrictamente mayor a 
$8,000.
*/

SELECT loan_intent AS destino_credito,
		ROUND(AVG(loan_amnt),2) AS avg_credito_solicitado
FROM credits
WHERE person_income <= 50000
GROUP BY loan_intent
HAVING AVG(loan_amnt) > 7100
ORDER BY avg_credito_solicitado DESC;

-- ¿Cuál es la tasa de morosidad por cada tipo de propiedad de vivienda (person_home_ownership)?

SELECT person_home_ownership AS tipo_de_propiedad,
		COUNT(*) AS cantidad,
		SUM(loan_status) AS cantidad_morosos,
		ROUND((SUM(loan_status)::DECIMAL/COUNT(*))*100,2) AS porcenta_morosidad --Se usa un CAST :: para cambiar de INT a DECIMAL
FROM credits
GROUP BY person_home_ownership
HAVING COUNT(person_home_ownership) > 1000
ORDER BY 3 DESC;

-- ¿Cómo influye la experiencia laboral de los clientes en la morosidad?

SELECT person_emp_length AS antiguedad_laboral,
		ROUND(AVG(loan_amnt),0) AS promedio_prestamo,
		ROUND((SUM(loan_status)::DECIMAL/COUNT(*))*100,2) AS porcentaje_morosidad
FROM credits
WHERE person_emp_length IS NOT NULL
GROUP BY person_emp_length
HAVING AVG(loan_amnt) > 10000
ORDER BY porcentaje_morosidad DESC;

/* Queremos clasificar a los clientes en tres niveles de riesgo según el porcentaje del ingreso que representa su préstamo
(loan_percent_income):
Si loan_percent_income es mayor a 0.30 → 'ALTO COMPROMISO'
Si está entre 0.15 y 0.30 (inclusive) → 'COMPROMISO MEDIO'
Si es menor a 0.15 → 'BAJO COMPROMISO'
*/

SELECT CASE
			WHEN loan_percent_income > 0.30 THEN 'ALTO COMPROMISO'
			WHEN loan_percent_income < 0.15 THEN 'BAJO COMPROMISO'
			ELSE 'COMPROMISO MEDIO'
		END AS clasificacion,
		COUNT(*) AS total_de_creditos,
		ROUND(SUM(loan_amnt)) AS monto_total_prestado,
		ROUND((SUM(loan_status)::DECIMAL/COUNT(*))*100,2) AS porcentaje_morosidad
FROM credits
GROUP BY clasificacion
ORDER BY monto_total_prestado DESC;

-- Queremos identificar qué préstamos individuales representan un riesgo extraordinario dentro de su propio tipo de vivienda.

WITH promedios_viviendas AS (
	SELECT person_home_ownership,
			ROUND(AVG(loan_amnt),2) AS promedio_prestamo
	FROM credits
	GROUP BY person_home_ownership
)

SELECT c.person_age AS edad,
		c.person_home_ownership AS tipo_vivienda,
		c.loan_amnt AS monto_prestamo,
		p.promedio_prestamo
FROM credits c
JOIN promedios_viviendas p
	ON c.person_home_ownership = p.person_home_ownership
WHERE c.loan_amnt > (p.promedio_prestamo * 2);

-- Queremos rankear los préstamos dentro de cada destino de crédito (loan_intent) para encontrar cuáles son los préstamos 
-- a los que se les cobra la tasa de interés más alta (loan_int_rate).

SELECT loan_intent AS destino_del_prestamo,
		loan_amnt AS monto_del_prestamo,
		loan_int_rate AS tasa_de_interes,
		RANK() OVER (PARTITION BY loan_intent
						ORDER BY loan_int_rate DESC) AS ranking_tasa_interes
FROM credits
WHERE loan_int_rate IS NOT NULL;

WITH rk_tasa_interes AS(
	SELECT loan_intent,
			loan_amnt,
			loan_int_rate,
			ROW_NUMBER() OVER(PARTITION BY loan_intent ORDER BY loan_int_rate DESC) AS top_puestos
	FROM credits
	WHERE loan_int_rate IS NOT NULL
)

SELECT *
FROM rk_tasa_interes
WHERE top_puestos <= 3;

/*
Queremos entender si las personas que ya tienen un historial previo de mora (cb_person_default_on_file) realmente vuelven 
a caer en impago en su crédito actual (loan_status).
*/

SELECT cb_person_default_on_file AS historial_mora,
		SUM(CASE WHEN loan_status = 0 THEN 1 ELSE 0 END) AS sin_mora,
		SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS con_mora,
		SUM(loan_amnt) AS total_prestado,
		ROUND((SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END)::DECIMAL / COUNT(*))*100,2) AS porcentaje_mora
FROM credits
GROUP BY historial_mora;




