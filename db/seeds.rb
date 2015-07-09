g0_yobs = (1880..1890).to_a
genders = ["M", "F"]
genders.reject { |gender| gender == "M" }

5.times do |i|
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

  rand(6).times do
    g1_gender = genders.sample
    g1_yob = (g0_yob + g0_spouse_yob) / 2 + rand(20..30)
    g1_name = BabyName.where("yob = #{g1_yob} AND gender = '#{g1_gender}'").pluck(:name).sample
    mother.children.create(name: g1_name,
                         gender: g1_gender,
                            yob: g1_yob,
                      mother_id: mother.id,
                      father_id: father.id)
    father.children.create(name: g1_name,
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
  gx_bachelors = Person.where(spouse_id: nil).where(gender: "M").where("yob >= #{gx_cutoff_low} AND yob <= #{gx_cutoff_high}")
  gx_bachelorettes = Person.where(spouse_id: nil).where(gender: "F").where("yob >= #{gx_cutoff_low} AND yob <= #{gx_cutoff_high}")

  smaller_pool, larger_pool = gx_bachelors.count > gx_bachelorettes.count ? [gx_bachelorettes, gx_bachelors] : [gx_bachelors, gx_bachelorettes]
  to_be_married = smaller_pool

  to_be_married.each do |gx|
    gx_spouse = larger_pool.sample
    gx_spouse = larger_pool.sample until gx_spouse.spouse_id.nil?

    gx.spouse_id = gx_spouse.id
    gx_spouse.spouse_id = gx.id
    gx.save
    gx_spouse.save

    mother, father = gx.gender == "M" ? [gx_spouse, gx] : [gx, gx_spouse]

    rand(6).times do
      gy_gender = genders.sample
      gy_yob = (mother.yob + father.yob) / 2 + rand(20..40)
      gy_name = BabyName.where("yob = #{gy_yob} AND gender = '#{gy_gender}'").pluck(:name).sample
      mother.children.create(name: gy_name,
                     gender: gy_gender,
                        yob: gy_yob,
                  mother_id: mother.id,
                  father_id: father.id)
      father.children.create(name: gy_name,
                           gender: gy_gender,
                              yob: gy_yob,
                        mother_id: mother.id,
                        father_id: father.id)
    end
  end

  gx_cutoff_low += 25
  gx_cutoff_high += 25
end













