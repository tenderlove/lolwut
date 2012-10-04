require 'rb-fsevent'
Thread.abort_on_exception = true

class BrowserController < ApplicationController
  include ActionController::Live

  class SSE
    include Mutex_m

    def initialize io
      super()
      @io = io
    end

    def write obj, options = {}
      synchronize do
        options.each do |pair|
          @io.write(pair.join(': ') + "\n")
        end
        @io.write "data: #{JSON.dump(obj)}\n\n"
      end
    end

    def close
      @io.close
    end
  end

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new response.stream

    Thread.new do
      begin
        loop do
          sse.write({ 'ping' => Time.now }, :event => 'ping')
          sleep 1
        end
      rescue IOError
      end
    end

    # Watch the filesystem for changes
    fsevent = FSEvent.new
    paths   = ['views', 'assets'].map { |d| File.join(Rails.root, 'app', d) }
    fsevent.watch(paths) { |dir|
      # When something changes, send an SSE
      sse.write({ 'changed' => dir }, :event => 'reload')
    }
    fsevent.run
  ensure
    sse.close
  end
end
