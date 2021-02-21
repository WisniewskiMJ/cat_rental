# frozen_string_literal: true

module ApplicationHelper

  def age(cat)
    time_ago_in_words(cat.birth_date)
  end

end
