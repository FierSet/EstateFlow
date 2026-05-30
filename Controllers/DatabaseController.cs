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

#pragma warning disable CS8602 // Dereference of a possibly null reference.
            if (!result.StartsWith('['))
                throw new Exception("json incorrect");
            
                var jsonarray = JsonNode.Parse(result)?.AsArray();
                var matchpassword = passwordHasher.VerifyHashedPassword(
                        new IdentityUser(),
                        jsonarray[0]["PasswordHash"].ToString(),
                        user.Password ?? string.Empty
                );

                if(matchpassword == PasswordVerificationResult.Success)
                {
                    HttpContext.Session.SetString(
                        "UserEmail",
                        user.Email!
                    );
                    HttpContext.Session.SetString(
                        "UserID",
                        jsonarray[0]["UserID"].ToString()
                    );

                    /* read session
                        string? Email =
                        HttpContext.Session.GetString(
                            "UserEmail"
                        );
                    */
                    result = "{\"code\":22,\"message\":\"Loggin success\"}";
                }
                else
                    result = "{\"code\":23,\"message\":\"User or Password is incorrect\"}";
                    
            
#pragma warning restore CS8602 // Dereference of a possibly null reference.
            
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
            //var passwordHasher = new PasswordHasher<IdentityUser>();

            var storeprocedure = "Singup";
            var connection = _context.Database.GetDbConnection();

            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync();
            
            var command = connection.CreateCommand();
            command.CommandText = storeprocedure;
            command.CommandType = CommandType.StoredProcedure;
            //command.Parameters.Add(new SqlParameter("@json", tojson));

            var response = await command.ExecuteScalarAsync();
            string? result = response != DBNull.Value ? response?.ToString() : "{}";
            
            return Ok(new {Status = 200, jsonresponse = result });
        }
        catch (Exception ex)
        {
            return Ok(new {Status = 500, jsonresponse = "{\"code':17,\"message\":\"Error in peocess\"}", exeption = ex });
        }
    }

    [HttpPost("Getdatauser")]
    public async Task<IActionResult> Getdatauser([FromBody] Usersingin user)
    {
        try
        {
            //var passwordHasher = new PasswordHasher<IdentityUser>();

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
}