namespace :reserve_bike do
  task reserve: :environment do
    require 'selenium-webdriver'
    # 今後は画面から実行日時を選べるようにする
    week_day = [1,2,3,4,5].include?(Time.current.wday)
    morning_execution_time_1 = (week_day && 7 == Time.current.hour && (40..49).include?(Time.current.min))
    morning_execution_time_2 = (week_day && 8 == Time.current.hour && (0..9).include?(Time.current.min))
    evening_execution_time = (week_day && 18 == Time.current.hour && (0..59).include?(Time.current.min))

    if morning_execution_time_1 || morning_execution_time_2 || evening_execution_time
      OperationSelenium.starting_headless_chrome
      OperationSelenium.login_to_with_reserve_account
      OperationSelenium.get_to_port_list_in_chuouku("AreaID", "2")
      if morning_execution_time_1 || morning_execution_time_2
        OperationSelenium.select_port("hamachogawa")
      else
        OperationSelenium.select_location("Location", "銀座・築地/Ginza・Tsukiji")
        OperationSelenium.select_port("ginzasquea")
      end
      OperationSelenium.select_bike
      OperationSelenium.quit_driver
    end
  end
end
