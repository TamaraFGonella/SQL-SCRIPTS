-- Define los servidores que quieres comparar
DECLARE @server1 VARCHAR(100) = '192.168.1.10';  -- IP del servidor 1
DECLARE @server2 VARCHAR(100) = '192.168.1.20';  -- IP del servidor 2
DECLARE @database VARCHAR(100) = 'DatabaseName';

-- Obtiene la información de intercalación para el servidor 1
DECLARE @collation1 VARCHAR(100);
SELECT @collation1 = SERVERPROPERTY('Collation') FROM sys.servers WHERE name = @server1;

-- Obtiene la información de intercalación para el servidor 2
DECLARE @collation2 VARCHAR(100);
SELECT @collation2 = SERVERPROPERTY('Collation') FROM sys.servers WHERE name = @server2;

-- Compara las intercalaciones
IF @collation1 = @collation2
BEGIN
    PRINT 'Las intercalaciones de los servidores son iguales.';
END
ELSE
BEGIN
    PRINT 'Las intercalaciones de los servidores son diferentes.';
    PRINT 'Intercalación del servidor 1: ' + @collation1;
    PRINT 'Intercalación del servidor 2: ' + @collation2;
END;

-- Si se define una base de datos, compara la intercalación de la base de datos
IF @database IS NOT NULL
BEGIN
    -- Obtiene la información de intercalación para la base de datos en el servidor 1
    DECLARE @databaseCollation1 VARCHAR(100);
    SELECT @databaseCollation1 = collation_name FROM sys.databases WHERE name = @database AND source_database_id = 0;

    -- Obtiene la información de intercalación para la base de datos en el servidor 2
    DECLARE @databaseCollation2 VARCHAR(100);
    SELECT @databaseCollation2 = collation_name FROM sys.databases WHERE name = @database AND source_database_id = 0;

    -- Compara las intercalaciones de la base de datos
    IF @databaseCollation1 = @databaseCollation2
    BEGIN
        PRINT 'Las intercalaciones de la base de datos en ambos servidores son iguales.';
    END
    ELSE
    BEGIN
        PRINT 'Las intercalaciones de la base de datos en ambos servidores son diferentes.';
        PRINT 'Intercalación de la base de datos en el servidor 1: ' + @databaseCollation1;
        PRINT 'Intercalación de la base de datos en el servidor 2: ' + @databaseCollation2;
    END;
END;
