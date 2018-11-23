module FriendlyNamable
  extend ActiveSupport::Concern

  included do
    def friendly_name
      I18n.t("#{model_name.i18n_key}.ordinal.#{order}")
    end
  end

  class_methods do
    def friendly_name(id)
      order = find(id).order
      I18n.t("#{model_name.i18n_key}.ordinal.#{order}")
    end
  end
end
