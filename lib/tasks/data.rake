require 'csv'
namespace :data do

  desc "import browser shares data"
  task :import => :environment do
    CSV.foreach(File.join(Rails.root, 'db/data/browser-ww-monthly-201205-201207-map.csv'), {headers: true}) do |row| 
      country = Country.create(name: row['Continent'].strip)
      row.each do |k, v|
        if k != 'Continent'
          browser = Browser.find_or_create_by_name(k.strip)
          PercentageValue.create(country_id: country.id, browser_id: browser.id, value: v.to_f)
        end
      end
    end
    puts 'done'
  end
end
