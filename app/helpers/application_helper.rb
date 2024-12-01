module ApplicationHelper
  def truncate_description(description, word_limit, view_more_path)
    return "No description available." if description.blank?

    words = description.split
    if words.size > word_limit
      truncated = words[0...word_limit].join(" ") + "..."
      truncated + " " 
    else
      description
    end
  end
end
