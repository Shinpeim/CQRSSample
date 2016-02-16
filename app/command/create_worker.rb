require 'command'
class Command
  class CreateWorker < Command
    attr_reader :name, :role

    # コマンドでは入力値が妥当であるか、という観点でvalidationを行う
    validates_presence_of :name
    validates_length_of :name, maximum: 30

    validates_presence_of :role
    validates_inclusion_of :role, in: ["developer", "manager"]

    validate :should_have_unique_name

    def initialize(name, role, repository)
      @name = name
      @role = role
      @repository = repository
    end

    def role_as_symbol
      @role.to_sym
    end

    private

    def should_have_unique_name
      errors.add(:name, :uniqueness) unless @repository.find_by_name(@name).nil?
    end
  end
end
