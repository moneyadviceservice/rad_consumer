module Filters
  module Language
    attr_accessor :language

    def options_for_language
      languages = Firm.languages_used.map do |iso6393|
        LanguageList::LanguageInfo.find iso6393
      end

      languages.sort_by(&:common_name)
    end
  end
end
