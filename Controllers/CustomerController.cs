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
        return PartialView(partialName);
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}