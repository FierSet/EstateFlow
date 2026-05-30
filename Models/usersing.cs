using System.ComponentModel.DataAnnotations;

namespace RealStateManagementWebapp.Models;

public class Usersingin
{
    [Required]
    public string? Email {get; set;}

    [Required]
    public string? Password {get; set;}
}