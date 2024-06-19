
-- Tabla temporal para almacenar los resultados
CREATE TABLE #DiskSpaceInfo (
    DatabaseName NVARCHAR(128),
    DriveLetter NVARCHAR(5),
    TotalSpaceGB DECIMAL(18,2),
    UsedSpaceGB DECIMAL(18,2),
    FreeSpaceGB DECIMAL(18,2)
);

-- Consulta para obtener información de los discos de data y log en GB
INSERT INTO #DiskSpaceInfo (DatabaseName, DriveLetter, TotalSpaceGB, UsedSpaceGB, FreeSpaceGB)
EXEC [master].[dbo].[xp_fixeddrives];

-- Consulta para obtener tamaño de los archivos de data y log de una base de datos específica en GB
WITH DatabaseFilesCTE AS (
    SELECT 
        DB_NAME(database_id) AS DatabaseName,
        type_desc AS FileType,
        physical_name AS PhysicalFileName,
        size * 8.0 / 1024 / 1024 AS FileSizeGB,
        FILEPROPERTY(name, 'SpaceUsed') * 8.0 / 1024 / 1024 AS UsedSpaceGB,
        (size - FILEPROPERTY(name, 'SpaceUsed')) * 8.0 / 1024 / 1024 AS FreeSpaceGB
    FROM sys.master_files
)
INSERT INTO #DiskSpaceInfo (DatabaseName, DriveLetter, TotalSpaceGB, UsedSpaceGB, FreeSpaceGB)
SELECT 
    DatabaseName,
    LEFT(PhysicalFileName, 1) AS DriveLetter,
    SUM(FileSizeGB) AS TotalSpaceGB,
    SUM(UsedSpaceGB) AS UsedSpaceGB,
    SUM(FreeSpaceGB) AS FreeSpaceGB
FROM DatabaseFilesCTE
GROUP BY DatabaseName, LEFT(PhysicalFileName, 1);

-- Consulta final para mostrar los resultados en GB
SELECT 
    DatabaseName,
    DriveLetter,
    TotalSpaceGB,
    UsedSpaceGB,
    FreeSpaceGB
FROM #DiskSpaceInfo;

-- Eliminar tabla temporal
DROP TABLE #DiskSpaceInfo;
