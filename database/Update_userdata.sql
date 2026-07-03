CREATE OR ALTER PROCEDURE update_userdata
@json varchar(max)
AS
BEGIN
	
	DECLARE @ID INT = JSON_VALUE(@json, '$.Usercreids.ID');
	DECLARE @Email NVARCHAR(255) = JSON_VALUE(@json, '$.Usercreids.Email');
	DECLARE @FirstName NVARCHAR(255) = JSON_VALUE(@json, '$.Userdata.FirstName');
	DECLARE @SecondName NVARCHAR(255) = JSON_VALUE(@json, '$.Userdata.SecondName');
	DECLARE @FathersName NVARCHAR(255) = JSON_VALUE(@json, '$.Userdata.FathersName');
	DECLARE @MothersName NVARCHAR(255) = JSON_VALUE(@json, '$.Userdata.MothersName');
	DECLARE @Phone NVARCHAR(255) = JSON_VALUE(@json, '$.Userdata.Phone');
	DECLARE @Image NVARCHAR(255) = JSON_VALUE(@json, '$.Userdata.AvatarImage');

	DECLARE @errormessage NVARCHAR(max) = 
    '
    [
		{
            "code": 20,
            "message" : "User don´t exist"
        },
        {
            "code": 32,
            "message" : "Account error: Please reloggin"
        },
		{
            "code": 56,
            "message" : "Updated successfull"
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

		UPDATE users SET 
			FirstName = ISNULL(@FirstName, FirstName),
			SecondName = ISNULL(@SecondName, SecondName),
			FathersName = ISNULL(@FathersName, FathersName),
			MothersName  = ISNULL(@MothersName, MothersName),
			Phone = ISNULL(@Phone, Phone),
			AvatarImage = ISNULL(@Image, AvatarImage)
		WHERE Email = @Email AND UserID = @ID;

		IF NOT EXISTS(SELECT 1
			FROM Users
			WHERE Email = @Email AND UserID = @ID AND (FirstName IS NULL OR TRIM(FirstName) = '' OR
			SecondName IS NULL OR TRIM(SecondName) = '' OR
			FathersName IS NULL OR TRIM(FathersName) = '' OR
			MothersName IS NULL OR TRIM(MothersName) = '' OR
			Phone IS NULL OR TRIM(Phone) = '')
			)
		BEGIN
			UPDATE users SET IsActive = 1
			WHERE Email = @Email;		
		END

		SELECT code, message FROM OPENJSON(@ErrorMessage)
			WITH
			(
				code INT,
				message NVARCHAR(255)
			)
		WHERE code = 56
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

		COMMIT TRANSACTION;
        RETURN;

	END TRY
	BEGIN CATCH
		
		 IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

		SELECT code, message FROM OPENJSON(@ErrorMessage)
			WITH
			(
				code INT,
				message NVARCHAR(255)
			)
		WHERE code = 32
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

		RETURN; --THROW;

	END CATCH
	
END

--EXEC update_userdata '{"ID":7, "Email":"A"}'
--select * from users;