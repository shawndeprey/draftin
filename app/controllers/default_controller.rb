class DefaultController < ApplicationController
  skip_before_filter :require_session
  # GET /
  def index
  end

  # GET /example
  def example
  end

end