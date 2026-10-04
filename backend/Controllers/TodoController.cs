using Microsoft.AspNetCore.Mvc;
using Dapper;
using Npgsql;

[Route("api/[controller]")]
[ApiController]
public class TodoController : ControllerBase
{
    private readonly IConfiguration _configuration;

    public TodoController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    private NpgsqlConnection GetConnection() =>
        new NpgsqlConnection(_configuration.GetConnectionString("DefaultConnection"));

    [HttpPost]
    public async Task<IActionResult> CreateTodo([FromBody] TodoCreateDto request)
    {
        using var connection = GetConnection();
    
        // SQL sorgusuna 'day' ve 'deadline_time' kolonlarını ekledik
        var sql = @"INSERT INTO todos (user_id, title, description, is_completed, priority, category, day, deadline_time) 
                VALUES (@UserId, @Title, @Description, false, @Priority, @Category, @Day, @DeadlineTime)";
    
        await connection.ExecuteAsync(sql, new {
            UserId = request.UserId,
            Title = request.Title ?? "",
            Description = request.Description ?? "",
            Priority = request.Priority ?? "Normal",
            Category = request.Category ?? "Genel",
            Day = request.Day ?? "",             // <-- Buraya eklendi
            DeadlineTime = request.DeadlineTime ?? "" // <-- Buraya eklendi
        });

        return Ok(new { message = "Todo başarıyla eklendi." });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateTodo(int id, [FromBody] TodoUpdateDto request)
    {
        using var connection = GetConnection();
        
        // SQL sorgusuna category, day ve deadline_time alanlarını ekledik
        var sql = @"UPDATE todos 
                    SET title = @Title, 
                        description = @Description, 
                        is_completed = @IsCompleted, 
                        priority = @Priority, 
                        category = @Category, 
                        day = @Day, 
                        deadline_time = @DeadlineTime 
                    WHERE todo_id = @Id";
        
        var rowsAffected = await connection.ExecuteAsync(sql, new {
            Id = id,
            Title = request.Title,
            Description = request.Description,
            IsCompleted = request.IsCompleted,
            Priority = request.Priority ?? "Normal",
            Category = request.Category ?? "Genel",
            Day = request.Day ?? "",
            DeadlineTime = request.DeadlineTime ?? ""
        });

        if (rowsAffected == 0)
        {
            return NotFound(new { message = "Güncellenecek todo bulunamadı." });
        }

        return Ok(new { message = "Todo güncellendi." });
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteTodo(int id)
    {
        using var connection = GetConnection();
        // Silme sorgusunda id yerine todo_id kullanıldı.
        var sql = "DELETE FROM todos WHERE todo_id = @Id";
        
        var rowsAffected = await connection.ExecuteAsync(sql, new { Id = id });

        if (rowsAffected == 0)
        {
            return NotFound(new { message = "Silinecek todo bulunamadı." });
        }

        return Ok(new { message = "Todo silindi." });
    }
    [HttpGet("stats/{userId}")]
    public async Task<IActionResult> GetUserStats(int userId)
    {
        using var connection = GetConnection();
        var sql = @"
        SELECT 
            CAST(COUNT(*) AS INTEGER) AS TotalCount,
            CAST(SUM(CASE WHEN is_completed = true THEN 1 ELSE 0 END) AS INTEGER) AS CompletedCount,
            CAST(SUM(CASE WHEN is_completed = false THEN 1 ELSE 0 END) AS INTEGER) AS NotCompletedCount,
            CAST(SUM(CASE WHEN LOWER(TRIM(priority)) IN ('yüksek', 'yuksek', 'high') THEN 1 ELSE 0 END) AS INTEGER) AS HighPriorityCount,
            CAST(SUM(CASE WHEN LOWER(TRIM(priority)) IN ('normal', 'medium') THEN 1 ELSE 0 END) AS INTEGER) AS NormalPriorityCount,
            CAST(SUM(CASE WHEN LOWER(TRIM(priority)) IN ('düşük', 'dusuk', 'low') THEN 1 ELSE 0 END) AS INTEGER) AS LowPriorityCount
        FROM todos 
        WHERE user_id = @UserId";
    
        var stats = await connection.QueryFirstOrDefaultAsync<TodoStatsDto>(sql, new { UserId = userId });
    
        return Ok(stats ?? new TodoStatsDto());
    }
    [HttpGet("{userId}")]
    public async Task<IActionResult> GetTodosByUserId(int userId)
    {
        using var connection = GetConnection();
        // GÜNCELLENEN KISIM: day ve deadline_time alanları sorguya eklendi
        var sql = "SELECT todo_id, user_id, title, description, is_completed, priority, category, day, deadline_time FROM todos WHERE user_id = @UserId ORDER BY todo_id DESC";
        
        var todos = await connection.QueryAsync(sql, new { UserId = userId });

        return Ok(todos);
    }
}

public class TodoCreateDto
{
    public int UserId { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public string Priority { get; set; }
    
    // --- BU SATIRI EKLERSENİZ HATA DÜZELECEKTİR ---
    public string Category { get; set; } 
    
    public string Day { get; set; }
    public string DeadlineTime { get; set; }
}

public class TodoUpdateDto
{
    public string Title { get; set; }
    public string Description { get; set; }
    
    [System.Text.Json.Serialization.JsonPropertyName("isCompleted")]
    public bool IsCompleted { get; set; }
    
    public string Priority { get; set; }
    public string Category { get; set; }      // <-- Eklendi
    public string Day { get; set; }           // <-- Eklendi
    public string DeadlineTime { get; set; }  // <-- Eklendi

}
public class TodoStatsDto
{
    public int TotalCount { get; set; }
    public int CompletedCount { get; set; }
    public int NotCompletedCount { get; set; }
    public int HighPriorityCount { get; set; }
    public int NormalPriorityCount { get; set; }
    public int LowPriorityCount { get; set; }
    
    public string Day { get; set; }          
    public string DeadlineTime { get; set; }
}