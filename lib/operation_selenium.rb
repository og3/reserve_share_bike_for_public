class OperationSelenium
  require 'selenium-webdriver'

  @@driver
  PORT_LIST = {
      "hamachogawa" => '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[2]/form[5]/div/div/a',
      "seveneleven_koamicho" => '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[2]/form[7]/div/div/a',
      "hakozakigawa" => '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[1]/form[5]/div/div/a',
      "meijiza" => '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[1]/form[4]/div/div/a',
      "royalparkhotel" => '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[2]/form[6]/div/div/a'
    }

  def self.starting_headless_chrome
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    @@driver = Selenium::WebDriver.for :chrome, options: options
  end

  def self.login_to_with_reserve_account
    @@driver.get('https://tcc.docomo-cycle.jp/cycle/TYO/cs_web_main.php?AreaID=2')
    # ログイン処理
    @@driver.find_element(:name, 'MemberID').send_keys(ENV['RESERVE_ID'])
    @@driver.find_element(:name, 'Password').send_keys(ENV['RESERVE_PASS'])
    @@driver.find_element(:name, 'Password').send_keys(:enter)
  end

  def self.get_to_port_list_in_chuouku
    begin
      @@driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/form[1]/div/a').click
    # すでに予約されている場合は選べないのでブラウザを終了させる
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @@driver.quit
      exit
    end
    sleep 2
    # プルダウンから中央区を選択
    select = Selenium::WebDriver::Support::Select.new(@@driver.find_element(:id, 'AreaID'))
    select.select_by(:value, '2')
    sleep 2
  end

  def self.select_port(port_key)
    @@driver.find_element(:xpath, PORT_LIST[port_key]).click
    sleep 2
  end

  def self.research_left_bike
    PORT_LIST.each do |key, value|
      info = @@driver.find_element(:xpath, value).text
      port_name = info.split("\n")[0]
      reft_bikes = info.split("\n")[2]
      port_code = key
      research_at = Time.current.strftime("%Y-%m-%d %H:%M")
      research_wday = Time.current.wday
      Research.create(port_name: port_name, reft_bikes: reft_bikes, research_at: research_at, research_wday: research_wday, port_code: port_code)
    end
  end

  def self.select_bike
    # 自転車を指定 自転車が存在しない場合ブラウザを終了する
    begin
      @@driver.find_element(:xpath, '//*[@id="cycBtnTab_0"]').send_keys(:enter)
    rescue Selenium::WebDriver::Error::NoSuchElementError
      NotificationMailer.send_has_bike_ports.deliver
      @@driver.quit
      exit
    end
  end

  def self.quit_driver
    @@driver.quit
  end
end
