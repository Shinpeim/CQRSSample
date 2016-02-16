require 'command'

class Command
  class CreateWorker < Command
    attr_reader :name, :role

    ROLE_MAPPING = { 1 => :developer, 2 => :manager }

    # コマンドでは入力値が妥当であるか、という観点でvalidationを行う
    validates_presence_of :name
    validates_length_of :name, maximum: 30

    validates_presence_of :role
    validates_inclusion_of :role, in: ROLE_MAPPING.keys

    def initialize(name, role)
      @name = name
      @role = role
    end

    def role_as_symbol
      ROLE_MAPPING[@role]
    end
  end
end
