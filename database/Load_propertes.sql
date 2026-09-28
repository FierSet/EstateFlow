CREATE OR ALTER PROCEDURE Load_properties
@json NVARCHAR(max) = null
AS
BEGIN
    DECLARE @ID INT = JSON_VALUE(@json, '$.Usercreids.ID');
	DECLARE @Email NVARCHAR(255) = JSON_VALUE(@json, '$.Usercreids.Email');
	DECLARE @Tocken NVARCHAR(255) = JSON_VALUE(@json, '$.Usercreids.Tocken');

    DECLARE @errormessage NVARCHAR(max) = 
    '
    [
        {
            "code": 105,
            "message" : "Session expire"
        }
      ]';

    --tocken validation____________________________________________________________________________________________________________
    DECLARE @UserID INT = @ID;
    DECLARE @TokenDateUpdate DATETIME = (SELECT DateUpdate FROM UserLoginToken WHERE UserID = @UserID AND Tocken = @Tocken);
    DECLARE @TokenExists VARCHAR(255) = (SELECT Tocken FROM UserLoginToken WHERE UserID = @UserID AND Tocken = @Tocken);
    DECLARE @ValidationTime INT = (SELECT ValidationTime FROM UserLoginTockenvalidatetime);

    IF DATEDIFF(MINUTE, (@TokenDateUpdate), SYSUTCDATETIME()) >= (@ValidationTime) OR
      (@TokenExists) IS NULL
    BEGIN
        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 105
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

		RETURN;
    END
    --tocken validation____________________________________________________________________________________________________________
    DECLARE @Page INT = JSON_VALUE(@json, '$.Page');
    DECLARE @PageSize INT = 4;

    DECLARE @TotalRows INT =
    (
        SELECT COUNT(*)
        FROM PropertyOwners
        WHERE OwnerID = @ID
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
	        WHERE PO.OwnerID = @ID
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
        "ID": "1",
        "Tocken": "B7B2C68B022B477FAE40F91207102F73"
    },
    "Page": 1
}'

SELECT * FROM UserLoginToken
*/