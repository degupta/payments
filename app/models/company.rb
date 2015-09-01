class Company < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates_length_of :name, :minimum => 5, :maximum => 100
end
