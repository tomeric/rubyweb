Factory.define :item do |item|
  item.title { Factory.next :title }
  item.content 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
  item.user { Factory(:user) }
end