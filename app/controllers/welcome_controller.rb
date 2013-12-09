class WelcomeController < ApplicationController
  def index
    @cases = VCase.all.order(id: :desc)
    # response.headers["Content-Type"] = "application/html"
    # request
    # ParseCaseLicenseJob.perform_later('foo')
  end
end
