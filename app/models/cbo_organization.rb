class CboOrganization < ApplicationRecord

  # relations
  belongs_to :organization, optional: true
 
end
