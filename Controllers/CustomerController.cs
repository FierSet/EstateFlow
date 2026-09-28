using Microsoft.AspNetCore.Mvc;
using RealStateManagementWebapp.Models;
using System.Text.Json.Nodes;
using System.Text.Json;

namespace RealStateManagementWebapp.Controllers;

public class CustomerController : Controller
{
    private Parameters? _Parameter = new()
    {
        Partialselect = new PartialSelected { PartialName = "Dashboard"},
    };

    private string Database_endpoind()
    {
        return $"{Request.Scheme}://{Request.Host}";
    }

    private Usercreids Usercreids()
    {
        
        return new Usercreids()
        {
            ID = int.Parse(HttpContext.Session.GetString("ID") ?? "0"),
            Email = HttpContext.Session.GetString("Email") ?? "",
            Tocken = HttpContext.Session.GetString("Tocken") ?? "",
            IsActive = bool.Parse(HttpContext.Session.GetString("IsActive") ?? "false")
        };
        
    }

    public IActionResult Index(Messagecode Messagecode, string partialName = "Lease")
    {   
        _Parameter?.Partialselect?.PartialName = partialName;
        _Parameter?.Messagecode?.Code = Messagecode.Code;
        _Parameter?.Messagecode?.Message = Messagecode.Message;

        if (string.IsNullOrEmpty(HttpContext.Session.GetString("ID"))) 
            return RedirectToAction("Index", "Home");

        if(_Parameter?.Messagecode?.Code == 105)
        {
            return RedirectToAction(
                "Index",
                "Home",
                new { alertMessage = "Your session has expired. Please log in again." });
        }
        if(!bool.Parse(HttpContext.Session.GetString("IsActive") ?? "false"))
            _Parameter?.Partialselect?.PartialName = "Profile";
        
        return View(_Parameter);
    }

    public async Task<IActionResult> ChangePartial(string partialName)
    {

        var  GetModel = new Dictionary<string, Func<Task<object?>>> 
        { 
            { "Profile", async () => await Getuserdata() },
            { "Dashboard", async () => await getdashboard() },
            { "My-Properties", async () => await Getpropertys() },
            {"Lease", async () => await GetdaLease() },
            { "Payments", async () => "1234" },
            { "Maintenance", async () => "1234" },
            { "Settings", async () => "1234" } 
        };

        var Model = await GetModel[partialName]();

        if (Model == null)
        {
            return Json(new
            {
                redirect = Url.Action(
                    "Index",
                    "Home",
                new { alertMessage = "Your session has expired. Please log in again." })
            });
        }
        //Console.WriteLine("Model: " + JsonSerializer.Serialize(Model).ToString());
        return PartialView("./partial/" + partialName, Model);
    }

    public async Task<Lease> GetdaLease()
    {
        //var client = new HttpClient();

        Lease lease = new Lease();

        lease.Usercreids = Usercreids();

        return lease ?? new Lease();
    }

    public async Task<Dashboard> getdashboard()
    {

        var client = new HttpClient();

        var response = await client.PostAsJsonAsync(
            $"{Database_endpoind()}/api/Database/Load_dashboard",
            Usercreids()
        );

        string result = await response.Content.ReadAsStringAsync();
        var jsonresult = JsonNode.Parse(result);

        var json = JsonNode.Parse(jsonresult?["jsonresponse"]?.ToString() ?? "{}");

        Dashboard dashboard = new();

        
        foreach(var prop in json?["Propertycount"]?.AsArray() ?? [])
        {
            dashboard?.Propertiescount?.Add( new Propertycount
            {
                PropertyTypeID = int.Parse(prop?["PropertyType"]?.ToString() ?? "0"),
                TOTAL = int.Parse(prop?["TOTAL"]?.ToString() ?? "0")
            });
        }

        return dashboard ?? new Dashboard();//propertys ?? new Propertys();
    }

    public async Task<Propertys?> Getpropertys()
    {
        var client = new HttpClient();
        
        var response = await client.GetAsync(
            $"{Database_endpoind()}/api/Database/Property_list_Parameters"
        );

        string result = await response.Content.ReadAsStringAsync();
        var jsonresult = JsonNode.Parse(result);

        var json = JsonNode.Parse(jsonresult?["jsonresponse"]?.ToString() ?? "{}");

        var PropertyType = JsonNode.Parse(json?["PropertyType"]?.ToJsonString() ?? "[]");
        var status = JsonNode.Parse(json?["STATUS"]?.ToJsonString() ?? "{}");
        var roomType = JsonNode.Parse(json?["RoomType"]?.ToJsonString() ?? "{}");
        var Propertyverificationtype = JsonNode.Parse(json?["Propertyverificationtype"]?.ToJsonString() ?? "{}");

        Propertys propertys = new ();

        propertys.Usercreids = Usercreids();

        foreach(var prop in PropertyType?.AsArray() ?? [])
        {
            propertys?.Dropdown?.PropertyType?.Add( new PropertyType
            {
                PropertyTypeID = prop?["PropertyTypeID"]?.ToString() ?? "0",
                TypeName = prop?["TypeName"]?.ToString()
            });
        }

        foreach(var stat in status?.AsArray() ?? [])
        {
            propertys?.Dropdown?.STATUS?.Add( new STATUS
            {
                StatusID = stat?["StatusID"]?.ToString() ?? "0",
                StatusName = stat?["StatusName"]?.ToString()
            });
        }

        foreach(var room in roomType?.AsArray() ?? [])
        {
            propertys?.Dropdown?.RoomType?.Add( new RoomType
            {
                RoomTypeID = room?["RoomTypeID"]?.ToString() ?? "0",
                RoomTypeName = room?["RoomTypeName"]?.ToString()
            });
        }

        foreach(var propv in Propertyverificationtype?.AsArray() ?? [])
        {
            propertys?.Dropdown?.Propertyverificationtype?.Add( new Propertyverificationtype
            {
                PropertyverificationtypeID = propv?["propertyverificationtypeID"]?.ToString() ?? "0",
                TypeName = propv?["TypeName"]?.ToString()
            });
        }

        //Console.WriteLine(JsonSerializer.Serialize(propertys).ToString());

        return propertys ?? new Propertys();
    }

    public async Task<Dataupdated?> Getuserdata()
    {
        var client = new HttpClient();

        var response = await client.PostAsJsonAsync(
            $"{Database_endpoind()}/api/Database/Loaddatauser",
            Usercreids()
        );

        string result = await response.Content.ReadAsStringAsync();
        var json = JsonNode.Parse(result);

        var userjson = JsonNode.Parse(json?["jsonresponse"]?.ToString() ?? "{}");

        if (userjson?["code"]?.ToString() == "105")
        {
            HttpContext.Session.Clear();
            return null;
        }

        var users = JsonNode.Parse(userjson?["Users"]?.ToString() ?? "{}");

        Dataupdated dataupdated = new()
        {
            Usercreids = Usercreids(),
            Userdata = new Userdata
            {
                FirstName = users?["FirstName"]?.ToString() ?? "",
                SecondName = users?["SecondName"]?.ToString() ?? "",
                FathersName = users?["FathersName"]?.ToString() ?? "",
                MothersName = users?["MothersName"]?.ToString() ?? "",
                Email = users?["Email"]?.ToString() ?? "",
                Phone = users?["Phone"]?.ToString() ?? "",
                AvatarImage = users?["AvatarImage"]?.ToString() ?? ""
            }
        };
        HttpContext.Session.SetString("IsActive", users?["IsActive"]?.ToString() ?? "0");
        //Console.WriteLine(dataupdated?.Usercreids?.ID);

        return dataupdated ?? new Dataupdated();
    }

}

public class PartialSelected
{
    public string? PartialName {get; set;}
}

public class Messagecode
{
    public int? Code {get; set;} = 0;
    public string? Message {get; set;} = "OK";
}

public class Defaultcode
{
    public List<int> Errorcode {get; set;} = [20,30, 55, 23, 94];
    public List<int> Successcode {get;set;} = [56, 57, 95, 96];
    public List<int> Neutralcode {get;set;} =[0, 97];
}

public class Parameters
{
    public Messagecode? Messagecode {get; set;} = new Messagecode();
    public PartialSelected? Partialselect {get; set;}
    public Defaultcode? Defaultcode {get; set;} = new Defaultcode();

}