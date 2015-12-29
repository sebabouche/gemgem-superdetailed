class Thing < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :users

  scope :latest, -> { all.limit(9).order("id DESC") }
end
