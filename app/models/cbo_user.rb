class CboUser < ApplicationRecord

  # relations
  belongs_to :user, optional: true

end
