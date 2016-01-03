class Thing < ActiveRecord::Base
  has_many :comments
  has_many :authorships
  has_many :users, through: :authorships

  scope :latest, -> { all.limit(9).order("id DESC") }

  serialize :image_meta_data
end
