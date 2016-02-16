require 'domain'
require 'domain/error'

# EntityObjectやValueObjectは「Always Valid」であるように保つ
class Worker # Entity Object
  def initialize(id, name, role_symbol)
    @id = id
    @name = name
    @role = Role.new(role_symbol)
  end
end

class Role # Value Object
  POSIBLE_ROLES = [:developer, :manager]

  def initialize(symbol)
    p symbol
    raise Domain::Error, "invalid role" unless POSIBLE_ROLES.include?(symbol)
    @role = symbol
  end

  def developer?
    @symbol == :developer
  end

  def manager?
    @symbol == :maneger
  end
end
