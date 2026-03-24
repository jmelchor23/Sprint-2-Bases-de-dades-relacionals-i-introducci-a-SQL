USE transactions;

# NIVEL 1 - EJERCICIO 2.

-- Lista de países que están generando ventas.
SELECT DISTINCT country as Países_con_ventas
FROM transaction
JOIN company ON transaction.company_id = company.id;

-- Desde cuantos países se generan las ventas.
SELECT count(DISTINCT country) as Cantidad_de_países_con_ventas
FROM transaction
JOIN company ON transaction.company_id = company.id;

-- Compañía con mayor media de ventas
SELECT company_name, AVG(amount) as Media_de_Ventas
FROM transaction
JOIN company ON transaction.company_id = company.id
GROUP BY company_id
ORDER BY Media_de_Ventas DESC
LIMIT 1;

# NIVEL 1 - EJERCICIO 3. (solo subconsultas, sin utilizar JOIN)

-- Todas las transacciones realizadas por empresas de Alemania.
SELECT transaction.id as Transacciones_de_empresas_Alemanas
FROM transaction
WHERE company_id IN (SELECT id FROM company WHERE country = 'Germany');

-- Lista las empresas que han realizado transacciones por un monto superior a la media de todas las transacciones
SELECT company_name AS Empresas_con_transacc_superior_a_la_media 
FROM company
WHERE id IN (
	SELECT company_id 
    FROM transaction
	WHERE amount > (
		SELECT AVG(amount) 
        FROM transaction
                   )
			); 

-- Lista de empresas que no tienen transacciones registradas
SELECT DISTINCT company_name AS Empresas_sin_transacciones
FROM company 
WHERE id  NOT IN (
			SELECT company_id
            FROM transaction
		);
        
-- ---------------------------------------------------------------
# NIVEL 2 - EJERCICIO 1.

/*Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
Muestra la fecha de cada transacción junto con el total de las ventas.*/

SELECT grupo_fechas.Fechas, SUM(grupo_fechas.amount) AS ventas_por_fecha
FROM (	
    SELECT DATE(timestamp) as Fechas, amount
	FROM transaction
	GROUP BY DATE(timestamp), amount
    ) as grupo_fechas
GROUP BY grupo_fechas.fechas
ORDER BY ventas_por_fecha DESC
LIMIT 5;

# NIVEL 2 - EJERCICIO 2.
-- ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.

SELECT country, AVG(amount) AS Media_ventas_por_pais
FROM transaction
JOIN company ON transaction.company_id = company.id
GROUP BY country
ORDER BY Media_ventas_por_pais DESC;

# NIVEL 2 - EJERCICIO 3.
--  lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que “Non Institute”

# USANDO JOIN Y SUBQUERY
SELECT transaction.id
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE country = (
	SELECT country  
    FROM company 
    WHERE company_name = 'Non Institute'
				);

# USANDO SUBQUERY
SELECT transaction.id
FROM transaction
WHERE company_id IN (
	SELECT id
    FROM company 
    WHERE country IN (SELECT country 
					  FROM company 
                      WHERE company_name = 'Non Institute'));

# NIVEL 3 - Ejercicio 1.
/*Presenta el nombre, teléfono, país, fecha e importe, de aquellas empresas que realizaron transacciones con un valor 
comprendido entre 350 y 400 euros y en alguna de estas fechas: 
29 de abril de 2015, 20 de julio de 2018 y 13 de marzo de 2024. 
Ordena los resultados de mayor a menor cantidad.*/

SELECT company_name, phone, country, DATE(timestamp) as Fecha, amount
FROM transaction 
JOIN company ON transaction.company_id = company.id
WHERE (amount BETWEEN 350 AND 400) AND ((DATE(timestamp) IN ('2015-04-29','2018-07-20','2024-03-13')))
ORDER BY amount DESC;

# NIVEL 3 - Ejercicio 2.
/* Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, 
pero el departamento de recursos humanos es exigente y quiere un listado de las empresas en las que especifiques 
si tienen más de 400 transacciones o menos*/

SELECT company_name, count(company_id) as cantidad_de_transacciones,
CASE
	WHEN count(company_id) > 400 THEN 'Mas de 400 transacciones'
    WHEN count(company_id) = 400 THEN '400 transacciones'
    ELSE 'Menos de 400 transacciones'
    END as Descripcion_cantidad_transacciones
FROM transaction 
JOIN company ON transaction.company_id = company.id
GROUP BY company_name;