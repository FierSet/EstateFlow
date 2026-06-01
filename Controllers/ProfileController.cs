using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using RealStateManagementWebapp.Models;

namespace RealStateManagementWebapp.Controllers;

public class ProfileController : Controller
{
    public IActionResult Profile()
    {
        return View();
    }

}
