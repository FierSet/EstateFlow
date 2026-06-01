using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using RealStateManagementWebapp.Models;

namespace RealStateManagementWebapp.Controllers;

public class CustomerController : Controller
{
    public IActionResult Customer()
    {
        return View();
    }

    public IActionResult ChangePartial(string partialName)
    {

        Userdata userdata = new();
        Console.WriteLine("custommer controller");

        var GetModel = new Dictionary<string, object> 
        { 
            { "Profile", "1234" },
            { "Dashboard", "1234" },
            { "My-Properties", "1234" },
            { "Payments", "1234" },
            { "Maintenance", "1234" },
            { "Settings", "1234" } 
        };

        return PartialView(partialName);
    }

    public Userdata Getuserdata()
    {
        string? ID = HttpContext.Session.GetString("ID");
        string? Email = HttpContext.Session.GetString("Email");
        string? IsActive = HttpContext.Session.GetString("IsActive");
        string? Role = HttpContext.Session.GetString("Role");
        


        return null;
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}