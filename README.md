# CMS Brute Force Uygulaması
Bu Ruby ile yazılmış olan uygulama, CMS'lere (WordPress, Joomla, Drupal, OpenCart, PrestaShop, WooCommerce) yönelik brute-force saldırıları gerçekleştirmek için tasarlanmıştır. Kullanıcıdan alınan URL listesine, kullanıcı adı ve parola listelerine göre brute-force işlemi yapar ve başarılı giriş denemelerini bir dosyaya kaydeder.

## Özellikler

- CMS tespiti: Uygulama her bir URL için hangi CMS'nin kullanıldığını tespit eder.
- CMS'ye özgü brute-force işlemi: Tespit edilen CMS'ye uygun giriş formuna brute-force denemesi yapılır.
- Başarılı girişlerin kaydedilmesi: Başarılı olan giriş denemeleri bir .txt dosyasına kaydedilir.
- Kullanıcı dostu arayüz: Uygulama başlangıcında ASCII sanatını ve yazar bilgilerini ekranda gösterir.

## Kullanılan Kütüphaneler

Uygulamanın çalışması için aşağıdaki Ruby kütüphaneleri gerekmektedir:

- `net/http`: HTTP isteklerini yapmak için kullanılır.
- `uri`: URL işleme fonksiyonlarını sağlamak için kullanılır.
- `colorize`: Terminal çıktısında renklendirme yapmak için kullanılır. Bu kütüphaneyi yüklemek için şu komutu kullanabilirsiniz:
