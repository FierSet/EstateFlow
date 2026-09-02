CREATE OR ALTER PROCEDURE load_lease
@json VARCHAR(MAX) = NULL
AS
BEGIN
	
	DECLARE @ID INT = JSON_VALUE(@json, '$.Usercreids.ID');

	SELECT
	    R.RentID,
        R.propertyID,
        P.Title,
        p.PropertyType,

        R.Lordland,
        LL.FirstName AS TenantName,
        LL.FathersName AS LandlordLastName,

        R.TenantID,
        T.FirstName  AS TenantName,
        T.FathersName AS TenantLastName,

        R.GuarantorID,
        G.FirstName AS GuarantorName,
        G.FathersName AS GuarantorLastName,

        R.StartDate,
        R.EndDate,
        R.GuaranteeAmount,
        R.MonthlyRent,
        R.EvidenceID
    FROM Rent R
    INNER JOIN Users LL
    ON R.Lordland = LL.UserID

    INNER JOIN Users T
        ON R.TenantID = T.UserID

    INNER JOIN Users G
        ON R.GuarantorID = G.UserID
    INNER JOIN Properties P ON  R.propertyID = P.PropertyID
    
    WHERE R.Lordland = @ID OR R.TenantID = @ID OR R.GuarantorID = @ID
    FOR JSON PATH;

END

/*

EXEC load_lease '{
    "Usercreids": {
        "ID": "1"
    }
}'

*/