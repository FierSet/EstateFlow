# EstateFlow - Real Estate Management Web Application

A comprehensive web application for managing real estate properties, built with ASP.NET Core.

## Overview

EstateFlow is a real estate management system that allows users to manage their properties, view listings, and handle user profiles. The application provides a user-friendly interface for property management operations including listing properties, updating property details, and managing user accounts.

## Features

- **User Authentication**: Sign up and sign in functionality
- **Property Management**: Create, view, and manage property listings
- **User Profile**: Manage user information and account settings
- **Property Dashboard**: View all properties in an organized dashboard
- **Responsive Design**: Mobile-friendly user interface
- **Multi-language Support**: Support for multiple languages (English, Spanish, German, French, Italian, Japanese, Korean, Polish, Portuguese, Russian, Turkish, Chinese)

## Technology Stack

- **Framework**: ASP.NET Core (NET 10.0)
- **Language**: C#
- **Frontend**: HTML, CSS, JavaScript
- **UI Framework**: Bootstrap
- **Database**: SQL Server
- **Client-side Libraries**: jQuery, jQuery Validation

## Prerequisites

- .NET 10.0 SDK or later
- SQL Server (or compatible database)
- Visual Studio 2022 or VS Code with C# extension
- Node.js (optional, for frontend tooling)

## Project Structure

```
EstateFlow/
├── Controllers/              # MVC Controllers
│   ├── HomeController.cs     # Home and authentication
│   ├── CustomerController.cs # Customer operations
│   ├── MyPropertiesController.cs # Property management
│   ├── ProfileController.cs  # User profile
│   └── ...
├── Models/                   # Data models and DbContext
│   ├── RealStateDbContext.cs # Entity Framework context
│   ├── PropertysModel.cs     # Property model
│   ├── UserdataModel.cs      # User data model
│   └── ...
├── Views/                    # Razor views
│   ├── Home/                 # Home and login/signup views
│   ├── Customer/             # Customer views
│   └── Shared/               # Shared layouts
├── wwwroot/                  # Static files
│   ├── css/                  # Stylesheets
│   ├── js/                   # JavaScript files
│   ├── IMG/                  # Images and assets
│   └── lib/                  # Third-party libraries
├── database/                 # SQL scripts
│   ├── createtable.sql       # Database schema
│   ├── signup.sql            # User registration
│   ├── signin.sql            # User authentication
│   └── ...
└── Program.cs               # Application entry point
```

## Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd EstateFlow
```

### 2. Configure Database Connection
- Update `appsettings.json` with your database connection string
- Connection string format:
  ```json
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER;Database=RealStateDb;User Id=YOUR_USER;Password=YOUR_PASSWORD;"
  }
  ```

### 3. Create the Database
- Execute SQL scripts from the `database/` folder in the following order:
  1. `createtable.sql` - Creates the database schema
  2. `Load_propertes.sql` - Loads initial property data
  3. `loaduserbasic_data.sql` - Loads initial user data

### 4. Restore Dependencies
```bash
dotnet restore
```

### 5. Run the Application
```bash
dotnet run
```

The application will start at `https://localhost:5001` (or the port specified in `launchSettings.json`).

## Configuration

### App Settings
Configure the application through `appsettings.json`:
- Database connection strings
- Logging levels
- Application-specific settings

### Environment-Specific Settings
- `appsettings.Development.json` - Development environment configuration
- `appsettings.json` - Default/production configuration

## Usage

### User Registration
1. Navigate to the Sign Up page
2. Enter your credentials (email, password, personal information)
3. Submit the form

### User Login
1. Navigate to the Sign In page
2. Enter your email and password
3. Click Sign In

### Managing Properties
1. After login, navigate to "My Properties"
2. View all your properties in the dashboard
3. Add new properties with property details
4. Edit or delete existing properties

### Profile Management
1. Go to your Profile page
2. Update your personal information
3. Change your password if needed

## API Endpoints

### Customer Controller
- `GET /Customer/` - List customers
- `GET /Customer/Details/{id}` - Customer details

### Properties Controller
- `GET /MyProperties/` - List user properties
- `POST /MyProperties/Create` - Add new property
- `POST /MyProperties/Update` - Update property
- `POST /MyProperties/Delete/{id}` - Delete property

### Profile Controller
- `GET /Profile/` - View profile
- `POST /Profile/Update` - Update profile

## Database Schema

### Users Table
- User ID, Email, Password, Full Name, Phone, Address, etc.

### Properties Table
- Property ID, Address, Description, Price, Type, Owner ID, Status, etc.

### Additional Tables
- Refer to `database/createtable.sql` for complete schema

## SQL Stored Procedures & Queries

The application uses SQL Server stored procedures with JSON parameters for data operations. All procedures accept JSON input and return JSON output for seamless web-to-database communication.

### Authentication Procedures

#### `Signin` Procedure
- **Purpose**: User login verification
- **Input**: JSON with Email and Password
- **Output**: JSON response with user details or error code
- **Example Call**:
  ```sql
  EXEC Signin '{
    "Email": "user@example.com",
    "Password": "password123"
  }'
  ```
- **Response Codes**:
  - `16` - Email or Password Empty
  - `20` - User doesn't exist
  - `21` - Banned user
  - `22` - User found (success)

#### `Signup` Procedure
- **Purpose**: User registration
- **Input**: JSON with Email and Password
- **Output**: JSON response with status or error
- **Response Codes**:
  - `16` - Email or Password Empty
  - `17` - User Already exists
  - `18` - User not created
  - `19` - User created (success)

### Property Management Procedures

#### `Load_properties` Procedure
- **Purpose**: Retrieve paginated property list for a user
- **Input**: JSON with UserID and Page number
- **Output**: JSON with properties, rooms, and pagination info
- **Example Call**:
  ```sql
  EXEC Load_properties '{
    "Usercreids": {
      "ID": "1"
    },
    "Page": 1
  }'
  ```
- **Returns**: Property list with nested room information and pagination details

#### `Property_list_Parameters` Procedure
- **Purpose**: Get dropdown/filter parameters for property creation
- **Output**: JSON containing:
  - Property Verification Types
  - Room Types
  - Property Types
  - Status options

### SQL Queries Directory

- **createtable.sql** - Database schema creation (users, properties, rooms, types, status tables)
- **signup.sql** - User registration stored procedure
- **signin.sql** - User login verification stored procedure
- **Load_propertes.sql** - Property loading with pagination and JSON nesting
- **Create_alter_property.sql** - Property CRUD operations
- **Update_password.sql** - Password update procedure
- **Update_userdata.sql** - User profile update procedure
- **loaduserbasic_data.sql** - Initial user data seed
- **Property_list_Parameters.sql** - Dropdown parameters for UI

## JSON Data Flow: Web to Database and Back

The application uses a complete JSON-based communication pattern between the frontend, C# controllers, and SQL Server database.

### Architecture Pattern

```
Web Client (JSON)
    ↓ (POST with JSON)
C# Controller
    ↓ (JsonSerializer.Serialize)
Stored Procedure with JSON Parameter
    ↓ (JSON_VALUE, OPENJSON)
SQL Server Processing
    ↓ (FOR JSON PATH)
JSON Response
    ↓ (Read as string)
C# Controller (JsonNode.Parse)
    ↓ (Content/ViewResult)
Web Client (Response)
```

### JSON Processing in SQL

**Parsing JSON Input:**
```sql
DECLARE @Email NVARCHAR(255) = JSON_VALUE(@json, '$.Email');
DECLARE @Password NVARCHAR(255) = JSON_VALUE(@json, '$.Password');
```

**Parsing Complex JSON Objects:**
```sql
SELECT * FROM OPENJSON(@json)
WITH (
    code INT,
    message NVARCHAR(255)
)
```

**Returning Data as JSON:**
```sql
SELECT * FROM Properties
FOR JSON PATH  -- Returns array of objects

-- Without array wrapper:
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  -- Returns single object
```

**Nested JSON Responses:**
```sql
SELECT
  (SELECT * FROM Users FOR JSON PATH) AS Users,
  (SELECT * FROM Properties FOR JSON PATH) AS Properties
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
```

### JSON Processing in C#

**Serializing C# objects to JSON:**
```csharp
string tojson = JsonSerializer.Serialize(userInstance);
var response = await client.PostAsJsonAsync(url, user);
```

**Parsing JSON responses:**
```csharp
string result = await response.Content.ReadAsStringAsync();
var json = JsonNode.Parse(result);
var code = json?["jsonresponse"]?["code"]?.ToString();
```

**Extracting nested JSON values:**
```csharp
var userjson = JsonNode.Parse(json?["jsonresponse"]?.ToString() ?? "{}");
string userID = userjson?["UserID"]?.ToString() ?? "";
```

### Complete Data Flow Example: User Login

1. **Frontend sends JSON:**
   ```json
   {
     "Email": "user@example.com",
     "Password": "password123"
   }
   ```

2. **C# Controller receives and serializes:**
   ```csharp
   string tojson = JsonSerializer.Serialize(userInstance);
   ```

3. **SQL Procedure processes:**
   ```sql
   DECLARE @Email = JSON_VALUE(@json, '$.Email')
   DECLARE @Password = JSON_VALUE(@json, '$.Password')
   -- Verify credentials
   ```

4. **SQL returns JSON response:**
   ```json
   {
     "code": 22,
     "message": "user found",
     "UserID": "1",
     "Email": "user@example.com",
     "FirstName": "John"
   }
   ```

5. **C# Controller parses and stores:**
   ```csharp
   var userjson = JsonNode.Parse(result);
   HttpContext.Session.SetString("ID", userjson?["UserID"]?.ToString());
   ```

### Benefits of JSON Pattern

- **Single Serialization Format**: Consistent data format across all layers
- **Type Safe**: C# models serialize/deserialize safely
- **Database Native**: SQL Server has native JSON support
- **Flexible**: Easy to add fields without changing stored procedures
- **Scalable**: Clean API contracts between frontend and backend

## Development Notes

- The application uses Entity Framework Core for database operations
- Views use Razor templating engine
- Client-side validation via jQuery Validation
- Custom CSS styling for property listings and user interface

## Troubleshooting

### Database Connection Issues
- Verify SQL Server is running
- Check connection string in `appsettings.json`
- Ensure database user has appropriate permissions

### Port Already in Use
- Change the port in `Properties/launchSettings.json`
- Or run: `dotnet run --urls "https://localhost:5002"`

## Future Enhancements

- Advanced property filtering and search
- Property image gallery
- Property reviews and ratings
- Messaging between users
- Payment integration
- Admin dashboard
- API documentation (Swagger/OpenAPI)

## License

[Add your license information here]

## Contact & Support

[Add contact information here]
