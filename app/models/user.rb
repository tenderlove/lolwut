require 'tusk/observable/drb'

class User < ActiveRecord::Base
  # Use DRb as our transport
  extend Tusk::Observable::DRb

  # After users are created, notify the message bus
  after_create :notify_observers

  # Use the table name as the bus channel
  def self.channel
    table_name
  end

  private

  def notify_observers
    self.class.changed
    self.class.notify_observers self.class.channel
  end
end
