using Microsoft.AspNetCore.Mvc;
using Npgsql;
using Dapper;
using Microsoft.Extensions.Configuration;

[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly IConfiguration _configuration;

    public AuthController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    private NpgsqlConnection GetConnection()
    {
        var connectionString = _configuration.GetConnectionString("DefaultConnection");
        return new NpgsqlConnection(connectionString);
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] UserRegisterDto request)
    {
        using var connection = GetConnection();
        var sql = "INSERT INTO users (username, email, password) VALUES (@Username, @Email, @Password)";

        await connection.ExecuteAsync(sql, new
        {
            Username = request.Username,
            Email = request.Email,
            Password = request.Password
        });

        return Ok(new { message = "Kayıt işlemi başarıyla gerçekleştirildi." });
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] UserLoginDto request)
    {
        using var connection = GetConnection();
        
        
        var sql = "SELECT user_id, username, email FROM users WHERE (username = @User OR email = @User) AND password = @Password";

        var user = await connection.QueryFirstOrDefaultAsync(sql, new
        {
            User = request.UsernameOrEmail,
            Password = request.Password
        });

        if (user == null)
        {
            return Unauthorized(new { message = "Kullanıcı adı veya şifre hatalı." });
        }

        return Ok(new { message = "Giriş başarılı", user });
    }
}

public class UserLoginDto
{
    public string UsernameOrEmail { get; set; }
    public string Password { get; set; }
}

public class UserRegisterDto
{
    public string Username { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
}