using System.Diagnostics;
using System.IO;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.Extensions.Configuration;
using RealStateManagementWebapp.Models;

namespace RealStateManagementWebapp.Controllers;

public class GetappsettingdadaController : Controller
{
    public IActionResult GetPathComents()
    {
        var builder = new ConfigurationBuilder().SetBasePath(Directory.GetCurrentDirectory()).AddJsonFile("appsettings.json").Build();
        var path = builder.GetSection("CSVLabels:Path").Value ?? "";
        
        return Json(new { path = path });
    }
}
