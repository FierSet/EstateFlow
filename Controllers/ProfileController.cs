using Microsoft.AspNetCore.Mvc;
using RealStateManagementWebapp.Models;
using System.Text.Json.Nodes;
using System.Text.Json;

namespace RealStateManagementWebapp.Controllers;

public class ProfileController : Controller
{
    public IActionResult Profile()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> UpdateUserData(Dataupdated dataupdated)
    {
        var routeValues = new RouteValueDictionary
        {
            ["partialName"] = "Profile",
            ["messagecode.Code"] = "",
            ["messagecode.Message"] = ""
        };

        if (!ModelState.IsValid)
        {
            routeValues["Messagecode.Code"] = 55;
            routeValues["Messagecode.Message"] = "Data not updated";

            return RedirectToAction("Index", "Customer", routeValues);
        }
        
        var client = new HttpClient();

        string baseUrl = $"{Request.Scheme}://{Request.Host}";
        var response = await client.PostAsJsonAsync(
            $"{baseUrl}/api/Database/Updatedatauser",
            new { Usercreids = dataupdated.Usercreids, Userdata = dataupdated.Userdata }
        );

        string result = await response.Content.ReadAsStringAsync();
        
        var json = JsonNode.Parse(result);
        var jsoncode = JsonNode.Parse(json?["jsonresponse"]?.ToString() ?? "{}");
        
        // Pass nested properties as route values so model binding can populate the Messagecode parameter
        //routeValues["partialName"] = "Profile";
        routeValues["Messagecode.Code"] = int.Parse(jsoncode?["code"]?.ToString() ?? "0");
        routeValues["Messagecode.Message"] = jsoncode?["message"]?.ToString();

        return RedirectToAction("Index", "Customer", routeValues);
    }

    public async Task<IActionResult> UpdatePassword(Dataupdated dataupdated)
    {

        var routeValues = new RouteValueDictionary
        {
            ["partialName"] = "Profile",
            ["messagecode.Code"] = 0,
            ["messagecode.Message"] = ""
        };

        if (!ModelState.IsValid)
        {
            routeValues["Messagecode.Code"] = 55;
            routeValues["Messagecode.Message"] = "Data not updated";

            return RedirectToAction("Index", "Customer", routeValues);
        }
        
        var client = new HttpClient();

        string baseUrl = $"{Request.Scheme}://{Request.Host}";

        
        var response = await client.PostAsJsonAsync(
            $"{baseUrl}/api/Database/Updatepassword",
            dataupdated
        );

        string result = await response.Content.ReadAsStringAsync();

        var json = JsonNode.Parse(result);
        var jsoncode = JsonNode.Parse(json?["jsonresponse"]?.ToString() ?? "{}");


        routeValues["messagecode.Code"] = jsoncode?["code"];
        routeValues["messagecode.Message"] = jsoncode?["message"];

        //var json = JsonNode.Parse(result);

        return RedirectToAction("Index", "Customer", routeValues);
    }
    
}