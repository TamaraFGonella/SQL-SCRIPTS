DECLARE @drives TABLE (
Drive CHAR(1),				
FreeSpaceInBytes INT
)				
INSERT INTO @drives (Drive, FreeSpaceInBytes)
EXEC xp_fixeddrives
SELECT				
Drive AS 'Unidad',
CAST(FreeSpaceInBytes / 1024.0 AS DECIMAL(10, 2)) AS 'EspacioDisponibleGB'
FROM @drives	
