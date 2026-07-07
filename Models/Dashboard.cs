using System.ComponentModel.DataAnnotations;

namespace RealStateManagementWebapp.Models;

public class Dashboard
{
    public List<Propertycount>? Propertiescount {get;set;} = new List<Propertycount>();
}

public class Propertycount
{
    public int PropertyTypeID {get; set;}
    public int TOTAL {get;set;}
}