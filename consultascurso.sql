--Maximo precio de renta por titulo
SELECT titulo, MAX(precio_renta)
FROM peliculas
GROUP BY titulo;

--Peliculas por clasificacion de edad
SELECT clasificacion, COUNT(*)
FROM peliculas
GROUP BY clasificacion;

--Promedio precio de renta por titulo
SELECT AVG(precio_renta)
FROM peliculas;

--Precio promedio por clasificacion
SELECT clasificacion, AVG(precio_renta) AS precio_promedio
FROM peliculas
GROUP BY clasificacion
ORDER BY precio_promedio DESC

--Duracion promedio por clasificacion
SELECT clasificacion, AVG(duracion) AS duracion_promedio
FROM peliculas
GROUP BY clasificacion
ORDER BY duracion_promedio DESC

--Duracion renta promedio por clasificacion
SELECT clasificacion, AVG(duracion_renta) AS duracion_renta_promedio
FROM peliculas
GROUP BY clasificacion
ORDER BY duracion_renta_promedio DESC

--Obteniendo informacion de un objeto con WHERE y LIKE
SELECT info ->> 'cliente' AS cliente
FROM ordenes
WHERE info ->> 'cliente' LIKE 'D%'

--
SELECT MIN(
	CAST(
	info -> 'items'->> 'cantidad' AS INTEGER
	)
),
MAX(
	CAST(
	info -> 'items'->> 'cantidad' AS INTEGER
	)
)
,
AVG(
	CAST(
	info -> 'items'->> 'cantidad' AS INTEGER
	)
),
SUM(
	CAST(
	info -> 'items'->> 'cantidad' AS INTEGER
	)
)
FROM ordenes;


--Proyecto del curso
--TOP 10 peliculas que mas dinero generan
SELECT titulo, COALESCE(SUM(cantidad),0) AS recaudo_total
FROM peliculas
LEFT JOIN inventarios
ON peliculas.pelicula_id=inventarios.pelicula_id
LEFT JOIN rentas
ON inventarios.inventario_id=rentas.inventario_id
LEFT JOIN pagos
ON rentas.renta_id = pagos.renta_id
GROUP BY titulo
ORDER BY recaudo_total DESC
LIMIT 10

-- Top 10 las peliculas mas rentadas
SELECT peliculas.pelicula_id AS id, 
	peliculas.titulo,
	COUNT(*) AS numero_rentas,
	-- Window function del top, si se repite el top tienen el mismo lugar
	DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS top 
FROM rentas
	JOIN inventarios 
		ON inventarios.inventario_id = rentas.inventario_id
	JOIN peliculas 
		ON peliculas.pelicula_id = inventarios.pelicula_id
GROUP BY peliculas.pelicula_id
HAVING COUNT(*) >24-- Filtrando los 10 mas rentados
ORDER BY numero_rentas DESC
;


--
SELECT peliculas.pelicula_id, tipos_cambio.tipo_cambio_id, tipos_cambio.cambio_usd*peliculas.precio_renta AS precio_mxn
FROM peliculas, tipos_cambio
WHERE tipos_cambio.codigo = 'MXN';