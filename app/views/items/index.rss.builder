xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") {
  xml.channel {
    xml.title(APP_CONFIG[:app_title])
    xml.link(APP_CONFIG[:app_url])
    xml.description(APP_CONFIG[:sub_title])
    xml.language('nl')

    @items.each do |item|
      next unless item.user and item.user.approved_for_feed

      xml.item do
        xml.title(item.title)
        xml.description(item.content)
        xml.pubDate(item.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(item_url(item))
        xml.guid(item_url(item))
      end
    end
  }
}
