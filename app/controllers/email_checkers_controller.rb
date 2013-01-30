class EmailCheckersController < ApplicationController

  def index
    params[:search] = 0 if params[:search].nil?
    @response = TopLevelDomain.validate_email(params[:search], true, true)

  end
end
