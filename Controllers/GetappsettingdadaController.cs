using Microsoft.AspNetCore.Mvc;

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
