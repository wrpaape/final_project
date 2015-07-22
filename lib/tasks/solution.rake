require 'timeout'
task :solution => :environment do
  ActiveRecord::Base.logger = Logger.new(Rails.root.join("solution_queries.log"))
  def solution
    status = Timeout::timeout(5) do
    all_singles = Person.where(spouse_id: nil)
    gens_with_singles = all_singles.pluck(:generation).uniq
    gens_with_singles.each do |gen|
      genders_of_singles = all_singles.where(generation: gen).pluck(:gender)
      m_and_f_available = genders_of_singles.uniq.size == 2 ? true : false
      if m_and_f_available
        if genders_of_singles.count("F") > 1
          the_bachelor = all_singles.find_by({ generation: gen, gender: "M" })
          return the_bachelor
        else
          the_bachelorette = all_singles.find_by({ generation: gen, gender: "F" })
          return the_bachelorette
        end
      end
    end
    return "no bachelor(ette)s!"
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end