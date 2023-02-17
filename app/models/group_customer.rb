class GroupCustomer < ApplicationRecord
  belongs_to :group
  belongs_to :customer
end
