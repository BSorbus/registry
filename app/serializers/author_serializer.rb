class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :user_name, :wso2is_userid
end
