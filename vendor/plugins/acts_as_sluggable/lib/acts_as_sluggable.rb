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
      before_save :set_slug, :if => :slug_column?
    end
  end

  module InstanceMethods     
    def slug
      if slug_column?
        read_attribute(:slug)
      else
        self.id.to_s + "_" + self.send(self.class.sluggable_attribute).to_slug
      end
    end

    def slug=(slug)
      write_attribute(:slug, slug) if slug_column?      
    end

    def to_param
      if self.slug
        self.slug
      else
        self.id
      end
    end

  private
    def slug_column?
      self.class.columns.any? { |c| c.name.to_s == 'slug' }
    end
          
    def set_slug
      slug = self.send(self.class.sluggable_attribute).to_slug
        
      existing = self.class.find_by_slug(slug)
      
      if existing && !(existing == self)
        untainted = slug.dup
        counter   = 2
        
        slug = "#{untainted}_#{counter}"        
        
        while (existing = self.class.find_by_slug(slug)) && !(existing == self)
          counter += 1
          slug = "#{untainted}_#{counter}"
        end        
      end
      
      self.slug = slug
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::ActsAsSluggable)
