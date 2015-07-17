# g0_yobs = (1880..1890).to_a
# genders = ["M", "F"]

# 30.times do
#   g0_yob = g0_yobs.sample
#   g0_gender = genders.sample
#   g0_baby_name = BabyName.where("yob = #{g0_yob} AND gender = '#{g0_gender}'").sample
#   g0_name = g0_baby_name.name
#   g0_frequency = g0_baby_name.frequency

#   g0_spouse_yob = g0_yobs.sample
#   g0_spouse_gender = genders.reject { |gender| gender == g0_gender }.first
#   g0_baby_name = BabyName.where("yob = #{g0_spouse_yob} AND gender = '#{g0_spouse_gender}'").sample
#   g0_spouse_name = g0_baby_name.name
#   g0_spouse_frequency = g0_baby_name.frequency

#   g0 = Person.create(name: g0_name,
#                    gender: g0_gender,
#                       yob: g0_yob,
#                 frequency: g0_frequency)
#   g0_spouse = Person.create(name: g0_spouse_name,
#                           gender: g0_spouse_gender,
#                              yob: g0_spouse_yob,
#                        frequency: g0_spouse_frequency)

#   g0.spouse_id = g0_spouse.id
#   g0_spouse.spouse_id = g0.id
#   g0.save
#   g0_spouse.save


#   mother, father = g0.gender == "M" ? [g0_spouse, g0] : [g0, g0_spouse]

#   rand(8).times do
#     g1_gender = genders.sample
#     g1_yob = (g0_yob + g0_spouse_yob) / 2 + rand(20..35)
#     g1_baby_name = BabyName.where("yob = #{g1_yob} AND gender = '#{g1_gender}'").sample
#     g1_name = g1_baby_name.name
#     g1_frequency = g1_baby_name.frequency
#     Person.create(name: g1_name,
#                gender: g1_gender,
#                   yob: g1_yob,
#             frequency: g1_frequency,
#             mother_id: mother.id,
#             father_id: father.id)
#   end
# end

# remaining_generations = [1, 2, 3, 4]

# remaining_generations.each do |gen|
#   gx_bachelors_ettes = Person.where(spouse_id: nil).where(generation: gen)
#   if gen == 3
#     dad_grandfather = Person.where.not(spouse_id: nil).where(generation: 1).where(gender: "M").first
#     dad_grandmother = dad_grandfather.spouse
#     mom_grandfather = Person.where.not(spouse_id: nil).where(generation: 1).where(gender: "M").last
#     mom_grandmother = mom_grandfather.spouse

#     dad_baby_name = BabyName.find_by({ name: "Mike", gender: "M", yob: 1932 })
#     dad_frequency = dad_baby_name.frequency
#     mom_baby_name = BabyName.find_by({ name: "Carol", gender: "F", yob: 1934 })
#     mom_frequency = mom_baby_name.frequency

#     dad = { name: "Mike", gender: "M", yob: 1932, frequency: dad_frequency, mother_id: mom_grandmother.id, father_id: mom_grandfather.id }
#     mom = { name: "Carol", gender: "F", yob: 1934, frequency: mom_frequency, mother_id: mom_grandmother.id, father_id: mom_grandfather.id }
#     father = Person.create(dad)
#     mother = Person.create(mom)

#     father.spouse_id = mother.id
#     mother.spouse_id = father.id
#     father.save
#     mother.save

#     kids = [{ name: "Greg", gender: "M", yob: 1954 },
#             { name: "Marcia", gender: "F", yob: 1956 },
#             { name: "Peter", gender: "M", yob: 1957 },
#             { name: "Jan", gender: "F", yob: 1958 },
#             { name: "Bobby", gender: "M", yob: 1960 },
#             { name: "Cindy", gender: "F", yob: 1961 }]
#     kids.each do |kid|
#       kid[:frequency] = BabyName.find_by(kid).frequency
#       kid[:mother_id] = mother.id
#       kid[:father_id] = father.id
#       child = Person.create(kid)
#     end

#     gx_bachelors_ettes = Person.where(spouse_id: nil).where(generation: gen)
#     the_bachelor_ette_id = gx_bachelors_ettes.sample.id
#     gx_bachelors_ettes = gx_bachelors_ettes.where.not(id: the_bachelor_ette_id)
#   end



#   gx_bachelors_ettes.each do |gx|
#     valid_spouses = gx_bachelors_ettes.where(spouse_id: nil).where.not(mother_id: gx.mother_id).where.not(gender: gx.gender).where(generation: gen)
#     break if valid_spouses.count == 0
#     gx_spouse = valid_spouses.take
#     gx.spouse_id = gx_spouse.id
#     gx_spouse.spouse_id = gx.id
#     gx.save
#     gx_spouse.save


#     unless gen == 4
#       mother, father = gx.gender == "M" ? [gx_spouse, gx] : [gx, gx_spouse]
#       rand(8).times do
#         gy_gender = genders.sample
#         gy_yob = (mother.yob + father.yob) / 2 + rand(20..35)
#         gy_yob = gy_yob > 2014 ? 2014 : gy_yob
#         gy_baby_name = BabyName.where("yob = #{gy_yob} AND gender = '#{gy_gender}'").sample
#         gy_name = gy_baby_name.name
#         gy_frequency = gy_baby_name.frequency
#         Person.create(name: gy_name,
#                     gender: gy_gender,
#                        yob: gy_yob,
#                  frequency: gy_frequency,
#                  mother_id: mother.id,
#                  father_id: father.id)
#       end
#     end
#   end
# end

# env_descrip =
# """
# This problem set involves the ActiveRecord models |BabyName| and |Person|.

# The corresponding database table |baby_names| is seeded with data recorded from
# 1880 to 2014 on baby names with over 5 occurences (http://www.ssa.gov/oact/babynames/limits.html).

# The second table |people| is seeded with several interwoven families
# spanning up to 5 generations of |Person|s born between 1880 and 2014.

# All of the problems in this set can be solved by querying just the |people| table.
# """
# baby_names_and_people = Environment.create(
#   title: "people and baby_names",
#   description: env_descrip[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   models: { "Person"=>"person.rb", "BabyName"=>"baby_name.rb" }.to_json)

# prob_instruct =
# """
# |Person|s of the |people| table may have 0 or more |children| as per the ActiveRecord |has_many|
# association. Assuming your typical American household houses 1.5 |children|, and our database
# refrains from tracking pregnancies and the heights of its tenants, let us define a typical household
# of |people| as one having either 1 |or| 2 children.

# Complete the |solution| method so that it returns an array of ActiveRecord |Person| objects
# representing the |mother| and |father| of a typical household, |order|ed alphabetically by |name|.
# """
# def answer_avg_household
#   Person.where(:children_count=> [1, 2]).order(:name)
# end
# avg_household = baby_names_and_people.problems.create(
#   title: "...and here are our 1.5 kids",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: answer_avg_household.to_json)

# prob_instruct =
# """
# ~Here's the story, of a lovely lady...~

# Hidden within the |people| table is a |mother|, a |father|, and 6 |children|
# having |name|s of the Brady Bunch and |yob|s corresponding to the years of birth
# of the actors who played their roles.

# Complete the |solution| method so that it returns an array of ActiveRecord |Person| objects
# representing the Brady Bunch that is |order|ed from youngest to oldest.
# """
# def answer_brady_bunch
#   mike_brady = Person.find_by({name: "Mike", children_count: 6})
#   carol_brady = mike_brady.spouse
#   brady_bunch = mike_brady.children.order(yob: :desc).map{ |brady_child|  brady_child }
#   if mike_brady.yob > carol_brady.yob
#     brady_bunch << mike_brady << carol_brady
#   else
#     brady_bunch << carol_brady << mike_brady
#   end
#   brady_bunch
# end
# the_brady_bunch = baby_names_and_people.problems.create(
#   title: "The Brady Bunch",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: answer_brady_bunch.to_json)

# prob_instruct =
# """
# Within the |people| family tree, all |Person|s were able to find a non-sibling |spouse|
# of the opposite gender who was also born in their |generation|. In other words, all within
# a generation were married off two by two until a lonely pool of |\"M\"|s or |\"F\"|s remained. All,
# that is, except for one lucky individual.

# Complete the |solution| method so that it returns the ActiveRecord |Person| object representing the Bachelor(ette).
# """
# def answer_bachelor
#   all_singles = Person.where(spouse_id: nil)
#   gens_with_singles = all_singles.pluck(:generation).uniq
#   gens_with_singles.each do |gen|
#     genders_of_singles = all_singles.where(generation: gen).pluck(:gender)
#     m_and_f_available = genders_of_singles.uniq.size == 2 ? true : false
#     if m_and_f_available
#       if genders_of_singles.count("F") > 1
#         the_bachelor = all_singles.find_by({ generation: gen, gender: "M" })
#         return the_bachelor
#       else
#         the_bachelorette = all_singles.find_by({ generation: gen, gender: "F" })
#         return the_bachelorette
#       end
#     end
#   end
# end
# the_bachelor = baby_names_and_people.problems.create(
#   title: "The Bachelor(ette?)",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: answer_bachelor.to_json)

# prob_instruct =
# """
# Every |Person| was |name|d by their |mother| and |father| corresponding to a |BabyName| of the same |yob|.
# Accordingly, for every |Person|, person_example, born in the year person_example.yob, there were

# |BabyName.find_by({ name: person_example.name, gender: person_example.gender, yob: person_example.yob}).frequency - 1|

# other |Person|s born in the States that year sharing the same name. To save you some time and to
# spare our servers the cost of querying a 1825433-entry table thousands of times, the |frequency| of a |Person|s
# name for their |gender| and |yob| has been cached as:

# |Person.frequency|

# when |people| was seeded. The Laziest Parents Award will go to the
# |mother| and |father| of the |Person| born with the most common name for every generation.

# Complete the |solution| method so that it returns a 4 element array composed of 2 element arrays of ActiveRecord |Person| objects
# representing the laziest parents of each generation, |order|ed by generation in the following format:

# [ [gen0_lazy_mother, gen0_lazy_father], ..., ..., [gen3_lazy_mother, gen3_lazy_father] ]
# """
# lazy_parents_award = baby_names_and_people.problems.create(
#   title: "The Laziest Parents Award",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"))



# admin = User.create(name: "admin", password: "admin", password_confirmation: "admin", admin: true)



# raw_avg_household =
# """
# def solution
#   Person.where(:children_count=> [1, 2]).order(:name)
# end

# solution
# """
# raw_avg_household = raw_avg_household[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n")

# raw_bachelor =
# """
# def solution
#   all_singles = Person.where(spouse_id: nil)
#   gens_with_singles = all_singles.pluck(:generation).uniq
#   gens_with_singles.each do |gen|
#     genders_of_singles = all_singles.where(generation: gen).pluck(:gender)
#     m_and_f_available = genders_of_singles.uniq.size == 2 ? true : false
#     if m_and_f_available
#       if genders_of_singles.count(\"F\") > 1
#         the_bachelor = all_singles.find_by({ generation: gen, gender: \"M\" })
#         return the_bachelor
#       else
#         the_bachelorette = all_singles.find_by({ generation: gen, gender: \"F\" })
#         return the_bachelorette
#       end
#     end
#   end
# end

# solution
# """
# raw_bachelor = raw_bachelor[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n")

# raw_brady_bunch =
# """
# def solution
#   mike_brady = Person.find_by({name: \"Mike\", children_count: 6})
#   carol_brady = mike_brady.spouse
#   brady_bunch = mike_brady.children.order(yob: :desc).map{ |brady_child|  brady_child }
#   if mike_brady.yob > carol_brady.yob
#     brady_bunch << mike_brady << carol_brady
#   else
#     brady_bunch << carol_brady << mike_brady
#   end
#   brady_bunch
# end

# solution
# """
# raw_brady_bunch = raw_brady_bunch[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n")

# SolvedProblem.create(
#   solution: raw_bachelor,
#   sol_char_count: 479,
#   time_exec_total: 0.2358,
#   time_query_total: 0.0013,
#   time_query_min: 0.000002,
#   time_query_max: 0.000006,
#   time_query_avg: 0.00000325,
#   num_queries: 4,
#   user_id: admin.id,
#   problem_id: the_bachelor.id,
#   environment_id: baby_names_and_people.id)

crops = {
  :barley=> {
    :price=> 5.62/40,
    :yield=> 71.3*40
  },
  :beans=> {
    :price=> 35.8/100,
    :yield=> 1753
  },
  :corn=> {
    :price=> 4.11/56,
    :yield=> 171*56
  },
  :cotton=> {
    :price=> 0.80,
    :yield=> 838
  },
  :flaxseed=> {
    :price=> 13.2/56,
    :yield=> 21.1*56
  },
  :hay=> {
    :price=> 178/2000,
    :yield=> 2.45*2000
  },
  :hops=> {
    :price=> 1.83,
    :yield=> 1868
  },
  :lentils=> {
    :price=> 21.1/100,
    :yield=> 1300
  },
  :oats=> {
    :price=> 3.54/60,
    :yield=> 68.6*60
  },
  :peanuts=> {
    :price=> 0.23,
    :yield=> 3932
  },
  :rice=> {
    :price=> 15.6/100,
    :yield=> 7572
  },
  :grain=> {
    :price=> 7.41/100,
    :yield=> 67.6*56
  },
  :soybeans=> {
    :price=> 12.5/60,
    :yield=> 47.8*60
  },
  :sunflower=> {
    :price=> 21.7/100,
    :yield=> 1469
  },
  :wheat=> {
    :price=> 6.34/100,
    :yield=> 44.3*100
  },
  :artichokes=> {
    :price=> 50.4/100,
    :yield=> 130*100
  },
  :asparagus=> {
    :price=> 111/100,
    :yield=> 31*100
  },
  :beets=> {
    :price=> 65.8/100,
    :yield=> 16.72*2000
  },
  :broccoli=> {
    :price=> 35.1/100,
    :yield=> 147*100
  },
  ("brussel sprouts".to_sym)=> {
    :price=> 36.5/100,
    :yield=> 180*100
  },
  :cabbage=> {
    :price=> 17.7/100,
    :yield=> 357*100
  },
  :carrots=> {
    :price=> 33.1/100,
    :yield=> 342*100
  },
  :cauliflower=> {
    :price=> 46/100,
    :yield=> 186*100
  },
  :celery=> {
    :price=> 20/100,
    :yield=> 636*100
  },
  :mushrooms=> {
    :price=> 7.79/6.55,
    :yield=> 6.55*43560
  },
  :cucumbers=> {
    :price=> 26.6/100,
    :yield=> 184*100
  },
  :eggplant=> {
    :price=> 25.1/100,
    :yield=> 291*100
  },
  ("escarole & endive".to_sym)=> {
    :price=> 29.5/100,
    :yield=> 180*100
  },
  :garlic=> {
    :price=> 68.2/100,
    :yield=> 163*100
  },
  ("collard greens".to_sym)=> {
    :price=> 21.6/100,
    :yield=> 119*100
  },
  :lettuce=> {
    :price=> 23.1/100,
    :yield=> 366*100
  },
  :cantaloupe=> {
    :price=> 18.6/100,
    :yield=> 236*100
  },
  :okra=> {
    :price=> 46.1/100,
    :yield=> 60*100
  },
  :onions=> {
    :price=> 11.2/100,
    :yield=> 523*100
  },
  :peas=> {
    :price=> 399/2000,
    :yield=> 1.93*2000
  },
  ("bell peppers".to_sym)=> {
    :price=> 38.9/100,
    :yield=> 330*100
  },
  :pumpkins=> {
    :price=> 10.6/100,
    :yield=> 266*100
  },
  :radishes=> {
    :price=> 38.9/100,
    :yield=> 92*100
  },
  :spinach=> {
    :price=> 40.5/100,
    :yield=> 158*100
  },
  :squash=> {
    :price=> 38.1/100,
    :yield=> 149*100
  },
  ("sweet corn".to_sym)=> {
    :price=> 26.6/100,
    :yield=> 118*100
  },
  :tomatoes=> {
    :price=> 42.5/100,
    :yield=> 280*100
  },
  :apples=> {
    :price=> 34400,
    :yield=> 0.383
  },
  :strawberries=> {
    :price=> 82.9/100,
    :yield=> 505*100
  }
}

rand(150..200).times do
  farmer = Farmer.create(name: Faker::Name.name)
  Farm.create(farmer_id: farmer.id)
end

rand(15..20).times do
  Client.create(name: Faker::Company.name + " #{Faker::Company.suffix}" * rand(2),
             revenue: Math.exp(rand(11..16)))
end

price_hash = {}
crops.each do |crop, hash|
  Crop.create(name: crop, yield: hash["yield"])
  price_hash[crop] = hash["price"]
end

Client.all.each do |client|
  starting_revenue = client.revenue
  available_revenue = starting_revenue
  loop do
    contract_total = rand(0.02..0.1)*starting_revenue
    break unless (contract_total < available_revenue || clien.id == 13)
    crop = Crop.all.sample
    contract_price = rand(0.75..1.25)*crop.price
    contract_weight = contract_total / contract_price
    farmer = Farmer.all.sample
    Contract.create(weight: contract_weight,
                     price: contract_price,
                 farmer_id: farmer.id,
                 client_id: client.id,
                   crop_id: crop.id)
    available_revenue -= contract_total

    field_size = contract_weight / crop.yield
    field_upkeep = rand(0.6..0.9) * contract_price
    farm = farmer.farm
    Field.create(size: field_size,
               upkeep: field_upkeep,
              farm_id: farm.id,
              crop_id: crop.id)
    break if (available_revenue < 0 && clien.id == 13)
  end
end

Farmer.all.each do |farmer|
  farm = farmer.farm
  contracts_revenue = farmer.contracts.sum("price * weight")
  fields_cost = farm.fields.sum(:upkeep)
  farm_maintenance = farmer.id == 169 ? (contracts_revenue - rand(1.1..1.2) * fields_cost) : (contracts_revenue - rand(0.5..0.8) * fields_cost)
  farm.update(maintenance: farm_maintenance)
end


