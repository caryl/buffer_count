require File.dirname(__FILE__) + '/test_helper'

class BufferCountTest < Test::Unit::TestCase
  def setup
    @article = Article.create(:name => 'aa')
  end

  def test_cache
    15.times do
      @article.increment_buffer!
    end
    assert_equal @article.buffer_count_real, 15
    assert_equal @article.view_count||0, 0
    20.times do
      @article.increment_buffer!
    end
    assert_equal @article.buffer_count_real, 35
    assert_equal @article.view_count, 30
  end
end


class Article < ActiveRecord::Base
  include BufferCount
  has_buffer_count :column => :view_count, :delay => 30
end
