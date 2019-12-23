class UserSerializer < ActiveModel::Serializer
  # embed :ids
  # embed :ids, include: true
  
  attributes :id, :email, :created_at, :updated_at, :auth_token, :product_ids
  
  def product_ids
    object.products.pluck(:id)
  end
  
  # has_many :products
end
