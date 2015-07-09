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
    dad = { name: "Mike", gender: "M", yob: 1932, generation: 2 }
    mom = { name: "Carol", gender: "F", yob: 1934, generation: 2 }
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













