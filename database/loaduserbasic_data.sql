CREATE OR ALTER PROCEDURE Loadbasicdata
@json varchar(max) = NULL
AS
BEGIN
	DECLARE @ID INT = JSON_VALUE(@JSON, '$.ID');
	DECLARE @Email NVARCHAR(255) = JSON_VALUE(@JSON, '$.Email');
	DECLARE @Tocken NVARCHAR(255) = JSON_VALUE(@JSON, '$.Tocken');

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
	

	SELECT
	(
		SELECT 
			USR.UserID,
			USR.Email,
			COALESCE(USR.FirstName, '') AS FirstName,
			COALESCE(USR.SecondName, '') AS SecondName, 
			COALESCE(USR.FathersName, '') AS FathersName, 
			COALESCE(USR.MothersName, '') AS MothersName, 
			COALESCE(USR.Phone, '') AS Phone, 
			USR.AvatarImage,
			USR.IsActive, 
			R.role_name
		FROM users USR
		LEFT JOIN Role R ON USR.Role = R.role_id
		WHERE USR.UserID = @ID
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
	) AS Users,
	(
		SELECT  
			COALESCE(usertax.TaxID, '') AS TaxID, 
			COALESCE(usertax.UserID, '') AS UserID,  
			COALESCE(TAXTYPE.COUNTRY, '') AS COUNTRY, 
			COALESCE(TAXTYPE.TypeName, '') AS TypeName, 
			COALESCE(usertax.imageURL, '') AS imageURL 
		FROM User_fiscal_info usertax
		LEFT JOIN TaxIDType TAXTYPE ON usertax.TaxIDtype = TAXTYPE.TaxIDTypeID
		WHERE usertax.UserID = @ID
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
	) AS User_fiscal_info
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

END

--EXEC Loadbasicdata '{"ID":1, "Email":"admin@example.com"}'