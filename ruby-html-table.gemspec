# frozen_string_literal: true

Gem::Specification.new do |specification|
  specification.required_ruby_version = '>= 2.6'
  specification.name                  = 'ruby-html-table'
  specification.version               = '0.0.6'
  specification.date                  = '2021-04-07'
  specification.summary               = 'HTML Table'
  specification.description           = 'A simple gem to generate a HTML table based on object array'
  specification.authors               = ['Guidance Experts - Time Backend', 'Arthur']
  specification.email                 = 'guidance.team.dev@gmail.com'
  specification.homepage              = ''
  specification.license               = 'MIT'
  specification.files                 = ['lib/html_table.rb',
                                         'lib/assets/css/table_template.css',
                                         'lib/assets/icons/show.icon',
                                         'lib/assets/js/table_template.js']

  # Dependencies
  specification.add_dependency 'activesupport', '>= 4.2.6'
end
