class Item < ActiveRecord::Base
  belongs_to :user
  has_many   :comments
  
  # prevents a user from submitting a crafted form that adds the item
  # as another user.
  attr_protected :user_id
  
  acts_as_sluggable :title

  before_validation :set_default_title,
                    :unless => :title?

  validates_presence_of :title, :content

  validates_length_of   :title,
                        :within => 4..255,
                        :if => :title?

  validates_format_of   :slug,
                        :with => /^[a-zA-Z0-9\-\_]+$/,
                        :if   => :slug?

  validates_length_of   :content,
                        :within => 25..1200,
                        :if     => :content?
  
  # validations that occur when the item is made anonymously:
  with_options :if => :anonymous? do |item|
    item.validates_presence_of :byline
  
    item.validates_length_of   :byline,
                               :maximum => 18,
                               :message => 'Is te lang (maximum is 18 karakters)'
  end

  def anonymous?
    !self.user
  end

  def anonymous!
    self.user = nil
    self.content.gsub!(/((<a\s+.*?href.+?\".*?\")([^\>]*?)>)/, '\2 rel="nofollow" \3>')
    self.byline = "Anonieme Bangerd" if self.byline.to_s.blank?
  end
  
  def is_editable_by?(user)
    return false unless user == self.user
    return self.updated_at > 15.minutes.ago
  end
  
  protected
  
  def set_default_title
    self.title = self.content.to_s.gsub(/\<[^\>]+\>/, '')[0...40] + "..."
  end
end