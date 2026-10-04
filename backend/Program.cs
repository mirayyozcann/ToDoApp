var builder = WebApplication.CreateBuilder(args);

// 1. CORS politikasını ekle (Her yerden gelen isteklere izin ver)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy => policy.AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader());
});

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// 2. CORS'u aktif et (app.MapControllers den hemen önce olmalı)
app.UseCors("AllowAll");



app.MapControllers();

app.Run();