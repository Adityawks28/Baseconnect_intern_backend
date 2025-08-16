class Job < ApplicationRecord
    validates :title, presence: true
    validates :category, presence: true
    validates :salary_manyen, numericality: { only_integer: true, greater_than: 0 }
  
    # present camelCase to match your React types
    def salaryManYen = salary_manyen
    def createdAt    = created_at
  end
  