using System.ComponentModel.DataAnnotations;

namespace RealStateManagementWebapp.Models;

public class Usercreids
{
    public int? ID {get; set;}
    public string? Email {get; set;}
    public bool IsActive {get; set;}
}

public class Userdata
{
    [Required(ErrorMessage = "First name is requiered")]
    public string? FirstName {get; set;}
    [Required(ErrorMessage = "Second name is requiered")]
    public string? SecondName {get; set;}
    [Required(ErrorMessage = "Father name is requiered")]
    public string? FathersName {get; set;}
    [Required(ErrorMessage = "Mother name is requiered")]
    public string? MothersName {get; set;}
    [Required(ErrorMessage = "Email is requiered")]
    public string? Email {get; set;}
    
    [Required(ErrorMessage = "Phone is requiered")]
    [Phone(ErrorMessage = "Phone is not valid")]
    public string? Phone {get; set;}
    public string? AvatarImage {get; set;}
}

public class ChangePassword
{
    [Required]
    public string? OldPassword {get; set;}
    
    [Required (ErrorMessage = "New password is required.") ]
    public string? Password1 {get; set;}
    [Compare("Password1", ErrorMessage = "Passwords do not match.")]
    public string? Password2 {get; set;}
}

public class Taxdata
{
    public string? FiscalInfoID {get; set;}
    public string? TaxID {get; set;}
    public string? UserID {get; set;}
    public string? COUNTRY {get; set;}
    public string? TaxIDtype {get; set;}
    public string? TypeName {get; set;}
    public string? ImageURL {get; set;}
}


public class Dataupdated
{
    public Usercreids? Usercreids {get; set;}
    public Userdata? Userdata {get; set;}
    public ChangePassword? ChangePassword {get; set;}

    public List<Taxdata>? Taxdatas {get; set;}
}