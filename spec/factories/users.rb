FactoryBot.define do
  factory :user do
    username    { Faker::Internet.unique.username }
    given_name  { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
    email       { Faker::Internet.unique.email }
    password do
      Faker::Internet.password(
        min_length:         14,
        max_length:         128,
        mix_case:           true,
        special_characters: true
      )
    end
    terms_and_conditions { Faker::Time.backward }
  end
end
