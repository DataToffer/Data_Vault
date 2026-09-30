-- ============================================================
-- 01. ANÁLISIS EXPLORATORIO EN BRONZE
-- Caso CompluBeer · Snowflake + Medallion
-- ============================================================

USE DATABASE TALLER_DATO_DECISION;
USE SCHEMA BRONZE;

-- ------------------------------------------------------------
-- 1. Volumen cargado por fuente
-- ------------------------------------------------------------
SELECT 'RAW_VENTAS' AS tabla, COUNT(*) AS registros FROM BRONZE.RAW_VENTAS
UNION ALL SELECT 'RAW_PRODUCTOS', COUNT(*) FROM BRONZE.RAW_PRODUCTOS
UNION ALL SELECT 'RAW_OBJETIVOS', COUNT(*) FROM BRONZE.RAW_OBJETIVOS
UNION ALL SELECT 'RAW_CANALES', COUNT(*) FROM BRONZE.RAW_CANALES;

-- ------------------------------------------------------------
-- 2. Primera inspección visual
-- ------------------------------------------------------------
SELECT * FROM BRONZE.RAW_VENTAS LIMIT 20;
SELECT * FROM BRONZE.RAW_PRODUCTOS LIMIT 20;
SELECT * FROM BRONZE.RAW_OBJETIVOS LIMIT 20;
SELECT * FROM BRONZE.RAW_CANALES LIMIT 20;

-- ------------------------------------------------------------
-- 3. Granularidad preliminar de ventas
-- ------------------------------------------------------------
SELECT
  COUNT(*) AS filas,
  COUNT(DISTINCT ID_VENTA) AS ventas_distintas,
  COUNT(DISTINCT FECHA_VENTA) AS fechas_distintas,
  COUNT(DISTINCT ID_PRODUCTO) AS productos_distintos,
  COUNT(DISTINCT REGION) AS regiones_distintas,
  COUNT(DISTINCT CANAL) AS canales_distintos
FROM BRONZE.RAW_VENTAS;

-- ------------------------------------------------------------
-- 4. Revisión de categorías crudas
-- ------------------------------------------------------------
SELECT CANAL, COUNT(*) AS registros
FROM BRONZE.RAW_VENTAS
GROUP BY CANAL
ORDER BY registros DESC;

SELECT REGION, COUNT(*) AS registros
FROM BRONZE.RAW_VENTAS
GROUP BY REGION
ORDER BY registros DESC;

SELECT CANAL_RAW, CANAL_NORMALIZADO, COUNT(*) AS registros
FROM BRONZE.RAW_CANALES
GROUP BY CANAL_RAW, CANAL_NORMALIZADO
ORDER BY registros DESC;

-- ------------------------------------------------------------
-- 5. Fechas en bruto
-- ------------------------------------------------------------
SELECT
  FECHA_VENTA,
  COUNT(*) AS registros
FROM BRONZE.RAW_VENTAS
GROUP BY FECHA_VENTA
ORDER BY FECHA_VENTA
LIMIT 50;

-- ------------------------------------------------------------
-- 6. Métricas en bruto
-- En Bronze todavía no forzamos tipado definitivo.
-- El objetivo es detectar formatos antes de transformar.
-- ------------------------------------------------------------
SELECT
  VOLUMEN_HL,
  INGRESOS_EUR,
  DESCUENTO_EUR
FROM BRONZE.RAW_VENTAS
LIMIT 50;

-- ------------------------------------------------------------
-- 7. Nulos o vacíos relevantes
-- ------------------------------------------------------------
SELECT
  COUNT(*) AS filas,
  SUM(CASE WHEN ID_VENTA IS NULL OR TRIM(ID_VENTA) = '' THEN 1 ELSE 0 END) AS id_venta_vacio,
  SUM(CASE WHEN FECHA_VENTA IS NULL OR TRIM(FECHA_VENTA) = '' THEN 1 ELSE 0 END) AS fecha_vacia,
  SUM(CASE WHEN ID_PRODUCTO IS NULL OR TRIM(ID_PRODUCTO) = '' THEN 1 ELSE 0 END) AS producto_vacio,
  SUM(CASE WHEN CANAL IS NULL OR TRIM(CANAL) = '' THEN 1 ELSE 0 END) AS canal_vacio,
  SUM(CASE WHEN DESCUENTO_EUR IS NULL OR TRIM(DESCUENTO_EUR) = '' THEN 1 ELSE 0 END) AS descuento_vacio
FROM BRONZE.RAW_VENTAS;

-- ------------------------------------------------------------
-- 8. Duplicados por identificador de venta
-- ------------------------------------------------------------
SELECT
  ID_VENTA,
  COUNT(*) AS apariciones
FROM BRONZE.RAW_VENTAS
GROUP BY ID_VENTA
HAVING COUNT(*) > 1
ORDER BY apariciones DESC, ID_VENTA;

-- ------------------------------------------------------------
-- 9. Integridad referencial preliminar
-- Ventas con productos no localizados en el maestro.
-- ------------------------------------------------------------
SELECT DISTINCT v.ID_PRODUCTO
FROM BRONZE.RAW_VENTAS v
LEFT JOIN BRONZE.RAW_PRODUCTOS p
  ON UPPER(TRIM(v.ID_PRODUCTO)) = UPPER(TRIM(p.ID_PRODUCTO))
WHERE p.ID_PRODUCTO IS NULL;

-- ------------------------------------------------------------
-- 10. Diagnóstico para Silver
-- ------------------------------------------------------------
-- Preguntas que debe resolver la siguiente capa:
-- - ¿Qué campos deben tiparse como fecha, número o texto?
-- - ¿Qué categorías deben normalizarse?
-- - ¿Qué duplicados deben eliminarse o consolidarse?
-- - ¿Qué reglas de calidad hay que aplicar antes de modelar?
-- - ¿Cuál es la granularidad correcta para cruzar ventas y objetivos?
