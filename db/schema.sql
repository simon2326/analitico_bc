-- =============================================
-- CREACIÓN DE TABLAS Y RELACIONES
-- Autor: Simón Correa Marín
-- Fecha: 06/07/2025
-- Descripción: Script para construir el esquema completo
--              de la base de datos relacional con claves
--              primarias y foráneas.
-- =============================================

-- =========================
-- Tabla: cat_tip_doc
-- =========================
CREATE TABLE cat_tip_doc (
    cod_tip_doc INT PRIMARY KEY,                         -- PK
    desc_tip_doc VARCHAR(20) NOT NULL
);

-- =========================
-- Tabla: cat_genero
-- =========================
CREATE TABLE cat_genero (
    cod_genero VARCHAR(1) PRIMARY KEY,                   -- PK
    desc_genero VARCHAR(15) NOT NULL
);

-- =========================
-- Tabla: cat_region
-- =========================
CREATE TABLE cat_region (
    cod_region VARCHAR(2) PRIMARY KEY,                   -- PK
    desc_region VARCHAR(30) NOT NULL
);

-- =========================
-- Tabla: cat_pais
-- =========================
CREATE TABLE cat_pais (
    cod_pais VARCHAR(3) PRIMARY KEY,                     -- PK
    desc_pais VARCHAR(20) NOT NULL
);

-- =========================
-- Tabla: cat_departamento
-- =========================
CREATE TABLE cat_departamento (
    cod_departamento VARCHAR(3) PRIMARY KEY,             -- PK
    desc_departamento VARCHAR(25) NOT NULL,
    cod_pais VARCHAR(3) NOT NULL,                        -- FK a cat_pais
    FOREIGN KEY (cod_pais) REFERENCES cat_pais(cod_pais)
);

-- =========================
-- Tabla: cat_ciudad
-- =========================
CREATE TABLE cat_ciudad (
    cod_ciudad VARCHAR(12) PRIMARY KEY,                  -- PK
    desc_ciudad VARCHAR(35) NOT NULL,
    cod_departamento VARCHAR(3) NOT NULL,                -- FK a cat_departamento
    cod_pais VARCHAR(3) NOT NULL,                        -- FK a cat_pais
    FOREIGN KEY (cod_departamento) REFERENCES cat_departamento(cod_departamento),
    FOREIGN KEY (cod_pais) REFERENCES cat_pais(cod_pais)
);

-- =========================
-- Tabla: cat_zona
-- =========================
CREATE TABLE cat_zona (
    cod_pais_region_zona VARCHAR(7) PRIMARY KEY,         -- PK
    desc_zona VARCHAR(50) NOT NULL,
    cod_region VARCHAR(2) NOT NULL,                      -- FK a cat_region
    cod_pais VARCHAR(3) NOT NULL,                        -- FK a cat_pais
    FOREIGN KEY (cod_region) REFERENCES cat_region(cod_region),
    FOREIGN KEY (cod_pais) REFERENCES cat_pais(cod_pais)
);

-- =========================
-- Tabla: cat_sucursal
-- =========================
CREATE TABLE cat_sucursal (
    cod_sucursal INT PRIMARY KEY,                        -- PK
    desc_sucursal VARCHAR(50) NOT NULL,
    cod_pais_region_zona VARCHAR(7) NOT NULL,            -- FK a cat_zona
    cod_ciudad VARCHAR(12) NOT NULL,                     -- FK a cat_ciudad
    FOREIGN KEY (cod_pais_region_zona) REFERENCES cat_zona(cod_pais_region_zona),
    FOREIGN KEY (cod_ciudad) REFERENCES cat_ciudad(cod_ciudad)
);

-- =========================
-- Tabla: clientes
-- =========================
CREATE TABLE clientes (
    id INT PRIMARY KEY,                                  -- PK
    cod_tip_doc INT NOT NULL,                            -- FK a cat_tip_doc
    cod_genero VARCHAR(1) NOT NULL,                      -- FK a cat_genero
    nombre VARCHAR(65) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    ingresos DECIMAL(12, 2) NOT NULL,
    cod_sucursal INT NOT NULL,                           -- FK a cat_sucursal
    FOREIGN KEY (cod_tip_doc) REFERENCES cat_tip_doc(cod_tip_doc),
    FOREIGN KEY (cod_genero) REFERENCES cat_genero(cod_genero),
    FOREIGN KEY (cod_sucursal) REFERENCES cat_sucursal(cod_sucursal)
);
