module FormEnhancementHelper
  def enhanced_form_for(record_or_name_or_array, options = {}, &proc)
    form_for(record_or_name_or_array, options.merge(:builder => EnhancedFormBuilder), &proc)
  end
  
  def span_label(content_or_options_with_block = nil, options = {}, escape = true, &block)
    content_tag(:span, content_or_options_with_block, options.merge(:class => 'label'), escape, &block)
  end
end