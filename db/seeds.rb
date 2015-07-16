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

  g0.spouse_id = g0_spouse.id
  g0_spouse.spouse_id = g0.id
  g0.save
  g0_spouse.save


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
            father_id: father.id)
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

    father.spouse_id = mother.id
    mother.spouse_id = father.id
    father.save
    mother.save

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
    gx.spouse_id = gx_spouse.id
    gx_spouse.spouse_id = gx.id
    gx.save
    gx_spouse.save


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
                 father_id: father.id)
      end
    end
  end
end

env_descrip =
"""
This problem set involves the ActiveRecord models |BabyName| and |Person|.

The corresponding database table |baby_names| is seeded with data recorded from
1880 to 2014 on baby names with over 5 occurences (http://www.ssa.gov/oact/babynames/limits.html).

The second table |people| is seeded with several interwoven families
spanning up to 5 generations of |Person|s born between 1880 and 2014.

All of the problems in this set can be solved by querying just the |people| table.
"""
baby_names_and_people = Environment.create(
  title: "people and baby_names",
  description: env_descrip[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
  models: { "Person"=>"person.rb", "BabyName"=>"baby_name.rb" }.to_json)

prob_instruct =
"""
|Person|s of the |people| table may have 0 or more |children| as per the ActiveRecord |has_many|
association. Assuming your typical American household houses 1.5 |children|, and our database
refrains from tracking pregnancies and the heights of its tenants, let us define a typical household
of |people| as one having either 1 |or| 2 children.

Complete the |solution| method so that it returns an array of ActiveRecord |Person| objects
representing the |mother| and |father| of a typical household, |order|ed alphabetically by |name|.
"""
def answer_avg_household
  Person.where(:children_count=> [1, 2]).order(:name)
end
avg_household = baby_names_and_people.problems.create(
  title: "...and here are our 1.5 kids",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
  answer: answer_avg_household.to_json)

prob_instruct =
"""
~Here's the story, of a lovely lady...~

Hidden within the |people| table is a |mother|, a |father|, and 6 |children|
having |name|s of the Brady Bunch and |yob|s corresponding to the years of birth
of the actors who played their roles.

Complete the |solution| method so that it returns an array of ActiveRecord |Person| objects
representing the Brady Bunch that is |order|ed from youngest to oldest.
"""
def answer_brady_bunch
  mike_brady = Person.find_by({name: "Mike", children_count: 6})
  carol_brady = mike_brady.spouse
  brady_bunch = mike_brady.children.order(yob: :desc).map{ |brady_child|  brady_child }
  if mike_brady.yob > carol_brady.yob
    brady_bunch << mike_brady << carol_brady
  else
    brady_bunch << carol_brady << mike_brady
  end
  brady_bunch
end
the_brady_bunch = baby_names_and_people.problems.create(
  title: "The Brady Bunch",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
  answer: answer_brady_bunch.to_json)

prob_instruct =
"""
Within the |people| family tree, all |Person|s were able to find a non-sibling |spouse|
of the opposite gender who was also born in their |generation|. In other words, all within
a generation were married off two by two until a lonely pool of |\"M\"|s or |\"F\"|s remained. All,
that is, except for one lucky individual.

Complete the |solution| method so that it returns the ActiveRecord |Person| object representing the Bachelor(ette).
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
end
the_bachelor = baby_names_and_people.problems.create(
  title: "The Bachelor(ette?)",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
  answer: answer_bachelor.to_json)

prob_instruct =
"""
Every |Person| was |name|d by their |mother| and |father| corresponding to a |BabyName| of the same |yob|.
Accordingly, for every |Person|, person_example, born in the year person_example.yob, there were

|BabyName.find_by({ name: person_example.name, gender: person_example.gender, yob: person_example.yob}).frequency - 1|

other |Person|s born in the States that year sharing the same name. To save you some time and to
spare our servers the cost of querying a 1825433-entry table thousands of times, the |frequency| of a |Person|s
name for their |gender| and |yob| has been cached as:

|Person.frequency|

when |people| was seeded. The Laziest Parents Award will go to the
|mother| and |father| of the |Person| born with the most common name for every generation.

Complete the |solution| method so that it returns a 4 element array composed of 2 element arrays of ActiveRecord |Person| objects
representing the laziest parents of each generation, |order|ed by generation in the following format:

[ [gen0_lazy_mother, gen0_lazy_father], ..., ..., [gen3_lazy_mother, gen3_lazy_father] ]
"""
lazy_parents_award = baby_names_and_people.problems.create(
  title: "The Laziest Parents Award",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"))



admin = User.create(name: "admin", password: "admin", password_confirmation: "admin", admin: true)



raw_avg_household =
"""
def solution
  Person.where(:children_count=> [1, 2]).order(:name)
end

solution
"""
raw_avg_household = raw_avg_household[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n")

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
end

solution
"""
raw_bachelor = raw_bachelor[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n")

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
raw_brady_bunch = raw_brady_bunch[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n")

SolvedProblem.create(
  solution: raw_bachelor,
  sol_char_count: 479,
  time_exec_total: 0.2358,
  time_query_total: 0.0013,
  time_query_min: 0.000002,
  time_query_max: 0.000006,
  time_query_avg: 0.00000325,
  num_queries: 4,
  user_id: admin.id,
  problem_id: the_bachelor.id,
  environment_id: baby_names_and_people.id)





