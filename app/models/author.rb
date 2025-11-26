class Author < ApplicationRecord
  # The N+1 usually occurs when accessing this association
  has_many :books, dependent: :destroy
end
