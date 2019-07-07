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
      OperationSelenium.get_to_port_list_in_chuouku
      if morning_execution_time_1 || morning_execution_time_2
        OperationSelenium.select_port("hamachogawa")
      else
        # 帰りの自転車に関しては処理を分けていく予定
        select = Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'Location'))
        select.select_by(:value, '銀座・築地/Ginza・Tsukiji')
        sleep 2
        # 銀座スクエアを指定
        driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[1]/form[2]/div/div/a').click
        sleep 2
      end
      OperationSelenium.select_bike
      OperationSelenium.quit_driver
    end
  end
end
