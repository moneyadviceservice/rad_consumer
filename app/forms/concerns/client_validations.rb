module ClientValidations
  extend ActiveSupport::Concern

  included do |base|
    base.extend(ClassMethods)
  end

  module ClassMethods
    @@validation_fields = {}

    def validation_attributes_for(field)
      @@validation_fields[field] || {}
    end

    def validation_attributes(field, opts)
      @@validation_fields[field] = default_validation_attributes(field).merge(opts)
    end

    def default_validation_attributes(field)
      I18n.t("activemodel.errors.models.#{model_name.param_key}.attributes.#{field}").map do |error|
        [error_type_to_dough_field(error[0]), error[1]]
      end.to_h
    end

    def error_type_to_dough_field(error_type)
      {
        blank: 'data-dough-validation-empty',
        invalid: 'data-dough-validation-invalid'
      }.fetch(error_type, "data-dough-validation-#{error_type}")
    end
  end
end
