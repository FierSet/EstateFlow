using Microsoft.AspNetCore.Mvc;
using RealStateManagementWebapp.Models;
using System.Text.Json.Nodes;

namespace RealStateManagementWebapp.Controllers;

public class HomeController : Controller
{
    public IActionResult Index()
    {
        return View();
    }

    public IActionResult ChangePartial(string partialName)
    {
        return PartialView(partialName);
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Loggin([FromBody] Usersingin user)
    {
        var client = new HttpClient();
        string baseUrl = $"{Request.Scheme}://{Request.Host}";

        var response = await client.PostAsJsonAsync(
            $"{baseUrl}/api/Database/Signin",
            user
        );
        string result = await response.Content.ReadAsStringAsync();

        var json = JsonNode.Parse(result);
       
        var userjson = JsonNode.Parse(json?["jsonresponse"]?.ToString() ?? "{}");

        if (userjson?["code"]?.ToString() == "22")
            if (userjson?["UserID"] != null)
            {
                HttpContext.Session.SetString("ID", userjson?["UserID"]?.ToString() ?? "");
                HttpContext.Session.SetString("Email", userjson?["Email"]?.ToString() ?? "");
                HttpContext.Session.SetString("IsActive", userjson?["IsActive"]?.ToString() ?? "0");
                HttpContext.Session.SetString("Role", userjson?["Role"]?.ToString() ?? "1");
                HttpContext.Session.SetString("FirstName", userjson?["FirstName"]?.ToString() ?? "Leon");
                HttpContext.Session.SetString("FathersName", userjson?["FathersName"]?.ToString() ?? "Scot");
                HttpContext.Session.SetString("AvatarImage", userjson?["AvatarImage"]?.ToString() ?? "https://i.pravatar.cc/120");
            }
        return Content(json!.ToString());
    }

   [HttpPost]
    public async Task<IActionResult> Signup([FromBody] Usersingin user)
    {
        var client = new HttpClient();
        string baseUrl = $"{Request.Scheme}://{Request.Host}";

        var response = await client.PostAsJsonAsync(
            $"{baseUrl}/api/Database/Signup",
            user
        );

        string result = await response.Content.ReadAsStringAsync();

        var json = JsonNode.Parse(result);


        return Content(json!.ToString());
    }

}
