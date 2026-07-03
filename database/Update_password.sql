CREATE OR ALTER PROCEDURE Update_password
@json varchar(max) = null
AS
BEGIN
	
	DECLARE @Email VARCHAR(255) = JSON_VALUE(@json, '$.Email');
	DECLARE @NewPassword NVARCHAR(255) = JSON_VALUE(@json, '$.Password');

	DECLARE @errormessage NVARCHAR(max) = 
    '
    [
        {
            "code": 16,
            "message" : "Email or Password Empty"
        },
        {
            "code": 20,
            "message" : "User don´t exist"
        },
        {
            "code": 57,
            "message": "Password updated"
        },
        {
            "code": 32,
            "message" : "Account error: Please reloggin"
        },
        {
            "code": 22,
            "message": "user found"
        }
      ]';
	
	IF @Email IS NULL OR @NewPassword IS NULL
    BEGIN
        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 16
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

        RETURN;
    END

    IF NOT EXISTS(SELECT 1 FROM users WHERE Email = @Email)
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
            PasswordHash = @NewPassword 
        WHERE Email = @Email;

        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 57
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
        WHERE code = 32
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

        RETURN; --THROW;

    END CATCH

END

--exec Update_password '{"Email":"admin@example.com","Password":"AQAAAAIAAYagAAAAEJFXI\u002BNblvEmm4NsVaPx\u002BhR8Z7GcJdKwjyayjX0cwE2je3KS4IS0u5QE2cIWjk4AnA=="}';