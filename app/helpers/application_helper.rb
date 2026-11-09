# frozen_string_literal: true

module ApplicationHelper
  # localeに応じて複数形の表記を変える
  # - 日本語の場合 => 本
  # - 英語の場合 => books
  def i18n_pluralize(word)
    I18n.locale == :ja ? word : word.pluralize
  end

  # localeに応じてエラー件数の表記を変える
  # - 日本語の場合 => 3件のエラー
  # - 英語の場合 => 3 errors
  def i18n_error_count(count)
    I18n.locale == :ja ? "#{count}件の#{t('views.common.error')}" : pluralize(count, t('views.common.error'))
  end

  def format_content(content)
    processed_content = content.split("\n").map do |line|
      processed_line = line.split(%r{(http://localhost:3000\S*)}).map do |part|
        if part.match?(%r{http://localhost:3000\S*})
          link_to part, part
        else
          part
        end
      end
      safe_join(processed_line, '')
    end
    safe_join(processed_content, tag.br)
  end
end
