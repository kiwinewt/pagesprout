# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

class EnhancedFormBuilder < ActionView::Helpers::FormBuilder
  # EnhancedFormBuilder overwrites most form helpers.
  # Rather than <tt><%= f.label :name %><%= f.text_field :name %></tt>,
  # you can just use <tt><%= f.text_field :name %></tt> and it will be 
  # wrapped into the necessary chunks.
  # Useful options are :label, :note
  # You can drop into regular fields at any point with a fields_for block
  
  helpers = field_helpers +
            %w{date_select datetime_select time_select} +
            %w{collection_select select country_select time_zone_select} -
            %w{hidden_field label fields_for check_box} # Don't decorate these
  
  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      label = label(field, options.delete(:label))
      # Add a note by passing :note
      extras = @template.content_tag(:span, options.delete(:note), :class => 'note') if options[:note]
      # Errors (overrides note, a good error should be descriptive)
      extras = @template.content_tag(:span, full_message_for(field),:class => 'error message') if @object.errors.on(field)
      section([label, super, extras].join("\n"))
    end
  end
  
  def check_box(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    label = label(args.first, options.delete(:label))
    super + label
  end
  
  def checklist(&block)
    section_block('section checklist', &block)
  end
  
  def actions(&block) 
    section_block('actions', &block)
  end
  
  def section_block(classes = 'section', &block)
    @template.concat(section(@template.capture(&block), classes))
  end
  
  def section(content, classes = 'section', &block)
    html = @template.content_tag(:div, content, :class => classes.to_s)
  end
  
  # _fields.html.erb
  def standard_fields
    formatted_error_messages + @template.render(:partial => 'fields', :locals => { :f => self })
  end
  
  def formatted_error_messages
    messages = ""
    if @object.errors.present?
      messages = "Please fix the problems below before resubmitting.";
      messages << formatted_base_error_messages
      messages = @template.content_tag(:div, messages, :id => "errors")
    end
    messages
  end
  
  def formatted_base_error_messages
    messages = ""
    if @object.errors.on_base.present?
      @object.errors.on_base.each do |m|
        messages << @template.content_tag(:li, m)
      end
      messages = @template.content_tag(:ul, messages)
    end
    messages
  end
  
  
  def full_message_for(field)
    "#{@object.class.human_attribute_name(field.to_s)} #{@object.errors.on(field)}."
  end
  
end
