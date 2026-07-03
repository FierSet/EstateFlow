using System.ComponentModel.DataAnnotations;

namespace RealStateManagementWebapp.Models;

public class Property
{   
    
    public int? PropertyID {get; set;}
    public string? Title {get; set;}
    public string? Description {get;set;}
    public string? Country {get; set;}
    public string? Address {get;set;}
    public string? City {get;set;}
    public string? State {get;set;}
    public string? ZipCode {get;set;}
    public int? PropertyType {get;set;}
    public double? AREA {get;set;}
    public int? STATUS {get;set;}
    public double? RentPrice {get;set;}
    public double? SalePrice {get;set;}
    public string? Imageurl {get;set;}
    public List<Rooms>? Rooms {get; set;}
    public List<Owners>? Owners {get; set;}
}

public class Rooms
{
    public int? RoomID {get;set;}
    public int? PropertyID {get;set;}
    public string Remove {get;set;} = "false";
    public double? Size {get;set;}
    public string? Description {get;set;}
    public int? RoomType {get;set;}
    public string? Imageurl {get;set;}
}

public class Owners
{
    public string? OwnershipID {get;set;}
    public string? PropertyID {get;set;}
    public string? OwnerID {get;set;}
    public string? StartDate {get;set;}
    public float? OwnershipPercentage {get;set;}
    public bool? VERIFY {get;set;}
    public List<PropertyEvidence>? PropertyEvidence {get;set;} =  new List<PropertyEvidence>();
}

public class PropertyEvidence
{
    public string? Propertyevidence {get;set;}
    public Propertyverificationtype? Propertyverificationtype {get;set;}
    public string? ImageURL {get;set;}
    public string? URLVerification {get;set;}
}

public class Propertyverificationtype
{
    public string? PropertyverificationtypeID {get; set;}
    public string? TypeName {get; set;}
}

public class RoomType
{
    public string? RoomTypeID {get; set;}
    public string? RoomTypeName {get; set;}
}

public class PropertyType
{
    public string? PropertyTypeID {get; set;}
    public string? TypeName {get; set;} 
}

public class STATUS
{
    public string? StatusID {get; set;}
    public string? StatusName {get; set;}
}

public class Dropdown
{
    public List<STATUS>? STATUS {get;set;} =new List<STATUS>();
    public List<PropertyType>? PropertyType {get;set;} = new List<PropertyType>();
    public List<RoomType>? RoomType {get;set;} = new List<RoomType>();
    public List<Propertyverificationtype>? Propertyverificationtype {get;set;} = new List<Propertyverificationtype>();
}

public class Propertys
{
    public Usercreids? Usercreids {get; set;}
    public Property? Property {get; set;}
    public Dropdown? Dropdown {get; set;} = new Dropdown();

}

public class GetPropertieslist
{
    public Usercreids? Usercreids {get; set;}
    public int? Page {get; set;} = 1;
}