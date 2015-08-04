desc "Imports a CSV file into an ActiveRecord table"
task :import_languages => :environment do
  lines = File.new(Rails.root.join("lib", "assets", "programming_languages.tsv")).readlines
  keys = ["yoc", "name", "creator"]
  relation_hash = {}
  lines.each do |line|
    values = line.strip.split("\t")
    pred_names = values.pop.split(', ')
    attributes = keys.zip(values).to_h
    relation_hash[attributes["name"]] = pred_names
    Language.create(attributes)
  end
  relation_hash.each do |child_name, pred_names|
    child = Language.find_by(name: child_name)
    pred_names.each do |pred_name|
      pred = Language.where("LOWER(name) LIKE '%#{pred_name.downcase}%'").take
      child.predecessors << pred if pred
    end
  end
end
