# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @current_user = users(:alice)

    visit root_url
    fill_in 'Eメール', with: @current_user.email
    fill_in 'パスワード', with: 'Password!'
    click_button 'ログイン'
    assert_text 'ログインしました'
  end
  #
  # test 'visiting the index' do
  # visit reports_url
  # assert_selector 'h1', text: 'Reports'
  # end

  test 'should create report' do
    title = '初めての日報'
    content = '緊張した。'

    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: title
    fill_in '内容', with: content
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text title
    assert_text content
    assert_text @current_user.name
  end

  test 'should update Report' do
    target_report = @current_user.reports.first
    title = '編集した日報'
    content = '編集しました。'

    visit report_url(target_report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: title
    fill_in '内容', with: content
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text title
    assert_text content
    assert_text @current_user.name

    target_report.reload
    assert_equal target_report.title, title
    assert_equal target_report.content, content
  end

  test 'update report with mention' do
    mentioning_report = @current_user.reports.first
    mentioned_report = reports(:bob_report)
    title = '他日報へ言及する日報'
    content = "http://localhost:3000/reports/#{mentioned_report.id}"

    visit report_url(mentioning_report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: title
    fill_in '内容', with: content
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text title
    assert_text content
    assert_text @current_user.name
    click_on content

    assert_text mentioned_report.title
    assert_text mentioned_report.content
    assert_text mentioned_report.user.name
    assert_text title
  end

  test 'should destroy Report' do
    target_report_id = @current_user.reports.first.id
    visit report_url(target_report_id)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    assert_text '日報の一覧'
  end
end
