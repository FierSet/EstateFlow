CREATE OR ALTER PROCEDURE Load_properties
@json NVARCHAR(max) = null
AS
BEGIN

    DECLARE @Page INT = JSON_VALUE(@json, '$.Page');
    DECLARE @PageSize INT = 4;

    DECLARE @TotalRows INT =
    (
        SELECT COUNT(*)
        FROM PropertyOwners
        WHERE OwnerID = JSON_VALUE(@json, '$.Usercreids.ID')
    );

    DECLARE @TotalPages INT = CEILING(CAST(@TotalRows AS FLOAT) / @PageSize);

    declare @pageinfor TABLE (Page INT, TotalPages INT, TotalRows INT);

    INSERT INTO @pageinfor values (@Page, @TotalPages, @TotalRows);

    DECLARE @FinalJSON NVARCHAR(MAX);

    SET @FinalJSON = (
        SELECT
        (
            SELECT * FROM @pageinfor
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS PageInfo,
        (
            SELECT
            P.PropertyID, P.Title, P.Description, P.Address,
            P.Country, P.City, P.State, P.ZipCode, P.PropertyType,
            P.AREA,
            P.STATUS,
            P.RentPrice,
            P.SalePrice,
            P.Imageurl,

            (
                SELECT
                    R.RoomID,
                    R.PropertyID,
                    0 AS Remove,
                    R.Size,
                    R.Description,
                    R.RoomType,
                    R.Imageurl
                FROM Rooms AS R
                WHERE R.PropertyID = P.PropertyID
                FOR JSON PATH
            ) AS Rooms

            FROM Properties AS P
            RIGHT JOIN PropertyOwners PO ON PO.PropertyID = P.PropertyID
	        WHERE PO.OwnerID = JSON_VALUE(@json, '$.Usercreids.ID')
            ORDER BY PropertyID DESC
            OFFSET (@Page - 1) * @PageSize ROWS
            FETCH NEXT @PageSize ROWS ONLY
            FOR JSON PATH
        ) 
        AS Properties
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );
    SELECT @FinalJSON AS JsonOutput;
END

/*
EXEC Load_properties '{
    "Usercreids": {
        "ID": "1"
    },
    "Page": 1
}'
*/