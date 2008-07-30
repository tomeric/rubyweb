class Item < ActiveRecord::Base
  belongs_to :user
  has_many   :comments
  
  attr_protected :user_id
  
  validates_length_of :title,
                      :within => 4..255

  validates_length_of :content,
                      :within => 25..1200
end
