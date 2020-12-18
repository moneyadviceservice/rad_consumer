module Filters
  module Language
    attr_accessor :languages

    def options_for_language
      languages = I18n.t('search.filter.languages.options').map do |iso6393|
        LanguageList::LanguageInfo.find(iso6393)
      end

      languages.sort_by(&:common_name)
    end
  end
end
