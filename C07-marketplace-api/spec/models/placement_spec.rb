require 'rails_helper'

RSpec.describe Placement, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  let(:placement) { FactoryGirl.build :placement }
  subject { placement }
  
  it "should respond to :order_id" do
    expect(placement).to respond_to(:order_id)
  end
  
  it "should respond to :product_id" do
    expect(placement).to respond_to(:product_id)
  end
  
  it "should respond to quantity" do
    expect(placement).to respond_to(:quantity)
  end
  
  it "belongs to order" do
    expect(placement).to respond_to :order
  end
  
  it "belongs to product" do
    expect(placement).to respond_to :product
  end
  
  describe "#decrement_product_quantity!" do
    it "decreases the product quantity by the placement quantity" do
      product = placement.product
      expect{placement.decrement_product_quantity!}.to change{product.quantity}.by(-placement.quantity)
    end
  end
end
