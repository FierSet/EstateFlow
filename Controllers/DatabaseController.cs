using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using RealStateManagementWebapp.Models;
using System.Text.Json;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Text.Json.Nodes;


namespace RealStateManagementWebapp.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DatabaseController : ControllerBase
{
    private readonly RealStateDbContext _context;

    public DatabaseController(RealStateDbContext context)
    {
        _context = context;
    }
    

    [HttpGet("test-connection")]
    public async Task<IActionResult> TestConnection()
    {
        try
        {

            // Try to open the connection
            await _context.Database.OpenConnectionAsync();
            await _context.Database.CloseConnectionAsync();
            return Ok(new {Status = 200, message = "Database connection successful" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Database connection failed", error = ex.Message });
        }
    }
    
    [HttpPost("Signin")]
    public async Task<IActionResult> Signin([FromBody] Usersingin user)
    {
        try
        {
            var passwordHasher = new PasswordHasher<IdentityUser>();
            string haspassword = 
                passwordHasher.HashPassword(
                    new IdentityUser(), 
                    user.Password ?? string.Empty
                );

            Usersingin userInstance = new Usersingin
            {
                Email = user.Email,
                Password = haspassword
            };
            string tojson = JsonSerializer.Serialize(userInstance);

            var storeprocedure = "Singin";
            var connection = _context.Database.GetDbConnection();
            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();
            
            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@json", tojson));

            var response = await command.ExecuteScalarAsync();
            await connection.CloseAsync();
            
            string? result = response != DBNull.Value ? response?.ToString() : "{}";
            
            if (result != null && result.StartsWith('['))
            {
                var jsonarr = JsonNode.Parse(result)?.AsArray();

                var jsonarray = jsonarr?.FirstOrDefault();
                var matchpassword = passwordHasher.VerifyHashedPassword(
                        new IdentityUser(),
                        jsonarray?["PasswordHash"]?.ToString() ?? "",
                        user.Password ?? string.Empty
                );

                if(matchpassword == PasswordVerificationResult.Success)
                {
                    var results = new
                    {
                        code = 22,
                        message = "Login success",
                        UserID = jsonarray?["UserID"],
                        FirstName = jsonarray?["FirstName"],
                        FathersName = jsonarray?["FathersName"],
                        AvatarImage = jsonarray?["AvatarImage"],
                        Email = jsonarray?["Email"],
                        IsActive = jsonarray?["IsActive"],
                        Role = jsonarray?["Role"]
                    };
                    string resultjson = JsonSerializer.Serialize(results);
                    result = resultjson.ToString();
                }
                else
                    result = "{\"code\":23,\"message\":\"User or Password is incorrect\"}";
            }   
            
            return Ok(new {Status = 200, jsonresponse = result }); //result });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code\":17,\"message\":\"Error to connect\"}", exeption = ex });
        }

    }

    [HttpPost("Signup")]
    public async Task<IActionResult> Signup([FromBody] Usersingin user)
    {
        try
        {
            var passwordHasher = new PasswordHasher<IdentityUser>();
            string haspassword = 
                passwordHasher.HashPassword(
                    new IdentityUser(), 
                    user.Password ?? string.Empty
                );

            Usersingin userInstance = new Usersingin
            {
                Email = user.Email,
                Password = haspassword
            };
            string tojson = JsonSerializer.Serialize(userInstance);

            var storeprocedure = "Singup";
            var connection = _context.Database.GetDbConnection();

            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();
            
            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@json", tojson));

            var response = await command.ExecuteScalarAsync();
            string? result = response != DBNull.Value ? response?.ToString() : "{}";
            
            return Ok(new {Status = 200, jsonresponse = result });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code':17,\"message\":\"Error in peocess\"}", exeption = ex });
        }
    }

    [HttpPost("Loaddatauser")]
    public async Task<IActionResult> Loaddatauser([FromBody] Usercreids user)
    {
        try
        {
            string tojson = JsonSerializer.Serialize(user);

            var storeprocedure = "Loadbasicdata";
            var connection = _context.Database.GetDbConnection();

            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();
            
            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@json", tojson));

            var response = await command.ExecuteScalarAsync();
            string? result = response != DBNull.Value ? response?.ToString() : "{}";
            
            return Ok(new {Status = 200, jsonresponse = result });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code':17,\"message\":\"Error in peocess\"}", exeption = ex });
        }
    }

    [HttpPost("Updatedatauser")]
    public async Task<IActionResult> Updatedatauser([FromBody] Dataupdated dataupdated)
    {
        try
        {
            string tojson = JsonSerializer.Serialize(dataupdated);
            
            var storeprocedure = "update_userdata";
            var connection = _context.Database.GetDbConnection();

            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();
            
            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@json", tojson));

            var response = await command.ExecuteScalarAsync();
            string? result = response != DBNull.Value ? response?.ToString() : "{}";
            
            return Ok(new {Status = 200, jsonresponse = result });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code':17,\"message\":\"Error in peocess\"}", exeption = ex });
        }
    }

    [HttpPost("Updatepassword")]
    public async Task<IActionResult> Updatepassword([FromBody] Dataupdated dataupdated)
    {
        try
        {
            var client = new HttpClient();

            string tojson = JsonSerializer.Serialize(dataupdated);

            string baseUrl = $"{Request.Scheme}://{Request.Host}";

            Usersingin user = new Usersingin {
                Email = dataupdated?.Usercreids?.Email,
                Password =  dataupdated?.ChangePassword?.OldPassword
            };

            var response = await client.PostAsJsonAsync(
                $"{baseUrl}/api/Database/Signin",
                user
            );

            string result = await response.Content.ReadAsStringAsync();

             var json = JsonNode.Parse(result);
            var jsoncode = JsonNode.Parse(json?["jsonresponse"]?.ToString() ?? "{}");

            if(jsoncode?["code"]?.ToString() != "22")
            {
                return Ok(new {Status = 200, jsonresponse = jsoncode });
            }
            var storeprocedure = "Update_password";

            var passwordHasher = new PasswordHasher<IdentityUser>();
            string haspassword = 
                passwordHasher.HashPassword(
                    new IdentityUser(), 
                    dataupdated?.ChangePassword?.Password2 ?? string.Empty
                );
            
            user.Password = haspassword;

            string Passwordjson = JsonSerializer.Serialize(user);
            var connection = _context.Database.GetDbConnection();
            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();
            
            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@json", Passwordjson));

            var responsepasw = await command.ExecuteScalarAsync();
            //string? resultpassword = jsonpassword != DBNull.Value ? jsonpassword?.ToString() : "{}";

            return Ok(new {Status = 200, jsonresponse = responsepasw });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code':17,\"message\":\"Error in peocess\"}", exeption = ex });
        }
    }

    [HttpGet("Property_list_Parameters")]
    public async Task<IActionResult> Property_list_Parameters()
    {
        try
        {
            var storeprocedure = "Property_list_Parameters";
            var connection = _context.Database.GetDbConnection();
            
            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();

            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;

            var Listoflists = await command.ExecuteScalarAsync();

            return Ok(new {Status = 200, jsonresponse = Listoflists });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code':17,\"message\":\"Error in peocess\"}", exeption = ex });
        }
    }

    [HttpPost("Create_alter_property")]
    public async Task<IActionResult> Create_property([FromBody] Propertys Propertys)
    {
        try
        {
            string tojson = JsonSerializer.Serialize(Propertys);
            
            var storeprocedure = "Create_alter_property";
            var connection = _context.Database.GetDbConnection();
            
            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();

            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@json", tojson));

            var response = await command.ExecuteScalarAsync();

            return Ok(new {Status = 200, jsonresponse = response });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code':17,\"message\":\"Error in peocess\"}", exeption = ex });
        }
    }

    [HttpPost("Load_properties")]
    public async Task<IActionResult> Load_properties([FromBody] GetPropertieslist GetPropertieslist)
    {

        try
        {
            string tojson = JsonSerializer.Serialize(GetPropertieslist);
            
            var storeprocedure = "Load_properties";
            var connection = _context.Database.GetDbConnection();
            
            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();

            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@json", tojson));

            var response = await command.ExecuteScalarAsync();

            return Ok(new {Status = 200, jsonresponse = response });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code':17,\"message\":\"Error in peocess\"}", exeption = ex });
        }

    }

}