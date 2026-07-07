CREATE OR ALTER PROCEDURE Create_alter_property
@json varchar(max) = null
AS
BEGIN
	
	DECLARE @ID INT = JSON_VALUE(@json, '$.Usercreids.ID');
	DECLARE @Email NVARCHAR(255) = JSON_VALUE(@json, '$.Usercreids.Email');
    DECLARE @Property NVARCHAR(max) = JSON_VALUE(@json, '$.Property');
    DECLARE @PropertyID NVARCHAR(max) = JSON_VALUE(@json, '$.Property.PropertyID');
    DECLARE @Rooms NVARCHAR(max) = JSON_VALUE(@json, '$.Property.Rooms');

	DECLARE @errormessage NVARCHAR(max) = 
    '
    [
		{
            "code": 20,
            "message" : "User don´t exist"
        },
        {
            "code": 94,
            "message" : "Owner Error. you aren´t an ouwner"
        },
		{
            "code": 95,
            "message" : "Property added"
        },
		{
            "code": 96,
            "message" : "Property updated"
        },
		{
            "code": 99,
            "message" : "Property Not updated"
        }]';
	
	IF NOT EXISTS(SELECT 1 FROM users WHERE Email = @Email AND UserID = @ID)
	BEGIN

		SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 20
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

		RETURN;
	END

    BEGIN TRY   

        BEGIN TRANSACTION;
        --WILL ADD DOCUMENTATION VERIFICATION HERE

        IF @PropertyID IS NOT NULL
        AND NOT EXISTS
        (
            SELECT 1
            FROM PropertyOwners po
            INNER JOIN Properties p
                ON p.PropertyID = po.PropertyID
            WHERE po.OwnerID = @ID
              AND po.PropertyID = @PropertyID
        )
        BEGIN
            SELECT code, message
            FROM OPENJSON(@ErrorMessage)
                WITH
                (
                    code INT,
                    message NVARCHAR(255)
                )
            WHERE code = 94
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
        
		    RETURN;
        END

        --WILL ADD DOCUMENTATION VERIFICATION HERE
        DECLARE @Propertygot TABLE
        (
            PropertyID INT
        );
        --add property_________________________________
        MERGE INTO Properties AS P
        USING
        (
            SELECT *
            FROM OPENJSON(@json, '$.Property')
            WITH
            (
                PropertyID    INT,
                Title         NVARCHAR(100),
                Description   NVARCHAR(MAX),
                Country        NVARCHAR(100),
                Address       NVARCHAR(200),
                City          NVARCHAR(100),
                State         NVARCHAR(100),
                ZipCode       NVARCHAR(20),
                PropertyType  INT,
                AREA          DECIMAL(10,2),
                STATUS        INT,
                RentPrice     DECIMAL(15,2),
                SalePrice     DECIMAL(15,2),
                Imageurl      NVARCHAR(500)
            ) 
        ) AS J
        ON P.PropertyID = J.PropertyID

        WHEN MATCHED THEN
            UPDATE SET
               P.Title = ISNULL(J.Title, P.Title), P.Description = ISNULL(J.Description, P.Description), P.Country = ISNULL(J.Country, P.Country),
               P.Address = ISNULL(J.Address, P.Address), P.City = ISNULL(J.City, P.City),  P.State = ISNULL(J.State, P.State),
               P.ZipCode = ISNULL(J.ZipCode,  P.ZipCode),  P.PropertyType = ISNULL(J.PropertyType, P.PropertyType),
               P.AREA = ISNULL(J.AREA, P.AREA), P.STATUS = ISNULL(J.STATUS, P.STATUS),
               P.RentPrice = ISNULL(J.RentPrice, P.RentPrice), P.SalePrice = ISNULL(J.SalePrice, P.SalePrice), P.Imageurl = ISNULL(J.Imageurl, P.Imageurl)
        WHEN NOT MATCHED THEN
            INSERT
            (
                Title, Description, Country, Address,
                City, State, ZipCode, PropertyType,
                AREA, STATUS, RentPrice, SalePrice, Imageurl
            )
            VALUES
            (
                J.Title, J.Description, J.Country,  J.Address,
                J.City, J.State, J.ZipCode, J.PropertyType, J.AREA,
                J.STATUS, J.RentPrice, J.SalePrice, J.Imageurl
            )
        OUTPUT INSERTED.PropertyID
        INTO @Propertygot;

        --add property_________________________________

        DECLARE @PropertyIDadded INT;

        SELECT TOP (1)
            @PropertyIDAdded = PropertyID
        FROM @Propertygot;

        --add rooms_________________________________
        MERGE INTO ROOMS AS R
        USING
        (
            SELECT *
            FROM OPENJSON(@json, '$.Property.Rooms')
            WITH
            (
                RoomID INT, Remove BIT,Size DECIMAL(15,2),
                Description NVARCHAR(255), RoomType INT, Imageurl NVARCHAR(255)
            )
        ) AS J
        ON R.RoomID = J.RoomID AND R.PropertyID = @PropertyIDAdded

        WHEN MATCHED AND J.Remove = 1 THEN
            DELETE

        WHEN MATCHED THEN
            UPDATE SET
                R.Size = ISNULL(J.Size,  R.Size),
                R.Description = ISNULL(J.Description, R.Description),
                R.RoomType = ISNULL(J.RoomType, R.RoomType),
                R.Imageurl = ISNULL(J.Imageurl, R.Imageurl)

        WHEN NOT MATCHED THEN
            INSERT
            (
                PropertyID, Size, Description,
                RoomType, Imageurl
            )
            VALUES
            (
                @PropertyIDAdded, J.Size, J.Description,
                J.RoomType, J.Imageurl
            );
        --add rooms_________________________________

        --add OWNER_________________________________
        if NOT EXISTS(SELECT 1 FROM PropertyOwners WHERE OwnerID = @ID AND PropertyID = @PropertyIDAdded)
        BEGIN
            INSERT INTO PropertyOwners
            (
                PropertyID,
                OwnerID,
                OwnershipPercentage
            )
            VALUES
            (
                @PropertyIDAdded,
                @ID,
                100
            );
        END

        --add OWNER_________________________________

        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 95
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

        COMMIT TRANSACTION;
        RETURN;

    END TRY
    BEGIN CATCH

         IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 99
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

		RETURN; --THROW;
    END CATCH

    
END

--select * from ROOMS;

/*
EXEC Create_alter_property '{
    "Usercreids": {
        "ID": 1,
        "Email": "admin@example.com",
        "IsActive": true
    },
    "Property": {
        "Rooms": [
            {
                "RoomID": 3,
                "PropertyID": 2,
                "Remove": "undefined",
                "Size": 123,
                "Description": "un cuarto bien chido",
                "RoomType": 1,
                "Imageurl": "https://www.livehome3d.com/assets/img/articles/rooms-in-house/luxurious-living-room@2x.jpg"
            },
            {
                "RoomID": 4,
                "PropertyID": 2,
                "Remove": "undefined",
                "Size": 123,
                "Description": "Una cocina bien chida",
                "RoomType": 1,
                "Imageurl": "https://www.harveyjones.com/wp-content/uploads/2017/08/modern-kitchen-design_full-1-1.jpg"
            }
        ],
        "PropertyID": 2,
        "Title": "casachida",
        "Description": "casa bien chida",
        "Country": "mexico",
        "Address": "un lugar bien chido",
        "City": "una ciudad bien chida",
        "State": "un estado bien chido",
        "ZipCode": "un zc bien chido",
        "PropertyType": 1,
        "AREA": 1000,
        "STATUS": 1,
        "RentPrice": 3000,
        "SalePrice": 100000,
        "Imageurl": "https://www.bhg.com/thmb/3Vf9GXp3T-adDlU6tKpTbb-AEyE=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/white-modern-house-curved-patio-archway-c0a4a3b3-aa51b24d14d0464ea15d36e05aa85ac9.jpg"
    }
}'
*/
/*
SELECT * FROM PropertyOwners;
SELECT * FROM Properties;
SELECT * FROM ROOMS;

DELETE FROM ROOMS;
DELETE FROM Properties;

*/