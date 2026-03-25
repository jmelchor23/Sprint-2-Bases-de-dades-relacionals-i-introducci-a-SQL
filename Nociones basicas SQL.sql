USE transactions;

# NIVEL 1 - EJERCICIO 2.

-- Lista de países que están generando ventas.
SELECT DISTINCT country as Países_con_ventas
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE declined = 0;

-- Desde cuantos países se generan las ventas.
SELECT count(DISTINCT country) as Cantidad_de_países_con_ventas
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE declined = 0;

-- Compañía con mayor media de ventas
SELECT company_name, ROUND(AVG(amount),2) as Media_de_Ventas
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE declined = 0
GROUP BY company_id
ORDER BY Media_de_Ventas DESC
LIMIT 1;

# NIVEL 1 - EJERCICIO 3. (solo subconsultas, sin utilizar JOIN)

-- Todas las transacciones realizadas por empresas de Alemania.
SELECT transaction.id AS Transacciones_de_empresas_Alemanas
FROM transaction
WHERE EXISTS (SELECT id
					FROM company 
                    WHERE (transaction.company_id = company.id) AND (country = 'Germany')
                    );

-- Lista las empresas que han realizado transacciones por un monto superior a la media de todas las transacciones
SELECT company_name AS Empresas_con_transacc_superior_a_la_media 
FROM company
WHERE EXISTS 
	(
	SELECT company_id 
    FROM transaction
	WHERE (transaction.company_id = company.id) AND amount > 
		(
		SELECT AVG(amount)
        FROM transaction
        WHERE declined = 0
        ) AND declined = 0
	); 

-- Lista de empresas que no tienen transacciones registradas
SELECT DISTINCT company_name AS Empresas_sin_transacciones
FROM company 
WHERE NOT EXISTS 
	(
	SELECT company_id
    FROM transaction
    WHERE company.id = transaction.company_id
	);
        
-- ---------------------------------------------------------------
# NIVEL 2 - EJERCICIO 1.

/*Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
Muestra la fecha de cada transacción junto con el total de las ventas.*/

SELECT DATE(timestamp) as Fecha_Transaccion, SUM(amount) AS ventas_por_fecha
FROM transaction
WHERE declined = 0
GROUP BY DATE(timestamp), amount
ORDER BY ventas_por_fecha DESC
LIMIT 5;             

# NIVEL 2 - EJERCICIO 2.
-- ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.

SELECT country, ROUND(AVG(amount),2) AS Media_ventas_por_pais
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE declined = 0
GROUP BY country
ORDER BY Media_ventas_por_pais DESC;     

# NIVEL 2 - EJERCICIO 3.
--  lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que “Non Institute”

# USANDO JOIN Y SUBQUERY
SELECT transaction.id, company_name
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE (company_name <> 'Non Institute') AND country = 
	(
	SELECT country  
    FROM company 
    WHERE company_name = 'Non Institute'
	);

# USANDO SUBQUERY
SELECT transaction.id
FROM transaction
WHERE company_id IN
(
	SELECT id
    FROM company
    WHERE country =  
    (
		SELECT country 
		FROM company 
        WHERE company_name = 'Non Institute'
	) AND company_name <> 'Non Institute'
);
-- -------------------------------------------------------------
# NIVEL 3 - Ejercicio 1.
/*Presenta el nombre, teléfono, país, fecha e importe, de aquellas empresas que realizaron transacciones con un valor 
comprendido entre 350 y 400 euros y en alguna de estas fechas: 
29 de abril de 2015, 20 de julio de 2018 y 13 de marzo de 2024. 
Ordena los resultados de mayor a menor cantidad.*/

SELECT company_name AS Nombre_compañia, phone AS Telefono, country AS Pais, DATE(timestamp) as Fecha, amount AS Importe
FROM transaction 
JOIN company ON transaction.company_id = company.id
WHERE (amount BETWEEN 350 AND 400)
		AND declined = 0
		AND ((DATE(timestamp) IN ('2015-04-29','2018-07-20','2024-03-13')))
ORDER BY amount DESC;

# NIVEL 3 - Ejercicio 2.
/* Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, 
pero el departamento de recursos humanos es exigente y quiere un listado de las empresas en las que especifiques 
si tienen más de 400 transacciones o menos*/

SELECT company_name, count(company_id) as cantidad_de_transacciones,
CASE
	WHEN count(company_id) > 400 THEN '400 o mas transacciones'
    ELSE 'Menos de 400 transacciones'
    END as Descripcion_cantidad_transacciones
FROM transaction 
JOIN company ON transaction.company_id = company.id
GROUP BY company_name
ORDER BY cantidad_de_transacciones DESC;