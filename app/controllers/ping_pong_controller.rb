class NokogiriController < ApplicationController

  def index

    # Seleniumの設定
    url = 'https://store.nintendo.co.jp/item/HAC_R_AL3PA.html'
    options = Selenium::WebDriver::Remote::Capabilities
    options = options.chrome('chromeOptions' => {args: ['--headless']})
    driver = Selenium::WebDriver.for :chrome, desired_capabilities: options
    driver.navigate.to(url)
    wait = Selenium::WebDriver::Wait.new(timeout: 10)

    # GoogleDriveへのアクセス
    session = GoogleDrive::Session.from_config("config.json")
    spreadsheet_key = Rails.configuration.preference[:spreadsheet_by_key]
    sheets = session.spreadsheet_by_key(spreadsheet_key).worksheets[0]

    begin
      wait.until do
        @html = driver.find_element(class: 'item-cart-add-area__add-button')
        sheets[1, 1] = @html.text
        sheets[1, 2] = Time.zone.now
      end
      sheets.save
      driver.close
    rescue RuntimeError => e
      puts e.message
      driver.quit
    end
  end
end
