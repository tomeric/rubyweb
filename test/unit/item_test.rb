require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :user
  should_have_many :comments  
    
  should_ensure_length_in_range :title, (4..255)
  should_ensure_length_in_range :content, (25..1200)
  
  context 'An Item' do
    setup do
      @item = Factory(:item)
    end
    
    should_require_unique_attributes :slug
    
    should_allow_values_for :slug, 'name-1', 'name_1'
    should_not_allow_values_for :slug, 'name 1'
    
    should 'have a user' do
      assert_not_nil @item.user
    end
    
    should 'not be anonymous' do
      assert !@item.anonymous?
    end
    
    should 'be editable by it\s author within 15 minutes' do
      @item.update_attribute(:created_at, Time.now)
      assert @item.is_editable_by?(@item.user)
      
      @item.update_attribute(:created_at, 16.minutes.ago)
      assert !@item.is_editable_by?(@item.user)
    end
    
    should 'not be editable by other users' do
      @user = Factory(:user)
      
      @item.update_attribute(:created_at, Time.now)
      assert !@item.is_editable_by?(@item.user)
    end
  end
  
  context 'An anonymous item' do
    setup do
      @item = Factory(:item)
      @item.anonymous!
    end
    
    should 'not have a user' do
      assert_nil @item.user
    end
    
    should 'be anonymous' do
      assert @item.anonymous?
    end
    
    should 'have a byline' do
      assert_equal @item.byline, 'Anonieme Bangerd'
    end
    
    context 'with a predefined byline' do
      setup do
        @item = Factory(:item, :byline => 'John Doe')
        @item.anonymous!
      end
      
      should 'have the correct byline' do
        assert_equal @item.byline, 'John Doe'
      end
    end
  end
  
  context 'An item with a title' do
    setup do
      @item = Factory(:item, :title => 'Item Title')
    end
    
    should 'have a slug that is based on the title' do
      assert_equal @item.slug, 'item-title'
    end
  end
  
  context 'An item with a slug' do
    setup do
      @item = Factory(:item, :slug => 'the-slug')
    end    
    
    should 'be found with the slug' do
      assert_equal @item, Item.find(@item.slug)
    end
    
    should 'use slug for #to_param' do
      assert_equal @item.slug, @item.to_param
    end
  end
end