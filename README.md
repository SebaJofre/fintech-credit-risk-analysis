# Análisis de Riesgo Crediticio de una FinTech

### Objetivo del Proyecto.
Maximizar la rentabilidad de la Fintech mediante la identificación y mitigación del riesgo de impago (Default).

En palabras sencillas, es crear un sistema de analítica inteligente que le permita a la empresa seguir prestando dinero para crecer, pero bloqueando o evitando automáticamente a los clientes que tienen una alta probabilidad de no pagar, ahorrando millones en pérdidas.

### Herramientas a utilizar:
1. `Google Sheets`: para la creación de metas de negocio.
2. `PostgreSQL`: para la limpieza, transformación y modelado de transacciones.
3. `Power BI`: para la creación de un dashboard que responda preguntas a la Dirección.

### Preguntas de Negocio a Responder

**1. ¿Cuál es la Tasa de Morosidad (Bad Loan Ratio) y cuánto dinero está costando?**
   
Se necesita saber si se esta por encima del límite de peligro del negocio (Ej. más de un 5% de pérdidas) y cuántos millones de dólares representan los préstamos que ya se dan por perdidos.

**2. ¿Qué perfil de cliente es el más peligroso para la empresa?**

Se pretende descubrir qué variables aumentan el riesgo. Por ejemplo: ¿Los usuarios que alquilan vivienda e tienen ingresos menos de $30.000 al año tienen una tasa de impago inaceptable? Si la respuesta es afirmativa se deben modificar las reglas de aprobación de créditos.

**3. ¿Para qué se usa el dinero que no regresa?**

Se analizará el propósito del préstamos (loan intent). Por ejemplo: Si se determina que los créditos solicitados para la "Gastos Médicos" fallan el triple que los de "Educación".

**4. ¿Se está cobrando el interés correcto según el riesgo del cliente?**

Es importante dar respuesta a esta pregunta porque en finanzas, a mayor riesgo, mayor tase de interés. Se debe comprobar que si la FinTech le está cobrando una tasa más alta a los clientes con peor historial, o si se esta cometiendo el error de cobrarle lo mismo a todos.

**5. ¿Cómo va el rendimiento del mes frente a las metas que se plantea la empresa?**

Se cruzarn los datos reales con las metas mensuales para ver si se esta cumpliendo con el presupuesto de colocación sin disparar la morosidad

### Términos de Negocio y Riesgo Financiero
**Default (Incumplimiento / Impago):** Situación en la que un cliente no cumple con la obligación legal de devolver el préstamo según el acuerdo. En nuestro dataset, se activa cuando el cliente lleva más de 90 días sin pagar.

**Bad Loan Ratio (Tasa de Morosidad):** El porcentaje de préstamos en estado de Default o mora crítica respecto al total del capital colocado. Es el KPI de control de riesgo más importante del proyecto.

**Good Loan vs. Bad Loan:** Clasificación binaria de la cartera. Un Good Loan es un crédito activo o liquidado al día; un Bad Loan es un crédito con alta probabilidad de pérdida financiera.

**DTI (Debt-to-Income Ratio / Ratio Deuda-Ingreso):** Métrica que mide qué porcentaje de los ingresos brutos del cliente está comprometido para pagar deudas. Un DTI elevado indica sobreendeudamiento.

**Credit Score (Puntuación de Crédito):** Indicador numérico que evalúa la solvencia de una persona y su probabilidad de pagar sus deudas a tiempo, basado en su historial financiero.

**Loan Intent (Propósito del Préstamo):** La razón declarada por el cliente para solicitar el financiamiento (ej. consolidación de deudas, educación, gastos médicos). Ayuda a segmentar el riesgo por comportamiento.

**Interest Rate (Tasa de Interés):** El precio que cobra la FinTech por prestar el dinero, expresado como un porcentaje del capital por período.

**Mitigación del Riesgo:** Conjunto de estrategias y reglas de negocio automatizadas basadas en datos para reducir las pérdidas financieras antes de que ocurra el desembolso.
