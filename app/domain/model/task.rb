require 'domain'
require 'domain/error'

class Task # Entity Object
  class PermissionError < Domain::Error; end

  class << self
    def open(opener, uuid, description, assignee)
      if opener.role.manager?
        status =
          if assignee.nil?
            :opened
          else
            :assigned
          end
        new(uuid, description, assignee.try(:uuid), status)
      else
        raise PermissionError, "only manager can open task"
      end
    end
  end

  attr_reader :uuid, :description, :assignee_uuid, :status

  def initialize(uuid, description, assignee_uuid, status)
    @uuid = uuid
    @description = description
    @assignee_uuid = assignee_uuid
    @status = Status.new(status)
  end
end

class Status # Value Object
  POSSIBLE_STATUS = [:opened, :assigned, :working, :reviewing, :closed]

  attr_reader :symbol

  def initialize(symbol)
    if ( ! POSSIBLE_STATUS.include?(symbol) )
      raise StandardError, "invalid status"
    end

    @symbol = symbol
  end
end
