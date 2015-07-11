task :solution => :environment do
  def solution
    Person.limit(5)
  end
  
  puts solution.to_json
end