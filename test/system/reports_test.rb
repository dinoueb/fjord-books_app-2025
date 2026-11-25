# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'Password!'
    click_button 'ログイン'

    assert_text 'ログインしました'
  end

  test 'visiting the index' do
    visit reports_url

    assert_text 'Railsの勉強'
    assert_text 'Railsの実習'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: '初めての日報'
    fill_in '内容', with: '緊張した。'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text '初めての日報'
    assert_text '緊張した。'
  end

  test 'should update Report' do
    alice_report = reports(:alice_report)
    visit report_url(alice_report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: '編集した日報'
    fill_in '内容', with: '編集しました。'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text '編集した日報'
    assert_text '編集しました。'
  end

  test 'update report with mention' do
    alice_report = reports(:alice_report)
    bob_report = reports(:bob_report)

    visit report_url(alice_report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: '他日報へ言及する日報'
    fill_in '内容', with: "http://localhost:3000/reports/#{bob_report.id}"
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text '他日報へ言及する日報'
    assert_link "http://localhost:3000/reports/#{bob_report.id}"
  end

  test 'should destroy Report' do
    alice_report = reports(:alice_report)
    visit report_url(alice_report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    assert_text '日報の一覧'
    assert_no_text 'Railsの勉強'
  end
end
