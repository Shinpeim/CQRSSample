require 'domain'
require 'domain/error'

# EntityObjectやValueObjectは「Always Valid」であるように保つ
class Worker # Entity Object
  attr_reader :uuid, :name, :role

  def initialize(uuid, name, role_symbol)
    @uuid = uuid
    @name = name
    @role = Role.new(role_symbol)
  end
end

class Role # Value Object
  POSIBLE_ROLES = [:developer, :manager]

  attr_reader :symbol

  def initialize(symbol)
    raise Domain::Error, "invalid role" unless POSIBLE_ROLES.include?(symbol)
    @symbol = symbol
  end

  def developer?
    @symbol == :developer
  end

  def manager?
    @symbol == :manager
  end
end
