class Accreditation < ActiveRecord::Base
  include FriendlyNamable

  default_scope { order(:order) }
end
