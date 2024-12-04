class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[rule]

  def rule; end
end
