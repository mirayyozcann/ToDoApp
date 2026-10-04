<div align="center">

# 🚀 Full-Stack To-Do ve Görev Yönetim Ekosistemi
### Modern, Güvenli, Ölçeklenebilir, Çift Dil (TR/EN) ve İstatistik Destekli Platform

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/.NET_8-%23512BD4.svg?style=for-the-badge&logo=dotnet&logoColor=white" alt=".NET 8" />
  <img src="https://img.shields.io/badge/PostgreSQL-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/DataGrip-%23000000.svg?style=for-the-badge&logo=datagrip&logoColor=white" alt="DataGrip" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
</p>

*Günlük iş akışınızı optimize etmek, yerleşik Türkçe/İngilizce desteği ile görevleri verimli bir şekilde yönetmek, üretkenlik istatistiklerini takip etmek ve uygulama her açıldığında günlük motivasyon almak için tasarlanmış yeni nesil full-stack uygulama.*

</div>

---

## 🌟 Öne Çıkan Özellikler

* **⚡ Akıcı ve Modern Arayüz:** Akıcı, yüksek performanslı ve çapraz platform bir kullanıcı deneyimi için Flutter ile geliştirilmiştir.
* **🇹🇷/🇬🇧 Çift Dil Desteği (TR/EN):** Kullanıcıların Türkçe ve İngilizce arasında sorunsuz geçiş yapmasını sağlayan tam lokalize arayüz.
* **📊 Gelişmiş İstatistik Paneli:** Üretkenliği takip etmek için tamamlanan, bekleyen ve genel görev metriklerini görselleştiren özel bir istatistik modülü.
* **💡 Dinamik Motivasyon Sistemi:** Kullanıcıları uygulama her açıldığında seçtikleri dile uygun ilham verici sözlerle karşılayan keyifli bir UX özelliği.
* **🎨 UI/UX Tasarım ve Prootipleme:** Projenin arayüz akışı ve tasarımı, kodlama aşamasına geçilmeden önce kullanıcı odaklı bir deneyim sunması için **Google Stitch** ile prototiplenmiştir.
* **🛡️ Güçlü Backend:** .NET 8 Web API tarafından desteklenen yüksek performanslı ve güvenli RESTful servisler.
* **🐘 Güvenilir Veri Saklama:** PostgreSQL ve DataGrip kullanılarak gerçekleştirilen verimli ilişkisel veri yönetimi.
* **🔒 Çevre Güvenliği:** Hassas veritabanı bağlantı dizeleri ve kimlik bilgileri kaynak kodundan tamamen izole edilmiştir.

---

## 🛠️ Teknoloji Yığını ve Mimari

| Katman | Teknoloji / Araç | Amaç |
| :--- | :--- | :--- |
| **Frontend** | Flutter, Dart & Google Stitch | Çapraz platform istemci uygulaması, lokalizasyon, istatistikler, motivasyon akışı ve UI/UX prototipleme |
| **Backend** | .NET 8, C#, Entity Framework Core | RESTful API servisleri, veri işleme ve iş mantığı |
| **Veritabanı & Araç** | PostgreSQL & DataGrip | İlişkisel veritabanı yönetimi ve sorgu optimizasyonu |
| **Sürüm Kontrolü** | Git & GitHub | Kaynak kodu yönetimi ve depo barındırma |

---

## 🏗️ Proje Mimarisi ve Kurulum

```text
TodoApp/
├── frontend/  # Flutter istemci kodları (Arayüz, TR/EN lokalizasyon dosyaları, istatistik modülü, motivasyon servisi, durum yönetimi)
│   └── Çalıştırma: cd frontend && flutter pub get && flutter run
│
└── backend/   # .NET 8 Web API, katmanlı mimari ve veritabanı bağlamları
    └── Çalıştırma: cd backend && dotnet ef database update && dotnet run
