require 'rails_helper'

describe Phone do
  it "does not allow duplicate phone number per contact" do
    #contact = Contact.create(firstname: "abcd", lastname: "efgh", email: "a@b.com")
    #contact.phones.create(phone_type: 'home', phone: '123-456-7890')
    #mobile_phone = contact.phones.build(phone_type: 'mobile', phone: '123-456-7890')
    
    contact = create(:contact)
    create(:home_phone, contact: contact, phone: '123-456-7890')
    mobile_phone = build(:mobile_phone, contact: contact, phone: '123-456-7890')
    mobile_phone.valid?
    expect(mobile_phone.errors[:phone]).to include('has already been taken')
  end
  
  it "allows two contacts to share a phone number" do
    # contact = Contact.create(firstname: "abcd", lastname: "efgh", email: "a@b.com")
    # contact.phones.create(phone_type: 'home', phone: '123-456-7890')
    #other_contact = Contact.new
    #other_phone = other_contact.phones.build(phone_type: 'home', phone: '123-456-7890')
    #expect(other_phone).to be_valid
    
    create(:home_phone, phone: '123-456-7890')
    home_phone = build(:home_phone, phone: '123-456-7890')
    expect(home_phone).to be_valid
  end
end