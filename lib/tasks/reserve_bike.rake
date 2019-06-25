namespace :reserve_bike do
  task reserve: :environment do
    require 'selenium-webdriver'

    week_day = [1,2,3,4,5].include?(Time.current.wday)
    morning_execution_time_1 = (week_day && 7 == Time.current.hour && (40..49).include?(Time.current.min))
    morning_execution_time_2 = (week_day && 8 == Time.current.hour && (0..9).include?(Time.current.min))
    evening_execution_time = (week_day && 18 == Time.current.hour && (0..59).include?(Time.current.min))

    if morning_execution_time_1 || morning_execution_time_2 || evening_execution_time
      # chromeをheadlessモードで起動させる
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :chrome, options: options
      # ログイン画面を開く
      driver.get('https://tcc.docomo-cycle.jp/cycle/TYO/cs_web_main.php?AreaID=2')
      sleep 2
      # ログイン処理
      driver.find_element(:name, 'MemberID').send_keys(ENV['RESERVE_ID'])
      driver.find_element(:name, 'Password').send_keys(ENV['RESERVE_PASS'])
      driver.find_element(:name, 'Password').send_keys(:enter)
      sleep 2
      # 「駐輪場から選ぶ」を選択
      # すでに予約されている場合は選べないのでブラウザを終了させる
      begin
        driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/form[1]/div/a').click
      rescue Selenium::WebDriver::Error::NoSuchElementError
        puts "自転車はすでに予約されています"
        driver.quit
        exit
      end
      sleep 2
      # プルダウンから中央区を選択
      select = Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'AreaID'))
      select.select_by(:value, '2')
      sleep 2
      if morning_execution_time_1 || morning_execution_time_2
        # 浜町川緑道を指定
        driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[2]/form[5]/div/div/a').click
        sleep 2
      else
        select = Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'Location'))
        select.select_by(:value, '銀座・築地/Ginza・Tsukiji')
        sleep 2
        # 銀座スクエアを指定
        driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[1]/form[2]/div/div/a').click
        sleep 2
      end
      # 自転車を指定
      # 自転車が存在しない場合ブラウザを終了する
      begin
        driver.find_element(:xpath, '//*[@id="cycBtnTab_0"]').send_keys(:enter)
      rescue Selenium::WebDriver::Error::NoSuchElementError
        puts "自転車が存在しませんでした"
        driver.quit
        exit
      end
      sleep 2
      # ブラウザを終了
      driver.quit
    else
      puts "時間外により終了します"
    end
  end
end
