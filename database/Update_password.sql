CREATE OR ALTER PROCEDURE Update_password
@json varchar(max) = null
AS
BEGIN
	
	DECLARE @Email VARCHAR(255) = JSON_VALUE(@json, '$.user.Email');
	DECLARE @NewPassword NVARCHAR(255) = JSON_VALUE(@json, '$.user.Password');
    DECLARE @Tocken NVARCHAR(255) = JSON_VALUE(@json, '$.token');

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
        },
        {
            "code": 105,
            "message" : "Session expire"
        }
      ]';

    --tocken validation____________________________________________________________________________________________________________
    DECLARE @UserID INT = (SELECT UserID FROM users WHERE Email = @Email);
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

--exec Update_password '{"user":{"Email":"admin@example.com","Password":"AQAAAAIAAYagAAAAEOV0bk/YWCriyn7TIEcF1q3n91k7sIA/645h2nB25dnQJrkFgqN6dIvR9vdtCT/pMA=="}, "token":"9618F0EEB9" }';
--SELECT * FROM UserLoginToken;