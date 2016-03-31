module Filters
  module Language
    attr_accessor :language

    def options_for_language
      languages = Firm.languages_used.map do |iso_639_3|
        LanguageList::LanguageInfo.find iso_639_3
      end

      languages.sort_by(&:common_name)
    end
  end
end
