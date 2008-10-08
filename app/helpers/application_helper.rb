# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def form_error(object, field)
    object = object.object if object.respond_to?(:object)
    
    if object.errors[field]
      error = object.errors[field]
      error = error.join(', ') if error.is_a?(Array)
      
      "<dd class=\"error-message\">#{error}</dd>"
    end
  end

  def editable?(item)
    admin? || item.is_editable_by(current_user)
  end
  
  def random_word
    words      = %w{renegade nevergonna giveyouup letyoudown runaround starla luckystiff inside an at ax al pol paypal nidd nid pin pit pragmatic astley twogirls onecup felch kwyjibo covenham kenwick grimsby warlingham cooper macbook triumph air mascot football hockey tennis shadow bullet metaphor flyer twitter yahoo google coding ruby masterplan spyhole porthole boat float granite trousers dragon tiger}    
    post_words = %w{in ox et by rat tar al s ty ax ak an at de er ers}
    
    words[rand(words.size)] + post_words[rand(post_words.size)]
  end
  
  def captcha(word)
    str = String.new
    
    word.each_byte do |char|
      str << char.chr.upcase
      str << "<del>#{(rand(26) + 97).chr.upcase}</del>" if rand(2) == 1
    end
    
    str
  end
  
  def title
    if @title
      @title + " : " + APP_CONFIG[:app_title]
    else
      APP_CONFIG[:default_title]
    end
  end
  
  def safe(txt)
    # Poor mans' sanitization!
    
    txt = "<p>#{h(txt)}</p>"
    txt.gsub!(/\&quot;/, '"')
    txt.gsub!(/\&gt;/, '>')
    
    txt.gsub!(/\n[\r\n]+/, "\n")
    txt.gsub!(/\n/, '</p><p>')
    
    txt.gsub!(/\&lt;a href/, '<a href')
    txt.gsub!(/\&lt;\/a>/, '</a>')

    txt.gsub!(/\&lt;\/blockquote>/, '</blockquote>')
    txt.gsub!(/\&lt;\/code>/, '</code>')
    txt.gsub!(/\&lt;\/b>/, '</b>')
    txt.gsub!(/\&lt;\/strong>/, '</strong>')
    txt.gsub!(/\&lt;\/i>/, '</i>')
    txt.gsub!(/\&lt;\/em>/, '</em>')

    txt.gsub!(/\&lt;blockquote>/, '<blockquote>')
    txt.gsub!(/\&lt;code>/, '<code>')
    txt.gsub!(/\&lt;b>/, '<b>')
    txt.gsub!(/\&lt;strong>/, '<strong>')
    txt.gsub!(/\&lt;i>/, '<i>')
    txt.gsub!(/\&lt;em>/, '<em>')

    txt
  end
end
