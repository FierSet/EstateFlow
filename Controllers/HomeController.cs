using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using RealStateManagementWebapp.Models;

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

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
