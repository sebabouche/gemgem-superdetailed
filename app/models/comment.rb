class Comment < ActiveRecord::Base
  belongs_to :thing
  belongs_to :user

  default_scope { order("updated_at DESC") }

end
