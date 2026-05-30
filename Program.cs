using RealStateManagementWebapp.Models;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Load the connection string template from configuration
var connectiontamplate = builder.Configuration["database:ConnectionString_EstateFlow"] ?? string.Empty;
var connectionString = connectiontamplate
.Replace("${DB_SERVER_EstateFlow}", Environment.GetEnvironmentVariable("DB_SERVER_EstateFlow") ?? string.Empty)
.Replace("${DB_NAME_EstateFlow}", Environment.GetEnvironmentVariable("DB_NAME_EstateFlow") ?? string.Empty)
.Replace("${DB_USER_EstateFlow}", Environment.GetEnvironmentVariable("DB_USER_EstateFlow") ?? string.Empty)
.Replace("${DB_PASSWORD_EstateFlow}", Environment.GetEnvironmentVariable("DB_PASSWORD_EstateFlow") ?? string.Empty);
// Log the final connection string for debugging (be cautious with sensitive information)

// Add services to the container.
builder.Services.AddControllersWithViews()
    .AddRazorRuntimeCompilation(); // Add this line

builder.Services.AddDbContext<RealStateDbContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddSession();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseStaticFiles();

app.UseSession();

app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Customer}/{action=Customer}/{id?}")//"{controller=Customer}/{action=Customer}/{id?}") //"{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();


app.Run();
