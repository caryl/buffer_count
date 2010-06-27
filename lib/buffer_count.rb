module BufferCount
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # has_buffer_count :column => :view_count, :delay => 20
    def has_buffer_count(options = {})
      cattr_accessor :buffer_count_column, :buffer_count_delay,:buffer_count_cache_key
      self.buffer_count_column = options[:column] || :views_count
      self.buffer_count_delay = options[:delay] || 20
      self.buffer_count_cache_key = "buffer_count/#{self.to_s.tableize}/"
      include InstanceMethods
    end
  end

  module InstanceMethods
    def cached_buffer_count
      (Rails.cache.read("#{buffer_count_cache_key}#{self.id}") || 0).to_i
    end
    
    def increment_buffer!(step = 1)
      buffer_count = cached_buffer_count + step

      if buffer_count >= buffer_count_delay
        self.increment!(buffer_count_column, buffer_count)
        buffer_count = 0
  	  end
  	  Rails.cache.write("#{buffer_count_cache_key}#{self.id}",buffer_count)
    end

    def buffer_count_real
      (self.send(buffer_count_column) || 0) + cached_buffer_count
    end
  end
end

