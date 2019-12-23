FactoryGirl.define do
  factory :contact do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    # sequence(:email) { |n| "johndoe#{n}@example.com" }
    email { Faker::Internet.email }
    hidden false
    
    after(:build) do |contact|
      [:home_phone, :work_phone, :mobile_phone].each do |phone|
        contact.phones << FactoryGirl.build(:phone, phone_type: phone, contact: contact)
      end
    end
    
    factory :invalid_contact do
      firstname nil
    end
    
  end
end