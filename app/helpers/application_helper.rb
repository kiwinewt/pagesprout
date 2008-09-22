# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def use_tinymce
    # Avoid multiple inclusions
    @content_for_tinymce = ""
    content_for :tinymce do
      javascript_include_tag('tiny_mce/tiny_mce') + javascript_include_tag('mce_editor')
    end
  end

end
