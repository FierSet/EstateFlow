CREATE OR ALTER PROCEDURE Singup
@json varchar(MAX) = NULL
AS
BEGIN
    
    DECLARE @Email NVARCHAR(255) = JSON_VALUE(@JSON, '$.Email');
    DECLARE @Password NVARCHAR(255) = JSON_VALUE(@JSON, '$.Password');

    DECLARE @errormessage NVARCHAR(max) = 
    '
    [
        {
            "code": 16,
            "message" : "Email or Password Empty"
        },
        {
            "code": 17,
            "message" : "User Already exist"
        },
        {
            "code": 18,
            "message": "user not created"
        },
        {
            "code": 19,
            "message": "user created"
        }]';

    IF @Password IS NULL OR @Email IS NULL
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

    IF EXISTS(SELECT 1 FROM users WHERE Email = @Email)
    BEGIN
        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 17
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

        RETURN;
    END

    BEGIN try
        BEGIN TRANSACTION;

        INSERT INTO users (Email, PasswordHash, Role, IsActive) 
              values (@Email, @Password, 1, 0);

        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 19
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

        COMMIT TRANSACTION;
        RETURN;

    end try
    BEGIN catch

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 18
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

        RETURN; --THROW;
    END CATCH

END

--SELECT * FROM users;
--exec Singup '{"Email": "admin@example.com", "Password": ""}';