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
        BEGIN TRANSACTION;

        DECLARE @Token VARCHAR(255) = LEFT(REPLACE(CONVERT(VARCHAR(36), NEWID()), '-', ''), 10);

        DECLARE @UserToken NVARCHAR(255) = (SELECT Tocken from UserLoginToken WHERE UserID = (SELECT UserID from users WHERE Email = @Email));

        IF (@UserToken) IS NULL
        BEGIN
            INSERT INTO UserLoginToken (UserID, Tocken) VALUES 
            ( (SELECT UserID from users WHERE Email = @Email), @Token );
        END
        ELSE
        BEGIN
            UPDATE UserLoginToken SET Tocken = @Token, DateUpdate = SYSUTCDATETIME()  
            WHERE UserID = (SELECT UserID from users WHERE Email = @Email);
        END

        SELECT 
            U.UserID, U.FirstName, U.FathersName, U.Email, U.PasswordHash, U.IsActive, U.Role, U.AvatarImage, UT.Tocken
        FROM users U
        INNER JOIN UserLoginToken UT ON U.UserID = UT.UserID
        WHERE Email = @Email
        FOR JSON PATH;

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
        WHERE code = 20
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

    END CATCH
END

--SELECT * FROM users;

--SELECT * FROM UserLoginToken;

--delete from users;

--exec Singin '{"Email": "admin@example.com", "Password": "AQAAAAIAAYagAAAAEDcBLGx7qXUkgQYyKn/vKYeGL9MZjIVzWI0b9tPM7watOAzUVnHt852IDesA7Dvhsg=="}';