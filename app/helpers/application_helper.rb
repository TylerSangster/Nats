module ApplicationHelper

  @@base_title = "Frog-Log"

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    if page_title.empty?
      @@base_title
    else
      "#{@@base_title} | #{page_title}"
    end
  end

  # Returns the header on a per-page basis.
  def header_text(page_title)
    page_title || @@base_title
  end
end