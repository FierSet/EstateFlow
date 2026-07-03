CREATE OR ALTER PROCEDURE Singin 
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
            "code": 20,
            "message" : "User don´t exist"
        },
        {
            "code": 21,
            "message": "baned user"
        },
        {
            "code": 22,
            "message": "user found"
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

    IF (SELECT ROLE FROM users WHERE Email = @Email) = 3
    BEGIN
        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 21
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

        RETURN;
    END

    BEGIN TRY

        SELECT UserID, FirstName, FathersName, Email, PasswordHash, IsActive, Role, AvatarImage from users 
        WHERE Email = @Email
        FOR JSON PATH;

    END TRY
    BEGIN CATCH
        
        SELECT code, message
        FROM OPENJSON(@ErrorMessage)
            WITH
            (
                code INT,
                message NVARCHAR(255)
            )
        WHERE code = 20
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

    END CATCH
END

--SELECT * FROM users;

--delete from users;

--exec Singin '{"Email": "admin@example.com", "Password": "123"}';