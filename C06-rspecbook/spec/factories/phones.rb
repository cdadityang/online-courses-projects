FactoryGirl.define do
  factory :phone do
    contact
    phone { Faker::PhoneNumber.phone_number }
    # phone_type 'home'
    
    factory :home_phone do
      phone_type 'home'
    end
    
    factory :work_phone do
      phone_type 'work'
    end
    
    factory :mobile_phone do
      phone_type 'mobile'
    end
  end
end