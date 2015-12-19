class Dwz::WangzhanController < ApplicationController
  around_filter :round
  def round
    yield
  end
end
