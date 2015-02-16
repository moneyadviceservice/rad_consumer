class SearchForm
  include ActiveModel::Model

  attr_accessor :postcode, :checkbox

  validates :postcode,
    presence: true,
    format: { with: /\A[A-Z\d]{1,4} [A-Z\d]{1,3}\z/ }
end
