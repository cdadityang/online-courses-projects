require 'rails_helper'

describe Contact do
  
  it "is a valid factory" do
    expect(build(:contact)).to be_valid
  end
  
  it "is valid with a firstname, lastname and email" do
    contact = build(:contact)
    expect(contact).to be_valid
  end
  
  it "is invalid without a firstname" do
    contact = build(:contact, firstname: nil)
    contact.valid? # when we run this, we'll know errors are there or not
    expect(contact.errors[:firstname]).to include("can't be blank")
  end
  
  it "is invalid without a lastname" do
    contact = build(:contact, lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end
  
  it "is invalid without an email address" do
    contact = build(:contact, email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include("can't be blank")
  end
  
  it "is invalid with a duplicate email address" do
    # Contact.create(firstname: "abcd", lastname: "efgh", email: "a@b.com")
    create(:contact, email: "a@b.com")
    contact = build(:contact, email: "a@b.com")
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end
  
  it "returns a contact's full name as a string" do
    contact = build(:contact, firstname: "ijkl", lastname: "mnop")
    expect(contact.name).to eq('ijkl mnop')
  end
  
  it "has three phone numbers" do
    contact = create(:contact)
    expect(contact.phones.count).to eq(3)
  end
  
  describe "filter last name by letter" do
    before :each do
      @smith = create(:contact, firstname: "John", lastname: "Smith", email: "jh@s.com")
      @jones = create(:contact, firstname: "Tim", lastname: "Jones", email: "t@j.com")
      @johnson = create(:contact, firstname: "Jimmy", lastname: "Johnson", email: "j@j.com")
    end
    
    context "with matching letters" do
      it "returns a sorted array of results that match" do
        expect(Contact.by_letter("J")).to eq([@johnson, @jones])
      end
    end
    
    context "with non-matching letters" do
      it "omits results that do not match" do
        expect(Contact.by_letter("J")).not_to include(@smith)
      end
    end
  end
end