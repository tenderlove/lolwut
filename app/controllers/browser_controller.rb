require 'rb-fsevent'

class BrowserController < ApplicationController
  include ActionController::Live

  class SSE
    def initialize io
      @io = io
    end

    def write obj, options = {}
      options.each do |pair|
        @io.write(pair.join(': ') + "\n")
      end
      @io.write "data: #{JSON.dump(obj)}\n\n"
    end
  end

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new response.stream

    # Watch the filesystem for changes
    fsevent = FSEvent.new
    fsevent.watch(File.join(Rails.root, 'app', 'views')) { |dir|

      # When something changes, send an SSE
      sse.write({ 'changed' => dir }, :event => 'reload')
    }
    fsevent.run
  end
end
