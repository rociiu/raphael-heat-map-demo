class PercentageValue < ActiveRecord::Base
  belongs_to :country
  belongs_to :browser
end
