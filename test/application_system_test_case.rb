# frozen_string_literal: true

require 'test_helper'

# Chromeの最新バージョン158だと`Selenium::WebDriver::Error::InvalidArgumentError: invalid argument: * is not a valid URL`とエラーが出るため対処
#
# 原因
# `Capybara::Selenium::Driver::ChromeDriver#reset!`から
# `Capybara::Selenium::Driver::ChromeDriver#execute_cdp`から
# `Selenium::WebDriver::DriverExtensions::HasCDP#execute_cdp`を呼び出す際に、
# URLを渡すところをワイルドカードで済ましてしまっているためエラーが出るようになった。
#
# 対策
# 今回のテストは単一URLであるため`Capybara::Selenium::Driver::ChromeDriver`でCDPを介さずに、
# `Capybara::Selenium::Driver#reset!`のロジックをコピペしてオーバーライドした。
#
# 備考
# Capybara(3.40.0)が修正されたら削除する
Capybara::Selenium::Driver::ChromeDriver.prepend(Module.new do
  def reset!
    reset_browser_state
  end
end)

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |options|
    options.add_argument('--disable-gpu')
    options.add_preference('profile.password_manager_leak_detection', false)
  end
end
