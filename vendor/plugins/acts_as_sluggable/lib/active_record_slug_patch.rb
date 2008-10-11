module ActiveRecord  
  class Base  
    def self.find_from_ids_with_coercion(ids, options)
      # this is probably very evil, but it makes Object.find('slug') work
      if columns.map(&:name).include? 'slug'  and 
         ids.length == 1 and ids.first.is_a?(String)
        unless ids.first.to_i > 0
	  find_by_slug(ids.first, options)
        else
          if result = find_by_slug(ids.first, options)
            result
          else
            find_by_id(ids.first.to_i, options)
          end
        end
      else
        if ids.first.is_a?(Array)
          ids.first.map!{|id| id.nil? ? id : id.to_i }      
        else
          ids.map!{|id| id.nil? ? id : id.to_i }
        end
        
        find_from_ids_without_coercion(ids, options)        
      end
    end
    
    class << self
      alias_method :find_from_ids_without_coercion, :find_from_ids
      alias_method :find_from_ids, :find_from_ids_with_coercion
    end
  end  
end