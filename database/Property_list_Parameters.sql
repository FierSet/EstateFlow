CREATE OR ALTER PROCEDURE Property_list_Parameters
as
BEGIN
	
	SELECT
	(
		SELECT * FROM Propertyverificationtype
		ORDER BY propertyverificationtypeID ASC
		FOR JSON PATH
	) AS Propertyverificationtype,
	(
		SELECT * FROM RoomType
		ORDER BY RoomTypeID ASC
		FOR JSON PATH
	) AS RoomType,
	(
		SELECT * FROM PropertyType
		ORDER BY PropertyTypeID ASC
		FOR JSON PATH
	) AS PropertyType,
	(
		SELECT * FROM STATUS
		ORDER BY StatusID ASC
		FOR JSON PATH
	) AS STATUS
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

END

--EXEC Property_list_Parameters;