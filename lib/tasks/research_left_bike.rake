namespace :research_left_bike do
  task research: :environment do
    require 'selenium-webdriver'
    # 実行時間は平日の7~9時代
    execution_time = ([1,2,3,4,5].include?(Time.current.wday) && (7..9).include?(Time.current.hour) && (0..59).include?(Time.current.min))

    if execution_time
      OperationSelenium.starting_headless_chrome
      OperationSelenium.login_to_with_reserve_account
      OperationSelenium.get_to_port_list_in_chuouku
      OperationSelenium.research_left_bike
      puts "全ての動作が正常に行われました"
      # ブラウザを終了
      OperationSelenium.quit_driver
    end
  end
end
