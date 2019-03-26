class UserSerializer < ActiveModel::Serializer
  attributes :id, :provider, :uid, :email
end
