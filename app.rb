# frozen_string_literal: true

class App
  TIME_KEYS = %w[
    year
    month
    day
    hour
    minute
    second
  ].freeze

  def call(env)
    return [404, header, ["Not found\n"]] if request_path_bad?(env)

    query_string = env['QUERY_STRING']

    return [400, header, ["Wrong format key\n"]] if request_format_bad?(query_string)

    query_params = query_string.split('=')[1]

    return [400, header, ["No parameters defined\n"]] if query_params.nil?

    params = extract_params(query_params)

    return [400, header, ["No parameters defined\n"]] if params.empty?

    response(params)
  end

  private

  def request_path_bad?(env)
    env['REQUEST_PATH'] != '/time'
  end

  def request_format_bad?(query_string)
    query_string.split('=')[0] != 'format'
  end

  def extract_params(query_params)
    if query_params.include?('%2C')
      query_params.split('%2C')
    elsif query_params.include?(',')
      query_params.split(',')
    else
      query_params.split
    end
  end

  def response(params)
    output_params = []
    invalid_params = []
    params.each do |parameter|
      if TIME_KEYS.include?(parameter)
        output_params.push(get_time(parameter))
      else
        invalid_params.push(parameter)
      end
    end

    warning_string = invalid_params.join(',').size.zero? ? nil : invalid_params.join(',')

    [200, header, body(output_params.join('-'), warning_string)]
  end

  def get_time(key)
    case key
    when 'year'
      Time.zone.now.year
    when 'month'
      Time.zone.now.month
    when 'day'
      Time.zone.now.day
    when 'hour'
      Time.zone.now.hour
    when 'minute'
      Time.zone.now.min
    when 'second'
      Time.zone.now.sec
    end
  end

  def status
    200
  end

  def header
    { 'Content-Type' => 'text/plain' }
  end

  def body(time_string, warning_string)
    if warning_string
      ["Unknown time format [#{warning_string}]\n"]
    elsif time_string
      [time_string]
    end
  end
end
