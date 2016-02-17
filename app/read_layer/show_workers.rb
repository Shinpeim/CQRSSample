require 'table/workers'

module ReadLayer
  class ShowWorkers
    USERS_PER_PAGE = 10

    def self.list(page)
      offset = (page - 1) * USERS_PER_PAGE
      Table::Workers.offset(offset).limit(USERS_PER_PAGE).to_a
    end
  end
end
