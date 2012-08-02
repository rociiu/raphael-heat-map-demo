class HomeController < ApplicationController
  def index
    @data = PercentageValue.joins(:browser)
                           .joins(:country)
                           .where({ :browsers => { :name => 'Chrome'}})
                           .select("countries.name, value")
                           .inject({}) { |r, i| r[ i.name.strip ] = i.value; r }
  end
end
