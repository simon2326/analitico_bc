-- Normalizar la columna nombre a mayúsculas y quitar espacios extra
UPDATE clientes
SET nombre = UPPER(LTRIM(RTRIM(nombre)));

-- Se crean las columnas adicionales 
ALTER TABLE clientes ADD
    nombres NVARCHAR(100),
    apellidos NVARCHAR(100),
    edad INT;

-- Crear columna temporal para detectar si es empresa
ALTER TABLE clientes ADD es_empresa BIT;

-- Se actualiza la columna de nombres y apellidos según número de palabras. La lógica es la siguiente:
-- 1. Si el nombre tiene cuatro palabras o más, se considera que las primeras dos son nombres y las últimas dos apellidos.
-- 2. Si el nombre tiene tres palabras, se toma la primera como nombre y las otras dos como apellidos.
-- 3. Si el nombre tiene dos palabras, la primera es nombre y la segunda apellido.
-- 4. Si tiene una sola palabra podría ser una empresa, se deja el nombre completo y se dejan NULL los apellidos.

-- Marcar como empresa si contiene palabras clave o caracteres especiales
UPDATE clientes
SET es_empresa = CASE
    -- Si contiene indicios de empresa Y NO contiene ciertos apellidos/personas
    WHEN (
        nombre LIKE '% SAS%' 
        OR nombre LIKE '% S.A.S%' 
        OR nombre LIKE '% S.A%' 
        OR nombre LIKE '% LTDA%' 
        OR nombre LIKE '% LTD%' 
        OR nombre LIKE '% CIA%' 
        OR nombre LIKE '% S. EN C%' 
        OR nombre LIKE '% &%' 
        OR nombre LIKE '%.%' 
        OR nombre LIKE '%[0-9]%'
    )
    AND nombre NOT LIKE '% SASTOQUE%'
    AND nombre NOT LIKE '% SASSO%'
    AND nombre NOT LIKE '% SASCHA%'
    AND nombre NOT LIKE '% SASSON%'
	AND nombre NOT LIKE '% CIANCI%'
    THEN 1
    ELSE 0
END;

-- Lógica para nombres y apellidos (Si es empresa solo queda el nombre)
UPDATE clientes
SET
    nombres = CASE
        WHEN es_empresa = 1 THEN nombre  -- Si es empresa, se guarda completo en nombres

        -- Nombres con preposiciones
        WHEN (
            nombre LIKE '% DEL %' OR
			nombre LIKE '% DE LA %' OR 
            nombre LIKE '% DE LOS %' OR
			nombre LIKE '% DE %'
        )
        AND LEN(nombre) - LEN(REPLACE(nombre, ' ', '')) >= 3 THEN
            LEFT(nombre, LEN(nombre) - CHARINDEX(' ', REVERSE(nombre), CHARINDEX(' ', REVERSE(nombre), CHARINDEX(' ', REVERSE(nombre)) + 1) + 1))

        WHEN LEN(nombre) - LEN(REPLACE(nombre, ' ', '')) >= 3 THEN 
            CONCAT(PARSENAME(REPLACE(nombre, ' ', '.'), 4), ' ', PARSENAME(REPLACE(nombre, ' ', '.'), 3))
        WHEN LEN(nombre) - LEN(REPLACE(nombre, ' ', '')) = 2 THEN 
            PARSENAME(REPLACE(nombre, ' ', '.'), 3)
        WHEN LEN(nombre) - LEN(REPLACE(nombre, ' ', '')) = 1 THEN 
            PARSENAME(REPLACE(nombre, ' ', '.'), 2)
        ELSE NULL
    END,

    apellidos = CASE
        WHEN es_empresa = 1 THEN NULL

        -- Apellidos con preposiciones y al menos 4 palabras
        WHEN (
            nombre LIKE '% DEL %' OR
			nombre LIKE '% DE LA %' OR 
            nombre LIKE '% DE LOS %' OR
			nombre LIKE '% DE %'
        )
        AND LEN(nombre) - LEN(REPLACE(nombre, ' ', '')) >= 3 THEN
            RIGHT(nombre, CHARINDEX(' ', REVERSE(nombre), CHARINDEX(' ', REVERSE(nombre), CHARINDEX(' ', REVERSE(nombre)) + 1) + 1) - 1)

        WHEN LEN(nombre) - LEN(REPLACE(nombre, ' ', '')) >= 3 THEN 
            CONCAT(PARSENAME(REPLACE(nombre, ' ', '.'), 2), ' ', PARSENAME(REPLACE(nombre, ' ', '.'), 1))
        WHEN LEN(nombre) - LEN(REPLACE(nombre, ' ', '')) = 2 THEN 
            CONCAT(PARSENAME(REPLACE(nombre, ' ', '.'), 2), ' ', PARSENAME(REPLACE(nombre, ' ', '.'), 1))
        WHEN LEN(nombre) - LEN(REPLACE(nombre, ' ', '')) = 1 THEN 
            PARSENAME(REPLACE(nombre, ' ', '.'), 1)
        ELSE NULL
    END;


-- Calcular la edad con base en la fecha de nacimiento
UPDATE clientes
SET edad = DATEDIFF(YEAR, fecha_nacimiento, GETDATE());

ALTER TABLE clientes
DROP COLUMN nombre;