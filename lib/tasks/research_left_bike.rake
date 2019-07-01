namespace :research_left_bike do
  task research: :environment do
    require 'selenium-webdriver'
    # 実行時間は平日の7~9時代
    execution_time = ([1,2,3,4,5].include?(Time.current.wday) && (7..9).include?(Time.current.hour) && (0..59).include?(Time.current.min))

    if execution_time
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :chrome, options: options
      driver.get('https://tcc.docomo-cycle.jp/cycle/TYO/cs_web_main.php?AreaID=2')
      # ログイン処理
      driver.find_element(:name, 'MemberID').send_keys(ENV['RESEARCH_ID'])
      driver.find_element(:name, 'Password').send_keys(ENV['RESEARCH_PASS'])
      driver.find_element(:name, 'Password').send_keys(:enter)
      sleep 2
      # 駐輪場選択画面へ
      driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/form[1]/div/a').click
      sleep 2
      # プルダウンから中央区を選択
      select = Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'AreaID'))
      select.select_by(:value, '2')
      sleep 2
      # データ収集
      texts = []
      # 再予約用の文字列（いずれもっとかっこよく。。）
      ports = {
        "B1-11.浜町川緑道" => "hamachogawa",
        "B1-18.セブン-イレブン 日本橋小網町店" => "seveneleven_koamicho",
        "B1-10.箱崎川第二公園" => "hakozakigawa",
        "B1-08.明治座" => "meijiza",
        "B1-15.ロイヤルパークホテル" => "royalparkhotel"
      }
      # 浜町川緑道
      texts << driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[2]/form[5]/div/div/a').text
      # セブンイレブン日本橋小網町
      texts << driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[2]/form[7]/div/div/a').text
      # 箱崎川第二公園
      texts << driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[1]/form[5]/div/div/a').text
      # 明治座
      texts << driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[1]/form[4]/div/div/a').text
      # ロイヤルパークホテル
      texts << driver.find_element(:xpath, '//*[@id="wrapper_jqm"]/div[1]/div[1]/div[2]/div[4]/div/div[2]/form[6]/div/div/a').text
      texts.each do |text|
        port_name = text.split("\n")[0]
        reft_bikes = text.split("\n")[2]
        port_code = ports[port_name]
        research_at = Time.current.strftime("%Y-%m-%d %H:%M")
        research_wday = Time.current.wday
        Research.create(port_name: port_name, reft_bikes: reft_bikes, research_at: research_at, research_wday: research_wday, port_code: port_code)
      end
      puts "全ての動作が正常に行われました"
      # ブラウザを終了
      driver.quit
    else
      puts "時間外です"
    end
  end
end
