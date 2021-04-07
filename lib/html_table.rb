# frozen_string_literal: true

require 'active_support/all'
require 'securerandom'

##
# Manage HTML table
#
class HtmlTable
  #
  # Constants
  #
  DEFAULT_COLOR = '#5bc0de'
  DEFAULT_PAGINATION_OPTIONS = [5, 10, 20, 40].freeze

  #
  # Virtual attributes
  #

  attr_accessor :attributes, :base_url, :pagination_options, :primary_color, :resources, :resources_class,
                :resources_count, :secondary_color, :show_resource_link, :table_id

  ##
  # Initialize class
  #
  def initialize(resources_class, resources, attributes, params = {})
    @attributes = attributes&.to_a
    @resources = resources&.to_a
    @resources_class = resources_class
    @resources_count = resources.size
    @base_url = params[:base_url]
    @table_id = params[:table_id] || SecureRandom.hex
    @show_resource_link = params[:show_resource_link] != false && resources_class.method_defined?('id')
    @pagination_options = params[:pagination_options] || DEFAULT_PAGINATION_OPTIONS
    @primary_color = params[:primary_color] || DEFAULT_COLOR
    @secondary_color = params[:secondary_color] || DEFAULT_COLOR
  end

  ##
  # Generate HTML table
  #
  def generate!
    return '' if invalid_data

    complete_css + complete_div + complete_js
  end

  private

  ##
  # Complete table css
  #
  def complete_css
    "<style>#{css_file}</style>"
  end

  ##
  # Complete table divs
  #
  def complete_div
    "<div class='table-wrapper'>
      #{pagination_header}
      <table class='fl-table' id='#{table_id}'>
          <thead>
            <tr>#{table_head}</tr>
          </thead>
          <tbody>
            #{table_body}
          <tbody>
      </table>
    </div>
    #{pagination_footer}"
  end

  ##
  # Complete table JS
  #
  def complete_js
    "<script>#{js_file}</script>"
  end

  ##
  # Pagination header
  #
  def pagination_header
    "<div class='pagination_header'>Registros por página:
      <select name='state' id='#{table_id}maxRows'>
        <option value='#{resources_count}'>Mostrar Todos</option>
        #{ pagination_options.map do |pagination_option|
             "<option value='#{pagination_option}'>#{pagination_option}</option>"
           end }
      </select>
    </div>"
  end

  ##
  # Pagination Footer
  #
  def pagination_footer
    "<div class='pagination_footer'><nav>
        <ul class='#{table_id}pagination'>
          <li style='cursor: pointer; display: inline-block;' data-page='prev'>
            <span> <b><</b> <span class='sr-only'>(current)</span></span>
          </li>
          <li style='cursor: pointer; display: inline-block;' data-page='next' id='prev'>
            <span> <b>></b> <span class='sr-only'>(current)</span></span>
          </li>
        </ul>
      </nav></div>"
  end

  ##
  # Table head
  #
  def table_head
    block = String.new
    attributes.each do |attribute|
      block << '<th>' << head_cell_value(attribute) << '</th>'
    end
    block << "<th id='#{attributes.size.odd? ? 'fl-table-odd' : 'fl-table-even'}'></th>" if show_resource_link
    block
  end

  ##
  # Head cell value
  #
  def head_cell_value(attribute)
    return '-' if attribute.blank?

    result = if resources_class.respond_to?('locale_key')
               resources_class.locale_key(attribute.to_s)
             else
               attribute
             end
    (result.present? ? result : '-').to_s.titleize
  end

  ##
  # Table body
  #
  def table_body
    block = String.new
    resources.each do |resource|
      block << '<tr>'
      attributes.each do |attribute|
        block << '<td>' << body_cell_value(resource, attribute) << '</td>'
      end
      block << resource_link(resource) if show_resource_link
      block << '</tr>'
    end
    block
  end

  ##
  # Body cell value
  #
  def body_cell_value(resource, attribute)
    return '-' if resource.blank? || attribute.blank?

    result = if resource.respond_to?('locale_value')
               resource.send('locale_value', attribute, resource.send(attribute))
             else
               resource.send(attribute)
             end
    result.present? ? result : '-'
  end

  ##
  # Generate link to resource
  #
  def resource_link(resource, size = 0.4)
    block = String.new
    block << "<td width='#{146 * size}px'>"
    block << "<a href='#{base_url}/admin/#{resource.class.name.underscore}/#{resource.id}' target='_blank'>"
    block << "<img width='#{73 * size}px' height='#{43 * size}px'
              src='#{resource_link_icon}'>"
    block << '</a></td>'
    block
  end

  ##
  # Open show icon
  #
  def resource_link_icon
    File.open("#{__dir__}/assets/icons/show.icon").read
  end

  ##
  # Parsed CSS file
  #
  def css_file
    File.open("#{__dir__}/assets/css/table_template.css")
        .read
        .gsub('/*PRIMARY_COLOR*/', "background: #{primary_color};")
        .gsub('/*SECONDARY_COLOR*/', "background: #{secondary_color};")
  end

  ##
  # Parsed JS file
  #
  def js_file
    js_file = File.open("#{__dir__}/assets/js/table_template.js").read
    js_file.gsub('table-id', table_id)
           .gsub('pagination', "#{table_id}pagination")
           .gsub('maxRows', "#{table_id}maxRows")
           .gsub('5000', resources_count.to_s)
  end

  ##
  # Check if all parameters is valid
  #
  def invalid_data
    if !resources.is_a?(Array) || !attributes.is_a?(Array)
      true
    elsif [resources_class, resources, attributes, table_id].any?(&:blank?) || attributes.any?(&:blank?)
      true
    end
    false
  end
end
