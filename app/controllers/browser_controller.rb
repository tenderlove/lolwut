require 'rb-fsevent'
require 'tusk/observable/drb'

# Start the DRb server for notifications
Thread.new {
  Tusk::Observable::DRb::Server.start
}

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

    @sse = SSE.new response.stream

    heartbeat
    watch_tables

    # Watch the filesystem for changes
    fsevent = FSEvent.new
    paths   = ['views', 'assets'].map { |d| File.join(Rails.root, 'app', d) }
    fsevent.watch(paths) { |dir|
      # When something changes, send an SSE
      @sse.write({ 'changed' => dir }, :event => 'reload')
    }
    fsevent.run
  ensure
    @sse.close
  end

  private

  TableChannel = Struct.new(:channel) do
    include Tusk::Observable::DRb
  end

  # If any tables change, let's tell the browser to refresh
  def watch_tables
    channels = ActiveRecord::Base.connection.tables.map { |table|
      TableChannel.new table
    }
    channels.each { |c| c.add_observer self, :table_changed }
  end

  def table_changed table_name
    @sse.write({ 'changed' => table_name }, :event => 'reload')
  rescue IOError
  end

  # Periodically send a message to the client.  This makes sure the connection
  # is alive.  If the connection dies, an exception is raised, and the socket
  # gets closed.
  def heartbeat
    Thread.new do
      begin
        loop do
          @sse.write({ 'ping' => Time.now }, :event => 'ping')
          sleep 1
        end
      rescue IOError
      end
    end
  end
end
