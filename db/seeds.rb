g0_yobs = (1880..1890).to_a
genders = ["M", "F"]

30.times do
  g0_yob = g0_yobs.sample
  g0_gender = genders.sample
  g0_baby_name = BabyName.where("yob = #{g0_yob} AND gender = '#{g0_gender}'").sample
  g0_name = g0_baby_name.name
  g0_frequency = g0_baby_name.frequency

  g0_spouse_yob = g0_yobs.sample
  g0_spouse_gender = genders.reject { |gender| gender == g0_gender }.first
  g0_baby_name = BabyName.where("yob = #{g0_spouse_yob} AND gender = '#{g0_spouse_gender}'").sample
  g0_spouse_name = g0_baby_name.name
  g0_spouse_frequency = g0_baby_name.frequency

  g0 = Person.create(name: g0_name,
                   gender: g0_gender,
                      yob: g0_yob,
                frequency: g0_frequency)
  g0_spouse = Person.create(name: g0_spouse_name,
                          gender: g0_spouse_gender,
                             yob: g0_spouse_yob,
                       frequency: g0_spouse_frequency)

  g0.update(spouse_id: g0_spouse.id)
  g0_spouse.update(spouse_id: g0.id)

  mother, father = g0.gender == "M" ? [g0_spouse, g0] : [g0, g0_spouse]

  rand(8).times do
    g1_gender = genders.sample
    g1_yob = (g0_yob + g0_spouse_yob) / 2 + rand(20..35)
    g1_baby_name = BabyName.where("yob = #{g1_yob} AND gender = '#{g1_gender}'").sample
    g1_name = g1_baby_name.name
    g1_frequency = g1_baby_name.frequency
    Person.create(name: g1_name,
               gender: g1_gender,
                  yob: g1_yob,
            frequency: g1_frequency,
            mother_id: mother.id,
            father_id: mother.spouse.id)
  end
end

remaining_generations = [1, 2, 3, 4]

remaining_generations.each do |gen|
  gx_bachelors_ettes = Person.where(spouse_id: nil).where(generation: gen)
  if gen == 3
    dad_grandfather = Person.where.not(spouse_id: nil).where(generation: 1).where(gender: "M").first
    dad_grandmother = dad_grandfather.spouse
    mom_grandfather = Person.where.not(spouse_id: nil).where(generation: 1).where(gender: "M").last
    mom_grandmother = mom_grandfather.spouse

    dad_baby_name = BabyName.find_by({ name: "Mike", gender: "M", yob: 1932 })
    dad_frequency = dad_baby_name.frequency
    mom_baby_name = BabyName.find_by({ name: "Carol", gender: "F", yob: 1934 })
    mom_frequency = mom_baby_name.frequency

    dad = { name: "Mike", gender: "M", yob: 1932, frequency: dad_frequency, mother_id: mom_grandmother.id, father_id: mom_grandfather.id }
    mom = { name: "Carol", gender: "F", yob: 1934, frequency: mom_frequency, mother_id: mom_grandmother.id, father_id: mom_grandfather.id }
    father = Person.create(dad)
    mother = Person.create(mom)

    father.update(spouse_id: mother.id)
    mother.update(spouse_id: father.id)

    kids = [{ name: "Greg", gender: "M", yob: 1954 },
            { name: "Marcia", gender: "F", yob: 1956 },
            { name: "Peter", gender: "M", yob: 1957 },
            { name: "Jan", gender: "F", yob: 1958 },
            { name: "Bobby", gender: "M", yob: 1960 },
            { name: "Cindy", gender: "F", yob: 1961 }]
    kids.each do |kid|
      kid[:frequency] = BabyName.find_by(kid).frequency
      kid[:mother_id] = mother.id
      kid[:father_id] = father.id
      child = Person.create(kid)
    end

    gx_bachelors_ettes = Person.where(spouse_id: nil).where(generation: gen)
    the_bachelor_ette_id = gx_bachelors_ettes.sample.id
    gx_bachelors_ettes = gx_bachelors_ettes.where.not(id: the_bachelor_ette_id)
  end



  gx_bachelors_ettes.each do |gx|
    valid_spouses = gx_bachelors_ettes.where(spouse_id: nil).where.not(mother_id: gx.mother_id).where.not(gender: gx.gender).where(generation: gen)
    break if valid_spouses.count == 0
    gx_spouse = valid_spouses.take
    gx.update(spouse_id: gx_spouse.id)
    gx_spouse.update(spouse_id: gx.id)

    unless gen == 4
      mother, father = gx.gender == "M" ? [gx_spouse, gx] : [gx, gx_spouse]
      rand(8).times do
        gy_gender = genders.sample
        gy_yob = (mother.yob + father.yob) / 2 + rand(20..35)
        gy_yob = gy_yob > 2014 ? 2014 : gy_yob
        gy_baby_name = BabyName.where("yob = #{gy_yob} AND gender = '#{gy_gender}'").sample
        gy_name = gy_baby_name.name
        gy_frequency = gy_baby_name.frequency
        Person.create(name: gy_name,
                    gender: gy_gender,
                       yob: gy_yob,
                 frequency: gy_frequency,
                 mother_id: mother.id,
                 father_id: mother.spouse.id)
      end
    end
  end
end

env_descrip =
"""
This problem set involves the ActiveRecord models |~BabyName| and |~Person|.

The corresponding database table |@baby_names| is seeded with data recorded from
1880 to 2014 on baby names with over 5 occurences in the US.

The second table |@people| is seeded with several interwoven families
spanning up to 5 |*generation|s of |~Person|s born between 1880 and 2014.

All of the problems in this set can be solved by querying just the |@people| table.
"""
family_tree = Environment.create(
  title: "The |@people| Family Tree",
  description: env_descrip[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  models: { "Person"=>"person.rb", "BabyName"=>"baby_name.rb" }.to_json)

prob_instruct =
"""
|~Person|s of the |@people| table may have 0 or more |&children| as per the ActiveRecord |#has_many|
association. Assuming your typical American household houses 1.5 |&children|, and our database
refrains from tracking pregnancies and the heights of its tenants, let us define a typical household
of |~Person|s as one having either 1 |?OR| 2 |&children|.

Complete the |%solution| method so that it returns an array of ActiveRecord |~Person| objects
representing the |&mother| and |&father| of a typical household, |#order|ed alphabetically by |*name|.

Note that |&children| is a custom method (see person.rb in the inspector) and not a pure ActiveRecord relation.
This method allows for |&mother|s and |&father|s to access the same ActiveRecord collection of |&children| without having to create an additional join table,
but at the cost of making 2 additional queries for every call.
"""
def answer_avg_household
  Person.where(children_count: [1, 2]).order(:name)
end
avg_household = family_tree.problems.create(
  title: "...and here are our 1.5 kids",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  answer: Array.wrap(answer_avg_household).to_json)

prob_instruct =
"""
~Here's the story, of a lovely lady...~

Hidden within the |@people| table is a |&mother|, a |&father|, and 6 |&children|
having |*name|s of the Brady Bunch and |*yob|s corresponding to the years of birth
of the actors who played their roles.

Complete the |%solution| method so that it returns an array of ActiveRecord |~Person| objects
representing the Brady Bunch that is |#order|ed from youngest to oldest.
"""
def answer_brady_bunch
  mike_brady = Person.find_by({name: "Mike", children_count: 6})
  carol_brady = mike_brady.spouse
  brady_bunch = mike_brady.children.order(yob: :desc).map{ |brady_child| brady_child }
  if mike_brady.yob > carol_brady.yob
    brady_bunch << mike_brady << carol_brady
  else
    brady_bunch << carol_brady << mike_brady
  end
  brady_bunch
end
the_brady_bunch = family_tree.problems.create(
  title: "The Brady Bunch",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  answer: Array.wrap(answer_brady_bunch).to_json)

prob_instruct =
"""
Within the |@people| family tree, all |~Person|s were able to find a non-sibling |&spouse|
of the opposite gender who was also born in their |*generation|. In other words, all within
a |*generation| were married off two by two until a lonely pool of |\"M\"|s or |\"F\"|s remained. All,
that is, except for one lucky individual.

Complete the |%solution| method so that it returns the ActiveRecord |~Person| object representing the Bachelor(ette).
"""
def answer_bachelor
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
the_bachelor = family_tree.problems.create(
  title: "The Bachelor(ette?)",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  answer: Array.wrap(answer_bachelor).to_json)

prob_instruct =
"""
Every |~Person| was |*name|d by their |&mother| and |&father| corresponding to a |~BabyName| of the same |*yob|.
Accordingly, for every |~Person|, |person_example|, born in the year |person_example.yob|, there were

|~BabyName||#.find_by({| |*name:| |`person_example.name||#,| |*gender:| |`person_example.gender||#,| |*yob:| |`person_example.yob||#})||*.frequency|| - 1|

other |~Person|s born in the States that year sharing the same |*name|. To save you some time and to
spare our servers the cost of querying a 1825433-entry table thousands of times, the |*frequency| of a |~Person|s
|*name| for their |*gender| and |*yob| has been cached as:

|~Person||*.frequency|

when |@people| was seeded. The Laziest Parents Award will go to the
|&mother| and |&father| of the |~Person| born with the most common |*name| for their |*generation|.

Complete the |%solution| method so that it returns an 8 element array of ActiveRecord |~Person| objects
representing the laziest parents of each |*generation|, |#order|ed by generation in the following format:

|%[gen0_lazy_mother, gen0_lazy_father, ..., ..., gen3_lazy_mother, gen3_lazy_father]|
"""
def answer_lazy_parents
  children_gens = [1, 2, 3, 4]
  laziest_parents = children_gens.map do |gen|
    max_freq_child = Person.where(generation: gen).order(frequency: :desc).take
    [max_freq_child.mother, max_freq_child.father]
  end
  laziest_parents.flatten
end
lazy_parents_award = family_tree.problems.create(
  title: "The Laziest Parents Award",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  answer: Array.wrap(answer_lazy_parents).to_json)






crops = {
  "barley"=> {
    "price"=> 5.62/40,
    "yield"=> 71.3*40
  },
  "beans"=> {
    "price"=> 35.8/100,
    "yield"=> 1753.0
  },
  "corn"=> {
    "price"=> 4.11/56,
    "yield"=> 171*56
  },
  "cotton"=> {
    "price"=> 0.80,
    "yield"=> 838.0
  },
  "flaxseed"=> {
    "price"=> 13.2/56,
    "yield"=> 21.1*56
  },
  "hay"=> {
    "price"=> 178.0/2000,
    "yield"=> 2.45*2000
  },
  "hops"=> {
    "price"=> 1.83,
    "yield"=> 1868.0
  },
  "lentils"=> {
    "price"=> 21.1/100,
    "yield"=> 1300.0
  },
  "oats"=> {
    "price"=> 3.54/60,
    "yield"=> 68.6*60
  },
  "peanuts"=> {
    "price"=> 0.23,
    "yield"=> 3932.0
  },
  "rice"=> {
    "price"=> 15.6/100,
    "yield"=> 7572.0
  },
  "grain"=> {
    "price"=> 7.41/100,
    "yield"=> 67.6*56
  },
  "soybeans"=> {
    "price"=> 12.5/60,
    "yield"=> 47.8*60
  },
  "sunflower"=> {
    "price"=> 21.7/100,
    "yield"=> 1469.0
  },
  "wheat"=> {
    "price"=> 6.34/100,
    "yield"=> 44.3*100
  },
  "artichokes"=> {
    "price"=> 50.4/100,
    "yield"=> 130.0*100
  },
  "asparagus"=> {
    "price"=> 111.0/100,
    "yield"=> 31.0*100
  },
  "beets"=> {
    "price"=> 65.8/100,
    "yield"=> 16.72*2000
  },
  "broccoli"=> {
    "price"=> 35.1/100,
    "yield"=> 147.0*100
  },
  "brussel sprouts"=> {
    "price"=> 36.5/100,
    "yield"=> 180.0*100
  },
  "cabbage"=> {
    "price"=> 17.7/100,
    "yield"=> 357.0*100
  },
  "carrots"=> {
    "price"=> 33.1/100,
    "yield"=> 342.0*100
  },
  "cauliflower"=> {
    "price"=> 46.0/100,
    "yield"=> 186.0*100
  },
  "celery"=> {
    "price"=> 20.0/100,
    "yield"=> 636.0*100
  },
  "mushrooms"=> {
    "price"=> 7.79/6.55,
    "yield"=> 6.55*43560
  },
  "cucumbers"=> {
    "price"=> 26.6/100,
    "yield"=> 184.0*100
  },
  "eggplant"=> {
    "price"=> 25.1/100,
    "yield"=> 291.0*100
  },
  "escarole & endive"=> {
    "price"=> 29.5/100,
    "yield"=> 180.0*100
  },
  "garlic"=> {
    "price"=> 68.2/100,
    "yield"=> 163.0*100
  },
  "collard greens"=> {
    "price"=> 21.6/100,
    "yield"=> 119.0*100
  },
  "lettuce"=> {
    "price"=> 23.1/100,
    "yield"=> 366.0*100
  },
  "cantaloupe"=> {
    "price"=> 18.6/100,
    "yield"=> 236.0*100
  },
  "okra"=> {
    "price"=> 46.1/100,
    "yield"=> 60.0*100
  },
  "onions"=> {
    "price"=> 11.2/100,
    "yield"=> 523.0*100
  },
  "peas"=> {
    "price"=> 399.0/2000,
    "yield"=> 1.93*2000
  },
  "bell peppers"=> {
    "price"=> 38.9/100,
    "yield"=> 330.0*100
  },
  "pumpkins"=> {
    "price"=> 10.6/100,
    "yield"=> 266.0*100
  },
  "radishes"=> {
    "price"=> 38.9/100,
    "yield"=> 92.0*100
  },
  "spinach"=> {
    "price"=> 40.5/100,
    "yield"=> 158.0*100
  },
  "squash"=> {
    "price"=> 38.1/100,
    "yield"=> 149.0*100
  },
  "sweet corn"=> {
    "price"=> 26.6/100,
    "yield"=> 118.0*100
  },
  "tomatoes"=> {
    "price"=> 42.5/100,
    "yield"=> 280.0*100
  },
  "apples"=> {
    "price"=> 0.383,
    "yield"=> 34400.0
  },
  "strawberries"=> {
    "price"=> 82.9/100,
    "yield"=> 505.0*100
  }
}

rand(1500..2000).times do
  farmer = Farmer.create(name: Faker::Name.first_name)
  Farm.create(farmer_id: farmer.id)
end

if Farmer.count.even?
  farmer = Farmer.create(name: Faker::Name.first_name)
  Farm.create(farmer_id: farmer.id)
end

rand(150..200).times do
  Client.create(name: Faker::Company.name + " #{Faker::Company.suffix}" * rand(2),
             revenue: Math.exp(rand(11..16)))
end

price_hash = {}
crops.each do |crop, hash|
  Crop.create(name: crop, yield: hash["yield"])
  price_hash[crop] = hash["price"]
end

last_contract_id = 0
end_of_2013 = Date.new(2013,12,31)
last_friday_2013 = end_of_2013
last_friday_2013 -= 1 until last_friday_2013.friday?
beginning_of_2016 = Date.new(2016)
first_monday_2016 = beginning_of_2016
first_monday_2016 += 1 until first_monday_2016.monday?

Client.all.each do |client|
  starting_revenue = client.revenue
  available_revenue = starting_revenue
  loop do
    contract_total = rand(0.0025..0.01) * starting_revenue
    break unless (contract_total < available_revenue || client.id == 130)
    crop = Crop.all.sample
    contract_price = rand(0.75..1.25) * price_hash[crop.name]
    contract_weight = contract_total / contract_price
    farmer = Farmer.all.sample
    if (last_contract_id % 500).zero?
      contract = Contract.create(weight: contract_weight,
                                  price: contract_price,
                                  start: rand(last_friday_2013..Date.new(2014)),
                                 finish: rand(Date.new(2016)..first_monday_2016),
                              farmer_id: farmer.id,
                              client_id: client.id,
                                crop_id: crop.id)
    else
      contract = Contract.create(weight: contract_weight,
                                  price: contract_price,
                                  start: rand(3.years.ago.to_date..Date.today),
                                 finish: rand(1.year.from_now.to_date..3.years.from_now.to_date),
                              farmer_id: farmer.id,
                              client_id: client.id,
                                crop_id: crop.id)
    end

    last_contract_id = contract.id
    available_revenue -= contract_total

    field_size = contract_weight / crop.yield
    field_upkeep = rand(0.6..0.9) * contract_total
    farm = farmer.farm
    Field.create(size: field_size,
               upkeep: field_upkeep,
              farm_id: farm.id,
              crop_id: crop.id)
    break if (available_revenue < 0 && client.id == 130)
  end
end

Farmer.all.each do |farmer|
  farm = farmer.farm
  contracts_revenue = farmer.contracts.sum("price * weight")
  fields_cost = farm.fields.sum(:upkeep)
  farm_maintenance = farmer.id == 1069 ? (rand(1.1..1.2) * (contracts_revenue - fields_cost)) : (rand(0.5..0.8) * (contracts_revenue - fields_cost))
  farm.update(maintenance: farm_maintenance)
end

env_descrip =
"""
This problem set involves the ActiveRecord models |~Farmer|, |~Farm|, |~Crop|, |~Field|, |~Client|, and |~Contract|.

The database tables |@crops| and |@contracts| are seeded based on the USDA's latest yields and market prices for a variety of crops.

|@clients| is seeded with |*revenue| with which to negotiate |~Contract|s.

Every |~Contract| |#join|ing a |~Farmer| and a |~Client| includes a single |~Crop|,
|*weight| in lbs required annually, the negotiated |price| to be paid in $ per lb, a |*start| |%Date|,
and a |*finish| |%Date|.

|~Farmer|s in turn plant |~Crop|s on their |&farm| in |~Field|s which will be harvested once every year.

Only one |~Crop| is planted on each |~Field|, and each |~Field| is |*size|d to |*yield| the |*weight| of its |&crop|
required by its |&crop|'s |&contract|.

Each |~Field| costs a fixed |*upkeep| to maintain based on its |*size| and the market price of its |&crop|.

In addition to the |*upkeep| of their |&farm|'s |&fields|, every |~Farmer| must acquire the cost of |*maintenance| of its |&farm|
"""
old_mac = Environment.create(
  title: "Old MacDonald |#has_one| |~Farm|",
  description: env_descrip[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  models: { "Farmer"=>"farmer.rb", "Farm"=>"farm.rb", "Crop"=>"crop.rb", "Field"=>"field.rb", "Client"=>"client.rb", "Contract"=>"Contract.rb" }.to_json)

prob_instruct =
"""
In the magical realm of SQLville, the terms of each |~Contract| remain the same year to year (as does every other value stored) and are never broken.
Each |~Contract| may last 1 year (harvest) or longer. Which |~Contract|s were negotiated to |*start| after the last Friday of 2013 |#AND| |*finish| before the first Monday
of 2016?

Complete the |%solution| method so that it returns an array of ActiveRecord |~Contract| objects representing those that |*start|
|?AND| |*finish| in the range of |%Date|s provided, |#order|ed by earliest |*start| |%Date|.
"""
def answer_technically_3_years
  end_of_2013 = Date.new(2013,12,31)
  last_friday_2013 = end_of_2013
  last_friday_2013 -= 1 until last_friday_2013.friday?
  beginning_of_2016 = Date.new(2016)
  first_monday_2016 = beginning_of_2016
  first_monday_2016 += 1 until first_monday_2016.monday?

  Contract.where("start > '#{last_friday_2013}' and finish < '#{first_monday_2016}'").order(:start)
end
technically_3_years = old_mac.problems.create(
  title: "Technically 3 Years",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  answer: Array.wrap(answer_technically_3_years).to_json)

prob_instruct =
"""
A 'booming' |~Crop| is one that |#has_many| |&contracts| and |&fields|. Which |~Crop| was involved in the highest number of |~Contract|s?
Which |~Crop| was planted over the greatest acreage?

Complete the |%solution| method so that it returns an array of the |*name|s of the two ActiveRecord |~Crop| objects representing the |~Crop| with the greatest
|#count| of |&contracts| and the |~Crop| with the greatest |#sum|med |*size| of its |&fields| in the following format:

|%[|`most_contracts_crop_name||%,| |`greatest_acreage_crop_name||%]|
"""
def answer_bandwagon_crops
  most_contracts_crop_name = Crop.select("crops.*, COUNT(contracts.id) AS contracts_count").joins(:contracts).group(:id).order("contracts_count DESC").take.name
  greatest_acreage_crop_name = Crop.select("crops.*, SUM(fields.size) AS total_acreage").joins(:fields).group(:id).order("total_acreage DESC").take.name

  [most_contracts_crop_name, greatest_acreage_crop_name]
end
bandwagon_crops = old_mac.problems.create(
  title: "Bandwagon Crops",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  answer: Array.wrap(answer_bandwagon_crops).to_json)

prob_instruct =
"""
Weary of his relentless success, Smitty W has decided to get away from it all to visit his old rural stomping grounds and catch up with his cousin.
Although their family has a rich history of being the best, it appears the leftover mediocrity was funneled into Smitty's cousin's |~Farm|ing operation.

In terms of |~Contract| income, Smitty's cousin is by definition |#average|--an equal number of |~Farmer|s will make more money than them this year as will make less than them.
If the money a |~Farmer| makes = the |#sum| of the money made from their |&clients|, who is Smitty's cousin?

Complete the |%solution| method so that it returns the |*name| of the ActiveRecord |~Farmer| object representing Smitty W's Cousin.
"""
def answer_smitty_w
  farmer_w_name = Farmer.select("farmers.*, SUM(contracts.price * contracts.weight) AS total_income").joins(:contracts).group(:id).order("total_income DESC").offset(Farmer.count / 2).take.name
end
smitty_w = old_mac.problems.create(
  title: "Old Farmer Werbenjagermanjensen",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  answer: Array.wrap(answer_smitty_w).to_json)

prob_instruct =
"""
El Niño + paleo-preaching tabloids = a great time to grow and sell |~Crop|s. All |~Farmer|s and |~Client|s of the |@farmers| and |@clients|
tables are expected to profit this year. All, that is, except for one deplorable duo of database (I tried) instances.

A profitable |~Client| will have enough |*revenue| to cover the |#sum| of the costs of its |&contracts|.

A profitable |~Farmer| will cover the |#sum| of the |*upkeep| costs of all the |~Field|s on their |&farm| plus its cost of |*maintenance| with the |#sum| of the money made from their |&contracts|.

Complete the |%solution| method so that it returns an array of the |*name|s of two ActiveRecord objects representing the |~Farmer|
and |~Client| who will not profit this year in the following format:

|%[||`unprofitable_client_name||%,| |`unprofitable_farmer_name||%]|
"""
def answer_the_red_line
  unprofitable_client_name = Client.select("clients.*, (SUM(contracts.price * contracts.weight) - revenue) AS profit").joins(:contracts).group(:id).order("profit").take.name

  farmers_w_income = Farmer.select("farmers.*, SUM(contracts.price * contracts.weight) AS total_income").joins(:contracts).group(:id).order(:id)
  farms_w_upkeep = Farm.select("farms.*, SUM(fields.upkeep) AS total_upkeep").joins(:fields).group(:id).order(:farmer_id)

  farmers_w_income.each_with_index do |farmer, index|
    farm = farms_w_upkeep[index]
    profit = farmer.total_income - farm.total_upkeep - farm.maintenance
    if profit < 0
      unprofitable_farmer_name = farmer.name
      return [unprofitable_client_name, unprofitable_farmer_name]
    end
  end
end
the_red_line = old_mac.problems.create(
  title: "The Red Line and the Black Thumb",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n\n"),
  answer: Array.wrap(answer_the_red_line).to_json)

raw_avg_household =
"""
def solution
  Person.where(:children_count=> [1, 2]).order(:name)
end

solution
"""
raw_avg_household = raw_avg_household[1..-2]

raw_brady_bunch =
"""
def solution
  mike_brady = Person.find_by({name: \"Mike\", children_count: 6})
  carol_brady = mike_brady.spouse
  brady_bunch = mike_brady.children.order(yob: :desc).map{ |brady_child|  brady_child }
  if mike_brady.yob > carol_brady.yob
    brady_bunch << mike_brady << carol_brady
  else
    brady_bunch << carol_brady << mike_brady
  end
  brady_bunch
end

solution
"""
raw_brady_bunch = raw_brady_bunch[1..-2]

raw_bachelor =
"""
def solution
  all_singles = Person.where(spouse_id: nil)
  gens_with_singles = all_singles.pluck(:generation).uniq
  gens_with_singles.each do |gen|
    genders_of_singles = all_singles.where(generation: gen).pluck(:gender)
    m_and_f_available = genders_of_singles.uniq.size == 2 ? true : false
    if m_and_f_available
      if genders_of_singles.count(\"F\") > 1
        the_bachelor = all_singles.find_by({ generation: gen, gender: \"M\" })
        return the_bachelor
      else
        the_bachelorette = all_singles.find_by({ generation: gen, gender: \"F\" })
        return the_bachelorette
      end
    end
  end
  return \"no bachelor(ette)s!\"
end

solution
"""
raw_bachelor = raw_bachelor[1..-2]

raw_lazy_parents =
"""
def solution
  children_gens = [1, 2, 3, 4]
  laziest_parents = children_gens.map do |gen|
    max_freq_child = Person.where(generation: gen).order(frequency: :desc).take
    [max_freq_child.mother, max_freq_child.father]
  end
  laziest_parents.flatten
end

solution
"""
raw_lazy_parents = raw_lazy_parents[1..-2]

raw_technicaly_3_years =
"""
def solution
  end_of_2013 = Date.new(2013,12,31)
  last_friday_2013 = end_of_2013
  last_friday_2013 -= 1 until last_friday_2013.friday?
  beginning_of_2016 = Date.new(2016)
  first_monday_2016 = beginning_of_2016
  first_monday_2016 += 1 until first_monday_2016.monday?

  Contract.where(\"start > '#{last_friday_2013}' and finish < '#{first_monday_2016}'\").order(:start)
end

solution
"""
raw_technicaly_3_years = raw_technicaly_3_years[1..-2]

raw_bandwagon_crops =
"""
def solution
  most_contracts_crop_name = Crop.select(\"crops.*, COUNT(contracts.id) AS contracts_count\").joins(:contracts).group(:id).order(\"contracts_count DESC\").take.name
  greatest_acreage_crop_name = Crop.select(\"crops.*, SUM(fields.size) AS total_acreage\").joins(:fields).group(:id).order(\"total_acreage DESC\").take.name

  [most_contracts_crop_name, greatest_acreage_crop_name]
end

solution
"""
raw_bandwagon_crops = raw_bandwagon_crops[1..-2]

raw_smitty_w =
"""
def solution
  farmer_w_name = Farmer.select(\"farmers.*, SUM(contracts.price * contracts.weight) AS total_income\").joins(:contracts).group(:id).order(\"total_income DESC\").offset(Farmer.count / 2).take.name
end

solution
"""
raw_smitty_w = raw_smitty_w[1..-2]

raw_the_red_line =
"""
def solution
  unprofitable_client_name = Client.select(\"clients.*, (SUM(contracts.price * contracts.weight) - revenue) AS profit\").joins(:contracts).group(:id).order(\"profit\").take.name

  farmers_w_income = Farmer.select(\"farmers.*, SUM(contracts.price * contracts.weight) AS total_income\").joins(:contracts).group(:id).order(:id)
  farms_w_upkeep = Farm.select(\"farms.*, SUM(fields.upkeep) AS total_upkeep\").joins(:fields).group(:id).order(:farmer_id)

  farmers_w_income.each_with_index do |farmer, index|
    farm = farms_w_upkeep[index]
    profit = farmer.total_income - farm.total_upkeep - farm.maintenance
    if profit < 0
      unprofitable_farmer_name = farmer.name
      return [unprofitable_client_name, unprofitable_farmer_name]
    end
  end
end

solution
"""
raw_the_red_line = raw_the_red_line[1..-2]

# admin = User.create(name: "admin", password: "admin", password_confirmation: "admin", admin: true, email: "admin@admin.com")

# SolvedProblem.create(
#   solution: raw_avg_household,
#   total queries: 1,
#    shortest query: 3.400 ms,
#     longest query: 3.400 ms,
#     average query: 3.400 ms,
#  total query time: 3.400 ms,
#   time to execute: 506.5 ms,
# non-ws char count: 80,
#   user_id: admin.id,
#   problem_id: avg_household.id,
#   environment_id: family_tree.id)
#     total queries:1
#    shortest query:2.700 ms
#     longest query:2.700 ms
#     average query:2.700 ms
#  total query time:2.700 ms
#   time to execute:76.39 ms
# non-ws char count:49
#           correct:true

# SolvedProblem.create(
#   solution: raw_brady_bunch,
#     total queries:3
#    shortest query:200.0 μs
#     longest query:500.0 μs
#     average query:333.3 μs
#  total query time:1.000 ms
#   time to execute:309.1 ms
# non-ws char count:317
#   user_id: admin.id,
#   problem_id: the_brady_bunch.id,
#   environment_id: family_tree.id)
#     total queries:5
#    shortest query:700.0 μs
#     longest query:16.90 ms
#     average query:4.800 ms
#  total query time:24.00 ms
#   time to execute:165.8 ms
# non-ws char count:286
#           correct:true

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
#   environment_id: family_tree.id)

# SolvedProblem.create(
#   solution: raw_lasy_parents,
#   sol_char_count: 479,
#   time_exec_total: 0.2358,
#   time_query_total: 0.0013,
#   time_query_min: 0.000002,
#   time_query_max: 0.000006,
#   time_query_avg: 0.00000325,
#   num_queries: 4,
#   user_id: admin.id,
#   problem_id: the_lasy_parents.id,
#   environment_id: family_tree.id)
#     total queries:12
#    shortest query:100.0 μs
#     longest query:2.600 ms
#     average query:558.3 μs
#  total query time:6.700 ms
#   time to execute:82.42 ms
# non-ws char count:205
#           correct:true

# SolvedProblem.create(
#   solution: raw_technically_3_years,
#   sol_char_count: 479,
#   time_exec_total: 0.2358,
#   time_query_total: 0.0013,
#   time_query_min: 0.000002,
#   time_query_max: 0.000006,
#   time_query_avg: 0.00000325,
#   num_queries: 4,
#   user_id: admin.id,
#   problem_id: the_technically_3_years.id,
#   environment_id: old_mac.id)
#     total queries:1
#    shortest query:20.60 ms
#     longest query:20.60 ms
#     average query:20.60 ms
#  total query time:20.60 ms
#   time to execute:26.22 ms
# non-ws char count:316
#           correct:true

# SolvedProblem.create(
#   solution: raw_technically_3_years,
#   sol_char_count: 479,
#   time_exec_total: 0.2358,
#   time_query_total: 0.0013,
#   time_query_min: 0.000002,
#   time_query_max: 0.000006,
#   time_query_avg: 0.00000325,
#   num_queries: 4,
#   user_id: admin.id,
#   problem_id: the_technically_3_years.id,
#   environment_id: old_mac.id)
#     total queries:1
#    shortest query:20.60 ms
#     longest query:20.60 ms
#     average query:20.60 ms
#  total query time:20.60 ms
#   time to execute:26.22 ms
# non-ws char count:316
#           correct:true

# SolvedProblem.create(
#   solution: raw_smitty_w,
#   sol_char_count: 479,
#   time_exec_total: 0.2358,
#   time_query_total: 0.0013,
#   time_query_min: 0.000002,
#   time_query_max: 0.000006,
#   time_query_avg: 0.00000325,
#   num_queries: 4,
#   user_id: admin.id,
#   problem_id: smitty_w.id,
#   environment_id: old_mac.id)
#     total queries:3
#    shortest query:18.60 ms
#     longest query:57.40 ms
#     average query:39.07 ms
#  total query time:117.2 ms
#   time to execute:488.5 ms
# non-ws char count:655
#           correct:true

# SolvedProblem.create(
#   solution: raw_the_red_line,
#   sol_char_count: 479,
#   time_exec_total: 0.2358,
#   time_query_total: 0.0013,
#   time_query_min: 0.000002,
#   time_query_max: 0.000006,
#   time_query_avg: 0.00000325,
#   num_queries: 4,
#   user_id: admin.id,
#   problem_id: the_red_line.id,
#   environment_id: old_mac.id)
#     total queries:3
#    shortest query:18.60 ms
#     longest query:57.40 ms
#     average query:39.07 ms
#  total query time:117.2 ms
#   time to execute:488.5 ms
# non-ws char count:655
#           correct:true
