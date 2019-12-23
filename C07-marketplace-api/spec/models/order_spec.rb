require 'rails_helper'

RSpec.describe Order, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  let(:order) { FactoryGirl.build :order }
  subject { order }
  
  it "should respond to :total" do
    expect(order).to respond_to(:total)
  end
  
  it "should respond to :user_id" do
    expect(order).to respond_to(:user_id)
  end
  
  it "validates presence of :user_id" do
    order.user_id = nil
    expect(order).to_not be_valid
  end
  
  it "validates presence of :total" do
    order.total = nil
    expect(order).to be_valid
  end
  
  it "validates :total numericaly >= 0" do
    order.total = -1
    expect(order).to be_valid
  end
  
  it "belongs to user" do
    expect(order).to respond_to :user
  end
  
  describe "#placements association" do
    before do
      @product = FactoryGirl.create :product
      @user = FactoryGirl.create :user
      @order1 = FactoryGirl.create :order, user: @user
      3.times { FactoryGirl.create :placement, order: @order1, product: @product }
    end
    
    it "should have many placements validation" do
      expect(@order1.placements.count).to eq(3)
    end
  end
  
  describe "#products through placements association" do
    before do
      @user = FactoryGirl.create :user
      @order1 = FactoryGirl.create :order, user: @user
      @product = FactoryGirl.create :product, user: @user
      @product2 = FactoryGirl.create :product, user: @user
      @product3 = FactoryGirl.create :product, user: @user
    end
    
    it "should have many products through placements" do
      @placement = FactoryGirl.create :placement, order: @order1, product: @product
      @placement2 = FactoryGirl.create :placement, order: @order1, product: @product
      @placement3 = FactoryGirl.create :placement, order: @order1, product: @product2
      @placement4 = FactoryGirl.create :placement, order: @order1, product: @product3
      expect(@order1.products.count).to eq 4
    end
  end
  
  describe '#set_total!' do
    before(:each) do
      product_1 = FactoryGirl.create :product, price: 100
      product_2 = FactoryGirl.create :product, price: 85
  
      # @order = FactoryGirl.build :order, product_ids: [product_1.id, product_2.id]
      
      # new lines start
      placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 3
      placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 15

      @order = FactoryGirl.build :order

      @order.placements << placement_1
      @order.placements << placement_2
      # new lines end
    end
  
    it "returns the total amount to pay for the products" do
      expect{@order.set_total!}.to change{@order.total.to_f}.from(0).to(1575)
    end
  end
  
  describe "#build_placements_with_product_ids_and_quantities" do
    before(:each) do
      product_1 = FactoryGirl.create :product, price: 100, quantity: 5
      product_2 = FactoryGirl.create :product, price: 85, quantity: 10
      
      @product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]
    end
    
    it "builds 2 placements for the order" do
      expect{order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities)}.to change{order.placements.size}.from(0).to(2)
    end
  end
  
  describe "#valid?" do
    before do
      product_1 = FactoryGirl.create :product, price: 100, quantity: 5
      product_2 = FactoryGirl.create :product, price: 85, quantity: 10

      placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 3
      placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 15
      @order = FactoryGirl.build :order

      @order.placements << placement_1
      @order.placements << placement_2
    end
    
    it "becomes invalid due to insufficient products" do
      expect(@order).to_not be_valid
    end
  end
end
