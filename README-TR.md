

<div align="center">

# 🚀 Full-Stack Yapılacaklar & Görev Yönetim Ekosistemi
### Modern, Güvenli, Ölçeklenebilir, İki Dilli (TR/EN) ve İstatistik Destekli Platform

**[🇹🇷 Türkçe](README.md) | [🇬🇧 English](README_EN.md)**

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/.NET_8-%23512BD4.svg?style=for-the-badge&logo=dotnet&logoColor=white" alt=".NET 8" />
  <img src="https://img.shields.io/badge/PostgreSQL-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/DataGrip-%23000000.svg?style=for-the-badge&logo=datagrip&logoColor=white" alt="DataGrip" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
</p>

*Günlük iş akışını optimize etmek, görevleri verimli bir şekilde yönetmek, üretkenlik istatistiklerini takip etmek ve uygulama her açıldığında kullanıcıya motivasyon sağlamak amacıyla geliştirilmiş modern bir full-stack uygulama.*

</div>

---

## 🌟 Temel Özellikler

* **⚡ Akıcı ve Modern Arayüz:** Flutter ile geliştirilmiş, akıcı, yüksek performanslı ve platformlar arası kullanıcı deneyimi.
* **🇹🇷/🇬🇧 İki Dilli Destek (TR/EN):** Kullanıcıların uygulama içerisinden Türkçe ve İngilizce dilleri arasında kolayca geçiş yapabilmesini sağlayan yerelleştirilmiş arayüz.
* **📊 Gelişmiş İstatistik Paneli:** Tamamlanan, bekleyen ve toplam görev metriklerini görselleştirerek üretkenliği takip etmeyi sağlayan istatistik modülü.
* **💡 Dinamik Motivasyon Sistemi:** Uygulama her açıldığında, seçilen dile uygun ilham verici sözlerle kullanıcıyı karşılayan motivasyon sistemi.
* **🎨 UI/UX Tasarımı ve Modellemesi:** Ön yüz arayüzü ve kullanıcı akışları, geliştirme öncesinde modern ve kullanıcı odaklı bir deneyim oluşturmak amacıyla **Google Stitch** kullanılarak tasarlandı.
* **🛡️ Güçlü Backend:** .NET 8 Web API ile desteklenen güvenli ve yüksek performanslı RESTful servisler.
* **🐘 Güvenilir Veri Depolama:** PostgreSQL ve DataGrip kullanılarak verimli ilişkisel veri yönetimi.
* **🔒 Ortam Güvenliği:** Hassas veritabanı bağlantı dizeleri ve kimlik bilgileri kaynak kodundan ayrı tutularak güvenlik sağlanır.

---

## 🛠️ Teknoloji Yığını ve Mimari

| Katman | Teknoloji / Araç | Amaç |
| :--- | :--- | :--- |
| **Frontend** | Flutter, Dart & Google Stitch | Platformlar arası istemci uygulaması, dil desteği, istatistikler, motivasyon sistemi ve görsel tasarım |
| **Backend** | .NET 8, C#, Entity Framework Core | RESTful API servisleri, veri işleme ve iş mantığı |
| **Veritabanı & Araç** | PostgreSQL & DataGrip | İlişkisel veritabanı yönetimi ve sorgu optimizasyonu |
| **Versiyon Kontrolü** | Git & GitHub | Kaynak kod yönetimi ve depo barındırma |

---

## 🏗️ Proje Mimarisi ve Kurulum

```text
TodoApp/
├── frontend/  # Flutter istemci kodları (Arayüz, TR/EN dil dosyaları, istatistik modülü, motivasyon servisi, durum yönetimi)
│   └── Çalıştır: cd frontend && flutter pub get && flutter run
│
└── backend/   # .NET 8 Web API, katmanlı mimari ve veritabanı bağlamları
    └── Çalıştır: cd backend && dotnet ef database update && dotnet run
```

