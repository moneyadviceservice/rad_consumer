module Results
  module Pagination
    PAGE_SIZE = 10

    def total_records
      raise NotImplementedError
    end

    def current_page
      raise NotImplementedError
    end

    def total_pages
      return 1 if total_records < page_size
      return (total_records / page_size) if multiple_of_page_size?

      total_records / page_size + 1
    end

    def first_record
      return 1 if current_page == 1

      ((current_page - 1) * page_size) + 1
    end

    def last_record
      last = current_page * page_size

      last > total_records ? total_records : last
    end

    def page_size
      PAGE_SIZE
    end

    def multiple_of_page_size?
      (total_records % page_size).zero?
    end

    alias limit_value page_size
  end
end
