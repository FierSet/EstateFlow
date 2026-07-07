CREATE OR ALTER PROCEDURE Load_dashboard
@JSON VARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @ID INT = JSON_VALUE(@json, '$.ID');

	SELECT
	(
		SELECT 
			P.PropertyType,
			COUNT(*) AS TOTAL
		FROM Properties AS P
		INNER JOIN PropertyOwners PO 
			ON P.PropertyID = PO.PropertyID
		WHERE PO.OwnerID = @ID
		GROUP BY P.PropertyType
		FOR JSON PATH
	) AS Propertycount
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

END
/*
EXEC Load_dashboard '{"ID":1,"Email":"admin@example.com","IsActive":false}';

SELECT P.PropertyType, COUNT(P.PropertyType) FROM Properties AS P
INNER JOIN PropertyOwners PO ON P.PropertyID = PO.PropertyID 
WHERE PO.OwnerID = 1;
*/