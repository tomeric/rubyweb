module ActiveRecord; module Acts; end; end

module ActiveRecord::Acts::ActsAsSluggable
  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    # create a 'sluggable_attribute' accessor on the model
    def self.extended(base)
      class << base
        self.instance_eval do
          attr_accessor :sluggable_attribute
        end
      end
    end

    def acts_as_sluggable(sluggable_attribute)
      self.sluggable_attribute = sluggable_attribute.to_s
      add_callbacks
        
      self.send(:include, InstanceMethods)
    end

  private      
    def add_callbacks
      before_save :set_slug
    end
  end

  module InstanceMethods     
    def slug
      return @slug unless @slug.nil?

      return super if has_sluggable_column? and !super.blank?
      self.slug = self.send(self.class.sluggable_attribute).to_slug
    end

    def slug=(slug)      
      super(slug) if has_sluggable_column?
      @slug = slug
    end

    def to_param
      if has_sluggable_column?
        self.slug
      else
        self.id
      end
    end

  private
    def has_sluggable_column?
      self.class.columns.map(&:name).include? 'slug'
    end
          
    def set_slug
      self.slug = self.send(self.class.sluggable_attribute).to_slug
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::ActsAsSluggable)
