module Admin
  class BaseController < ApplicationController
    before_action :require_admin
    skip_before_action :set_search
    skip_before_action :prepare_meta_tags

    private

    def require_admin
      redirect_to ENV["REDIRECT_PATH"], allow_other_host: true unless current_user&.admin?
    end
  end
end
