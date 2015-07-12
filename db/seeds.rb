g0_yobs = (1880..1890).to_a
genders = ["M", "F"]

30.times do
  g0_yob = g0_yobs.sample
  g0_gender = genders.sample
  g0_name = BabyName.where("yob = #{g0_yob} AND gender = '#{g0_gender}'").pluck(:name).sample

  g0_spouse_yob = g0_yobs.sample
  g0_spouse_gender = genders.reject { |gender| gender == g0_gender }.first
  g0_spouse_name = BabyName.where("yob = #{g0_spouse_yob} AND gender = '#{g0_spouse_gender}'").pluck(:name).sample

  g0 = Person.create(name: g0_name,
                   gender: g0_gender,
                      yob: g0_yob)
  g0_spouse = Person.create(name: g0_spouse_name,
                          gender: g0_spouse_gender,
                             yob: g0_spouse_yob)

  g0.spouse_id = g0_spouse.id
  g0_spouse.spouse_id = g0.id
  g0.save
  g0_spouse.save


  mother, father = g0.gender == "M" ? [g0_spouse, g0] : [g0, g0_spouse]

  rand(8).times do
    g1_gender = genders.sample
    g1_yob = (g0_yob + g0_spouse_yob) / 2 + rand(20..35)
    g1_name = BabyName.where("yob = #{g1_yob} AND gender = '#{g1_gender}'").pluck(:name).sample
    Person.create(name: g1_name,
               gender: g1_gender,
                  yob: g1_yob,
            mother_id: mother.id,
            father_id: father.id)
  end
end

unmarried_yobs = Person.where(spouse_id: nil).order(:yob).pluck(:yob)
gx_cutoff_low = unmarried_yobs.first
gx_cutoff_high = unmarried_yobs.last

3.times do |i|
  if i == 1
    dad_grandfather = Person.where.not(spouse_id: nil).where(generation: 1).where(gender: "M").first
    dad_grandmother = dad_grandfather.spouse
    mom_grandfather = Person.where.not(spouse_id: nil).where(generation: 1).where(gender: "M").last
    mom_grandmother = mom_grandfather.spouse

    dad = { name: "Mike", gender: "M", yob: 1932, mother_id: mom_grandmother.id, father_id: mom_grandfather.id }
    mom = { name: "Carol", gender: "F", yob: 1934, mother_id: mom_grandmother.id, father_id: mom_grandfather.id }
    father = Person.create(dad)
    mother = Person.create(mom)

    father.spouse_id = mother.id
    mother.spouse_id = father.id
    father.save
    mother.save

    kids = [{ name: "Greg", gender: "M", yob: 1954, mother_id: mother.id, father_id: father.id },
            { name: "Marcia", gender: "F", yob: 1956, mother_id: mother.id, father_id: father.id },
            { name: "Peter", gender: "M", yob: 1957, mother_id: mother.id, father_id: father.id },
            { name: "Jan", gender: "F", yob: 1958, mother_id: mother.id, father_id: father.id },
            { name: "Bobby", gender: "M", yob: 1960, mother_id: mother.id, father_id: father.id },
            { name: "Cindy", gender: "F", yob: 1961, mother_id: mother.id, father_id: father.id }]
    kids.each do |kid|
      child = Person.create(kid)
      child_spouse = Person.where(spouse_id: nil).where.not(gender: child.gender).first

      child.spouse_id = child_spouse.id
      child_spouse.spouse_id = child.id
      child.save
      child_spouse.save
    end
  end

  gx_bachelors_ettes = Person.where(spouse_id: nil).where("yob >= #{gx_cutoff_low} AND yob <= #{gx_cutoff_high}")

  if i == 2
    the_bachelor_ette_id = gx_bachelors_ettes.sample.id
    gx_bachelors_ettes = gx_bachelors_ettes.where.not(id: the_bachelor_ette_id)
  end


  next_gen_yobs = []

  gx_bachelors_ettes.each do |gx|
    valid_spouses = gx_bachelors_ettes.where(spouse_id: nil).where.not(mother_id: gx.mother_id).where.not(gender: gx.gender)
    gx_bachelors_ettes.count
    break if valid_spouses.count == 0
    gx_spouse = valid_spouses.take
    gx.spouse_id = gx_spouse.id
    gx_spouse.spouse_id = gx.id
    gx.save
    gx_spouse.save

    mother, father = gx.gender == "M" ? [gx_spouse, gx] : [gx, gx_spouse]
    rand(8).times do
      gy_gender = genders.sample
      gy_yob = (mother.yob + father.yob) / 2 + rand(20..35)
      gy_yob = gy_yob > 2014 ? 2014 : gy_yob
      gy_name = BabyName.where("yob = #{gy_yob} AND gender = '#{gy_gender}'").pluck(:name).sample
      Person.create(name: gy_name,
                 gender: gy_gender,
                    yob: gy_yob,
              mother_id: mother.id,
              father_id: father.id)
      next_gen_yobs << gy_yob
    end
  end

  next_gen_yobs.sort!
  gx_cutoff_low = next_gen_yobs.first
  gx_cutoff_high = next_gen_yobs.last
end



# rails g scaffold environment title:string description:text models:string
# rails g scaffold problem title:string instructions:text answer:text environment:belongs_to
# rails g scaffold user name:string password_digest:string admin:boolean problem_count:integer problem:belongs_to environment:belongs_to
# rails g scaffold solved_problem solution:text sol_char_count:integer time_exec_total:float time_query_total:float time_query_min:float time_query_max:float time_query_avg:float num_queries:integer user:belongs_to problem:belongs_to

# class CreateEnvironments < ActiveRecord::Migration
#   def change
#     create_table :environments do |t|
#       t.string :title
#       t.text :description
#       t.string :models
#       t.integer :problems_count, default: 0
#       t.integer :users_count, default: 0
#       t.integer :solved_problems_count, default: 0

#       t.timestamps null: false
#     end
#   end
# end


# class CreateProblems < ActiveRecord::Migration
#   def change
#     create_table :problems do |t|
#       t.string :title
#       t.text :instructions
#       t.text :answer
#       t.integer :solved_problems_count, default: 0
#       t.integer :users_count, default: 0
#       t.belongs_to :environment, index: true, foreign_key: true, counter_cache: true

#       t.timestamps null: false
#     end
#   end
# end

# class CreateUsers < ActiveRecord::Migration
#   def change
#     create_table :users do |t|
#       t.string :name
#       t.string :password_digest
#       t.boolean :admin, default: false
#       t.integer :problems_count, default: 0
#       t.integer :solved_problems_count, default: 0
#       t.integer :environments_count, default: 0
#       t.belongs_to :problem, index: true, foreign_key: true
#       t.belongs_to :environment, index: true, foreign_key: true

#       t.timestamps null: false
#     end
#   end
# end

# class CreateSolvedProblems < ActiveRecord::Migration
#   def change
#     create_table :solved_problems do |t|
#       t.text :solution
#       t.integer :sol_char_count
#       t.float :time_exec_total
#       t.float :time_query_total
#       t.float :time_query_min
#       t.float :time_query_max
#       t.float :time_query_avg
#       t.integer :num_queries
#       t.belongs_to :user, index: true, foreign_key: true, counter_cache: true
#       t.belongs_to :problem, index: true, foreign_key: true, counter_cache: true
#       t.belongs_to :environment, index: true, foreign_key: true

#       t.timestamps null: false
#     end
#   end
# end







