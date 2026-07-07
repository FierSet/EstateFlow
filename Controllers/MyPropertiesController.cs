using Microsoft.AspNetCore.Mvc;
using RealStateManagementWebapp.Models;
using System.Text.Json.Nodes;
using System.Text.Json;

namespace RealStateManagementWebapp.Controllers;

public class MyPropertiesController : Controller
{
    public IActionResult MyProperties()
    {
        return View();
    }
    [HttpPost]
    public async Task<IActionResult> Updateproperties([FromBody] Propertys Propertys)
    {
        var routeValues = new RouteValueDictionary
        {
            ["partialName"] = "My-Propertie",
            ["messagecode.Code"] = 0,
            ["messagecode.Message"] = ""
        };

        try
        {
            var client = new HttpClient();

            string baseUrl = $"{Request.Scheme}://{Request.Host}";
            var response = await client.PostAsJsonAsync(
                $"{baseUrl}/api/Database/Create_alter_property",
                Propertys
            );

            string result = await response.Content.ReadAsStringAsync();
        
            var json = JsonNode.Parse(result);

            var jsoncode = JsonNode.Parse(json?["jsonresponse"]?.ToString() ?? "{}");

            routeValues["messagecode.Code"] = jsoncode?["code"];
            routeValues["messagecode.Message"] = jsoncode?["message"];

            return Content(JsonSerializer.Serialize(routeValues));//, routeValues);
        }catch(Exception er)
        {

            routeValues["messagecode.Code"] = 97;
            routeValues["messagecode.Message"] = "An error occurred while updating the property: " + er.Message;
            return Content(JsonSerializer.Serialize(routeValues));//, routeValues);
        }
    }

     [HttpPost]
    public async Task<IActionResult> Loadproperties([FromBody] GetPropertieslist GetPropertieslist)
    {

         try
        {

            var client = new HttpClient();

            string baseUrl = $"{Request.Scheme}://{Request.Host}";
            var response = await client.PostAsJsonAsync(
                $"{baseUrl}/api/Database/Load_properties",
                GetPropertieslist
            );

            string result = await response.Content.ReadAsStringAsync();
        
            var json = JsonNode.Parse(result);
            
            var jsoncode = json?["jsonresponse"]?.ToString() ?? "{}";
            return Content(JsonSerializer.Serialize(jsoncode));//, routeValues);
        }catch(Exception er)
        {

            return Content(JsonSerializer.Serialize(er));//, routeValues);
        }
    }
}
