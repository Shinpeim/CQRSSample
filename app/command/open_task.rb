require 'command'
class Command
  class OpenTask < Command
    attr_reader :opener_uuid, :description, :assignee_uuid

    # コマンドでは入力値が妥当であるか、という観点でvalidationを行う
    validates_presence_of :description
    validates_presence_of :opener_uuid

    def initialize(opener_uuid, description, assignee_uuid)
      @opener_uuid = opener_uuid
      @description = description
      @assignee_uuid = assignee_uuid
    end
  end
end
