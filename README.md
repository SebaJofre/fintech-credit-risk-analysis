# Análisis de Riesgo Crediticio de una FinTech

### Objetivo del Proyecto.
Determinar los segmentos tomadores de préstamos que representan mayores riesgos para la compañía.
Se busca realizar un análisis que permita determinar qué segmentos es el más propenso a no pagar los créditos. Esto permitirá denegarles prestamos a aquellos segmentos específicos.
En palabras sencillas, es crear un sistema de analítica inteligente que le permita a la empresa seguir prestando dinero para crecer, pero bloqueando o evitando automáticamente a los clientes que tienen una alta probabilidad de no pagar, ahorrando millones en pérdidas.

### Herramientas a utilizar:
1. `Microsoft Excel`: para la creación de metas de negocio.
2. `PostgreSQL`: para la limpieza, transformación y modelado de transacciones.
3. `Power BI`: para la creación de un dashboard que responda preguntas a la Dirección.

### Origen y Procedencia de los Datos (Data Sourcing)

Los datos transaccionales de préstamos utilizados en este proyecto son de acceso público y han sido obtenidos de la plataforma `Kaggle`:

* **Fuente del Dataset Principal:** [Kaggle - Credit Risk Dataset por Laotse](https://www.kaggle.com/datasets/laotse/credit-risk-dataset)
* **Volumen de Datos:** 32,581 registros y 12 variables financieras y demográficas.
* **Datos de Negocio Adicionales (Metas Financieras):** Adicionalmente, se integra un control de presupuestos mensuales simulado en **Google Sheets** para enriquecer el análisis comparativo del rendimiento del negocio en Power BI.

### Preguntas de Negocio a Responder

**1. ¿Cuál es la Tasa de Morosidad (Bad Loan Ratio) y cuánto dinero está costando?**
   
Se necesita saber si se esta por encima del límite de peligro del negocio (Ej. más de un 5% de pérdidas) y cuántos millones de dólares representan los préstamos que ya se dan por perdidos.

**2. ¿Qué perfil de cliente es el más peligroso para la empresa?**

Se pretende descubrir qué variables aumentan el riesgo. Por ejemplo: ¿Los usuarios que alquilan vivienda y tienen ingresos menos de $30.000 al año tienen una tasa de impago inaceptable? Si la respuesta es afirmativa se deben modificar las reglas de aprobación de créditos.

**3. ¿Para qué se usa el dinero que no regresa?**

Se analizará el propósito del préstamos (loan intent). Por ejemplo: Si se determina que los créditos solicitados para la "Gastos Médicos" fallan el triple que los de "Educación".

**4. ¿Se está cobrando el interés correcto según el riesgo del cliente?**

Es importante dar respuesta a esta pregunta porque en finanzas, a mayor riesgo, mayor tase de interés. Se debe comprobar que si la FinTech le está cobrando una tasa más alta a los clientes con peor historial, o si se esta cometiendo el error de cobrarle lo mismo a todos.

**5. ¿Cómo va el rendimiento del mes frente a las metas que se plantea la empresa?**

Se cruzan los datos reales con las metas mensuales para ver si se esta cumpliendo con el presupuesto de colocación sin disparar la morosidad

Para conocer en detalle los conceptos financieros y técnicos utilizados en este proyecto, consulta nuestro [Glosario de Términos (GLOSARIO.md)](./GLOSARIO.md).

### Analísis de Datos en Microsoft Excel

Se realiza un primer análisis en Excel para aplicar un proceso ETL (Extract, Transform and Loan) de los datos, que permita comprender la estructura de la base de datos y obtener respuestas concisas y de calidad.

El archivo [Análisis_en_Excel](
