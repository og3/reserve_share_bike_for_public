class ReservesController < ApplicationController
  def reserve_bike
    OperationSelenium.starting_headless_chrome
    OperationSelenium.login_to_with_reserve_account
    OperationSelenium.get_to_port_list_in_chuouku
    OperationSelenium.select_port(params[:port_key])
    OperationSelenium.select_bike
  end
end
