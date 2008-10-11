class Item < ActiveRecord::Base
  belongs_to :user
  has_many   :comments
  
  attr_protected :user_id
  
  before_validation :set_default_title
  
  validates_length_of :title,
                      :within => 4..255

  validates_length_of :content,
                      :within => 25..1200
  
  validate :validate_anonymous,
           :if => :anonymous?
  
  def anonymous?
    !self.user
  end

  def anonymous!
    self.content.gsub!(/((<a\s+.*?href.+?\".*?\")([^\>]*?)>)/, '\2 rel="nofollow" \3>')
    self.byline = "Anonieme Bangerd" if self.byline.empty?  
  end
  
  def is_editable_by(user)
    return false unless user == self.user
    return self.updated_at > 15.minutes.ago
  end
  
  protected
  
  def set_default_title
    if self.title.to_s.blank? && self.content
      self.title = self.content.to_s.gsub(/\<[^\>]+\>/, '')[0...40] + "..."
    end
  end
  
  def validate_anonymous
    if self.byline && self.byline.to_s.length > 18
      self.errors.add(:byline, 'Is te lang (max is 18 karakters)')
    end
  end
end
