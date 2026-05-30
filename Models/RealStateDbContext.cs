using Microsoft.EntityFrameworkCore;

namespace RealStateManagementWebapp.Models;

public class RealStateDbContext : DbContext
{
    public RealStateDbContext(DbContextOptions<RealStateDbContext> options) : base(options) { }

    // Add DbSets for your tables here, e.g.:
    // public DbSet<User> Users { get; set; }
    // For now, we'll just use it for connection testing
}