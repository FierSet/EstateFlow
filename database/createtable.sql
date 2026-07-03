--CREATE DATABASE Realstatesmanager;

USE Realstatesmanager;

DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS SALEPAYMENTS;
DROP TABLE IF EXISTS Ownersaproval;
DROP TABLE IF EXISTS RentPayments;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS Rent;
DROP TABLE IF EXISTS Sale;
DROP TABLE IF EXISTS Evidence;
DROP TABLE IF EXISTS EvidenceType;
DROP TABLE IF EXISTS PropertyOwners;
DROP TABLE IF EXISTS PropertyEvidence;
DROP TABLE IF EXISTS propertyverificationtype;
DROP TABLE IF EXISTS ROOMS;
DROP TABLE IF EXISTS Properties;
DROP TABLE IF EXISTS RoomType;
DROP TABLE IF EXISTS STATUS;
DROP TABLE IF EXISTS PropertyType;
DROP TABLE IF EXISTS User_fiscal_info;
DROP TABLE IF EXISTS TaxIDType;




CREATE TABLE Role ( -- This table defines the different roles that users can have in the system, such as Customer, Agent, and Admin. Each role has a unique identifier and a name.
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(255) NOT NULL UNIQUE

); INSERT INTO Role (role_name) VALUES ('Customer'), ('Agent'), ('Admin'), ('Baned');

CREATE TABLE users ( -- This table stores information about the users of the system, including their name, email, phone number, password hash, role, and account status. Each user has a unique identifier and is associated with a specific role.
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(255),
    SecondName VARCHAR(255),
    FathersName VARCHAR(255),
    MothersName VARCHAR(255),
    AvatarImage varchar(255),
    Email VARCHAR(255) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    PasswordHash VARCHAR(255) NOT NULL,
    Role INT NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
    IsActive BIT DEFAULT 0,

    FOREIGN KEY (Role) REFERENCES Role(role_id)
); --Insert into users (FirstName, SecondName, fathersName, mothersName, Email, Phone, PasswordHash, Role, IsActive) values ('Admin', 'Admin', 'Admin','Admin', 'admin@example.com', '1234567890', 'adminpasswordhash', 1, 1);

create table TaxIDType ( -- This table defines the different types of tax identification numbers that users can have, such as Social Security Number (SSN), Employer Identification Number (EIN), and Tax Identification Number (TIN). Each type has a unique identifier, a country associated with it, and a name.
    TaxIDTypeID INT IDENTITY(1,1) PRIMARY KEY,
    COUNTRY VARCHAR(255) NOT NULL,
    TypeName VARCHAR(255) NOT NULL UNIQUE
); INSERT INTO TaxIDType (COUNTRY, TypeName) VALUES ('MX','RFC'), ('MX','CURP'), ('USA', 'SSN'), ('USA', 'EIN'), ('USA', 'TIN'), ('Other', 'Other');

CREATE TABLE User_fiscal_info ( -- This table stores the fiscal information of users, including their tax identification number, the type of tax ID, and an optional image URL for verification purposes. Each record is associated with a specific user and a specific type of tax ID.
    FiscalInfoID INT IDENTITY(1,1) PRIMARY KEY,
    TaxID VARCHAR(255) NOT NULL UNIQUE,
    UserID INT,
    TaxIDtype INT NOT NULL,
    imageURL VARCHAR(255),

    FOREIGN KEY (UserID) REFERENCES users(UserID),
    FOREIGN KEY (TaxIDtype) REFERENCES TaxIDType(TaxIDTypeID)
);

CREATE TABLE PropertyType ( -- This table defines the different types of properties that can be listed in the system, such as House, Apartment, Condo, and Land. Each type has a unique identifier and a name.
    PropertyTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(255) NOT NULL UNIQUE
); INSERT INTO PropertyType (TypeName) VALUES ('House'), ('Apartment'), ('Condo'), ('Land');

CREATE TABLE STATUS ( -- This table defines the different statuses that a property can have in the system, such as Available, Unavailable, Under Contract, and Sold. Each status has a unique identifier and a name.
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName VARCHAR(255) NOT NULL UNIQUE
); INSERT INTO STATUS (StatusName) VALUES ('Available'), ('Unavailable'), ('Under Contract'), ('Sold'), ('Rented');

CREATE TABLE RoomType ( -- This table defines the different types of rooms that can be associated with a property, such as Living Room, Bedroom, Kitchen, and Bathroom. Each type has a unique identifier and a name.
    RoomTypeID INT IDENTITY(1,1) PRIMARY KEY,
    RoomTypeName VARCHAR(255) NOT NULL UNIQUE
); INSERT INTO RoomType (RoomTypeName) VALUES ('Living Room'), ('Bedroom'), ('Kitchen'), ('Bathroom'), ('Dining Room'), ('Office'), ('Garage'), ('Other');

CREATE TABLE Properties ( -- This table stores information about the properties listed in the system, including their title, description, address, city, state, zip code, price, type, area, status, rental price, sale price, and creation date. Each property has a unique identifier and is associated with a specific property type and status.
    PropertyID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Country varchar(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    ZipCode VARCHAR(20) NOT NULL,
    PropertyType INT NOT NULL,
    AREA DECIMAL(10, 2) NOT NULL,
    Status INT NOT NULL,
    RentPrice MONEY,
    SalePrice MONEY default null,
    Imageurl varchar(255),
    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),

    FOREIGN KEY (PropertyType) REFERENCES PropertyType(PropertyTypeID),
    FOREIGN KEY (Status) REFERENCES STATUS(StatusID)
);

CREATE TABLE ROOMS ( -- This table stores information about the rooms associated with each property, including their size, description, and type. Each room has a unique identifier and is associated with a specific property and room type.
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    PropertyID INT NOT NULL,
    Size DECIMAL(10, 2) NOT NULL,
    Description TEXT,
    RoomType INT NOT NULL,
    Imageurl varchar(255),

    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (RoomType) REFERENCES RoomType(RoomTypeID)
);

CREATE TABLE propertyverificationtype ( -- This table defines the different types of property verification that can be performed in the system, such as Ownership Proof, Property Condition, Legal Compliance, and Other. Each type has a unique identifier and a name.
    PropertyverificationtypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(255) NOT NULL UNIQUE
); INSERT INTO propertyverificationtype (TypeName) VALUES ('Ownership Proof'), ('Property Condition'), ('Legal Compliance'), ('Other');

CREATE TABLE PropertyEvidence ( -- This table stores evidence related to property verification, including the type of verification, an image URL, and a URL for additional verification information. Each record has a unique identifier and is associated with a specific type of property verification.
    PropertyEvidence INT IDENTITY(1,1) PRIMARY KEY,
    propertyverificationtypeID INT NOT NULL,
    ImageURL VARCHAR(255) NOT NULL,
    URLVerification VARCHAR(255) NOT NULL

    FOREIGN KEY (propertyverificationtypeID) REFERENCES propertyverificationtype(PropertyverificationtypeID)
);

CREATE TABLE PropertyOwners ( -- This table stores information about the ownership of properties, including the property ID, owner ID, start date of ownership, ownership percentage, verification status, and associated evidence. Each record has a unique identifier and is associated with a specific property, owner, and property evidence.
    OwnershipID INT IDENTITY(1,1) PRIMARY KEY,
    PropertyID INT NOT NULL,
    OwnerID INT NOT NULL,
    StartDate DATETIME2 DEFAULT SYSUTCDATETIME(),
    OwnershipPercentage DECIMAL(5, 2) NOT NULL,
    VERIFY BIT DEFAULT 0,
    PropertyEvidence INT,


    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (OwnerID) REFERENCES users(UserID),
    FOREIGN KEY (PropertyEvidence) REFERENCES PropertyEvidence(PropertyEvidence),

    CONSTRAINT UQ_PropertyOwners_Property_Owner
    UNIQUE (PropertyID, OwnerID)
);

-------------------------------------- contracts and rents --------------------------------------

CREATE TABLE EvidenceType ( -- This table defines the different types of evidence that can be associated with sales and rentals in the system, such as Contract, Payment Receipt, and Other. Each type has a unique identifier and a name.
    EvidenceTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(255) NOT NULL UNIQUE
); INSERT INTO EvidenceType (TypeName) VALUES ('Contract'), ('Payment Receipt') ,('Other');

CREATE TABLE evidence ( -- This table stores evidence related to sales and rentals, including the date of the evidence, the type of evidence, a description, and a link to a scanned document. Each record has a unique identifier and is associated with a specific type of evidence.
    EvidenceID INT IDENTITY(1,1) PRIMARY KEY,
    EvidenceDate DATE NOT NULL,
    EvidenceTypeID INT NOT NULL,
    Description TEXT,
    SCANlink VARCHAR(255) NOT NULL,

    FOREIGN KEY (EvidenceTypeID) REFERENCES EvidenceType(EvidenceTypeID)
);

CREATE TABLE Sale ( -- This table stores information about property sales, including the property ID, buyer ID, seller ID, contract date, sale price, and associated evidence. Each record has a unique identifier and is associated with a specific property, buyer, seller, and evidence.
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    PropertyID INT NOT NULL,
    BuyerID INT NOT NULL,
    SellerID INT NOT NULL,
    ContractDate DATE NOT NULL,
    SalePrice MONEY NOT NULL,
    EvidenceID INT NOT NULL,

    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (BuyerID) REFERENCES users(UserID),
    FOREIGN KEY (SellerID) REFERENCES users(UserID),
    FOREIGN KEY (EvidenceID) REFERENCES evidence(EvidenceID)
);

CREATE TABLE Rent ( -- This table stores information about property rentals, including the property ID, landlord ID, tenant ID, guarantor ID, rental period, guarantee amount, monthly rent, and associated evidence. Each record has a unique identifier and is associated with a specific property, landlord, tenant, guarantor, and evidence.
    RentID INT IDENTITY(1,1) PRIMARY KEY,
    propertyID INT NOT NULL,
    Lordland INT NOT NULL,
    TenantID INT NOT NULL,
    GuarantorID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    GuaranteeAmount MONEY NOT NULL,
    MonthlyRent MONEY NOT NULL,
    EvidenceID INT NOT NULL,

    FOREIGN KEY (propertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (Lordland) REFERENCES users(UserID),
    FOREIGN KEY (TenantID) REFERENCES users(UserID),
    FOREIGN KEY (guarantorID) REFERENCES users(UserID),
    FOREIGN KEY (EvidenceID) REFERENCES evidence(EvidenceID)
);

CREATE TABLE Ownersaproval ( -- This table is used to track the approval status of property owners for sales and rentals
    ApprovalID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT NOT NULL,
    RentID INT NOT NULL,
    OwnershipID INT NOT NULL,
    ApprovalDate DATE NOT NULL,
    IsApproved BIT DEFAULT 0,
    FOREIGN KEY (OwnershipID) REFERENCES PropertyOwners(OwnershipID),
    FOREIGN KEY (SaleID) REFERENCES Sale(SaleID),
    FOREIGN KEY (RentID) REFERENCES Rent(RentID)
);

CREATE TABLE RentPayments ( -- This table stores information about payments made for property rentals, including the rent ID, payment date, payment status, amount, a link to a scanned payment receipt, and associated evidence. Each record has a unique identifier and is associated with a specific rental and evidence.
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    RentID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Ispaid BIT DEFAULT 0,
    Amount MONEY NOT NULL,
    EvidenceID INT NOT NULL,

    FOREIGN KEY (RentID) REFERENCES Rent(RentID),
    FOREIGN KEY (EvidenceID) REFERENCES evidence(EvidenceID)
);

CREATE TABLE SALEPAYMENTS ( -- This table stores information about payments made for property sales, including the sale ID, payment date, payment status, amount, a link to a scanned payment receipt, and associated evidence. Each record has a unique identifier and is associated with a specific sale and evidence.
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    SaletID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Ispaid BIT DEFAULT 0,
    Amount MONEY NOT NULL,
    EvidenceID INT NOT NULL,

    FOREIGN KEY (SaletID) REFERENCES Sale(SaleID),
    FOREIGN KEY (EvidenceID) REFERENCES evidence(EvidenceID)
);