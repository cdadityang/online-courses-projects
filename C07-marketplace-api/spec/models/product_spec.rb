require 'rails_helper'

RSpec.describe Product, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  let(:product) { FactoryGirl.build :product }
  subject { product }
  
  it "should respond to title" do
    expect(product).to respond_to(:title)
  end
  
  it "should respond to price" do
    expect(product).to respond_to(:price)
  end
  
  it "should respond to published" do
    expect(product).to respond_to(:published)
  end
  
  it "should respond to user_id" do
    expect(product).to respond_to(:user_id)
  end
  
  it "is invalid without a title" do
    product.title = nil
    expect(product).to_not be_valid
  end
  
  it "is invalid without a user_id" do
    product.user_id = nil
    expect(product).to_not be_valid
  end
  
  it "is invalid without a price" do
    product.price = nil
    expect(product).to_not be_valid
  end
  
  it "is invalid without price < 0" do
    product.price = -1
    expect(product).to_not be_valid
  end
  
  it "belongs to user" do
    expect(product).to respond_to :user
  end
  
  describe ".filter_by_title" do
     before(:each) do
      @product1 = FactoryGirl.create :product, title: "A plasma TV"
      @product2 = FactoryGirl.create :product, title: "Fastest Laptop"
      @product3 = FactoryGirl.create :product, title: "CD player"
      @product4 = FactoryGirl.create :product, title: "LCD TV"
    end
    
    context "when a 'TV' title pattern is sent" do
      it "returns 2 products matching" do
        expect(Product.filter_by_title("TV").length).to eq 2
      end
      it "returns the products matching array" do
        expect(Product.filter_by_title("TV").sort).to match_array([@product1, @product4])
      end
    end
  end
  
  describe ".above_or_equal_to_price" do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
    end
    it "returns the products which are above or equal to the price 100" do
      expect(Product.above_or_equal_to_price(100).sort).to match_array([@product1, @product3])
    end
  end
  
  describe ".below_or_equal_to_price" do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
    end
    it "returns the products which are below or equal to the price 99" do
      expect(Product.below_or_equal_to_price(99).sort).to match_array([@product2, @product4])
    end
  end
  
  describe ".recent" do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
      
      #we will touch some products to update them
      @product2.touch
      @product3.touch
    end
    
    it "returns the most updated records" do
      expect(Product.recent).to match_array([@product3, @product2, @product4, @product1])
    end
  end
  
  describe ".search" do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100, title: "Plasma tv"
      @product2 = FactoryGirl.create :product, price: 50, title: "Videogame console"
      @product3 = FactoryGirl.create :product, price: 150, title: "MP3"
      @product4 = FactoryGirl.create :product, price: 99, title: "Laptop"
    end

    context "when title 'videogame' and '100' a min price are set" do
      it "returns an empty array" do
        search_hash = { keyword: "videogame", min_price: 100 }
        expect(Product.search(search_hash)).to be_empty
      end
    end

    context "when title 'tv', '150' as max price, and '50' as min price are set" do
      it "returns the product1" do
        search_hash = { keyword: "tv", min_price: 50, max_price: 150 }
        expect(Product.search(search_hash)).to match_array([@product1]) 
      end
    end

    context "when an empty hash is sent" do
      it "returns all the products" do
        expect(Product.search({})).to match_array([@product1, @product2, @product3, @product4])
      end
    end

    context "when product_ids is present" do
      it "returns the product from the ids" do
        search_hash = { product_ids: [@product1.id, @product2.id]}
        expect(Product.search(search_hash)).to match_array([@product1, @product2])
      end
    end
  end
  
  describe "#placements association" do
    before do
      @user = FactoryGirl.create :user
      @product1 = FactoryGirl.create :product, user: @user
      @order1 = FactoryGirl.create :order, user: @user
      3.times { FactoryGirl.create :placement, order: @order1, product: @product1 }
    end
    
    it "should have many placements validation" do
      expect(@product1.placements.count).to eq(3)
    end
  end
  
  describe "#orders through placements association" do
    before do
      @user = FactoryGirl.create :user
      @product1 = FactoryGirl.create :product, user: @user
      
      @order1 = FactoryGirl.create :order, user: @user
      @order2 = FactoryGirl.create :order, user: @user
      @order3 = FactoryGirl.create :order, user: @user
    end
    
    it "should have many orders through placements" do
      @placement = FactoryGirl.create :placement, order: @order1, product: @product1
      @placement2 = FactoryGirl.create :placement, order: @order1, product: @product1
      @placement3 = FactoryGirl.create :placement, order: @order2, product: @product1
      @placement4 = FactoryGirl.create :placement, order: @order3, product: @product1
      expect(@product1.orders.count).to eq 4
    end
  end
end
