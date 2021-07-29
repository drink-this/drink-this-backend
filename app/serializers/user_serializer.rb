class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :uid, :name, :email

end
