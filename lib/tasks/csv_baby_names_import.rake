desc "Imports a CSV file into an ActiveRecord table"
task :csv_baby_names_import => :environment do
  yobs = (1880..2014).to_a
  yobs.each do |yob|
    lines = File.new("/Users/Reid/my_projects/tiy/week10/day3/final_project/lib/assets/names/yob#{yob}.txt").readlines
    keys = ["name", "gender", "frequency", "yob"]
    lines.each do |line|
      values = line.strip.split(',') << yob
      attributes = keys.zip(values).to_h
      BabyName.create(attributes)
    end
    puts yob
  end
end
