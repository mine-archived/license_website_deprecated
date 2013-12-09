class WelcomeController < ApplicationController
  def index
    @products = Product.all
    @cases = VCase.all.order(id: :desc)
    puts params
    # response.headers["Content-Type"] = "application/html"
    # request
    ParseCaseLicenseJob.perform_later('foo')
  end
end
