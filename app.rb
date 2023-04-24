# frozen_string_literal: true

require_relative 'timeformatter'

class App
  DELIMETER = '%2C'

  def call(env)
    return response(404, ["Not found\n"]) if request_path_bad?(env)

    query_splitted_by_equality = env['QUERY_STRING'].split('=')

    return response(400, ["Wrong format key\n"]) if request_format_bad?(query_splitted_by_equality[0])

    query_params = query_splitted_by_equality[1]

    return response(400, ["No parameters defined\n"]) if query_params.nil?

    params = extract_params(query_params)

    return response(400, ["No parameters defined\n"]) if params.empty?

    status, body = TimeFormatter.new.call(params)
    response(status, body)
  end

  private

  def response(status, body)
    Rack::Response.new(
      body,
      status,
      header
    ).finish
  end

  def request_path_bad?(env)
    env['REQUEST_PATH'] != '/time'
  end

  def request_format_bad?(format_key)
    format_key != 'format'
  end

  def extract_params(query_params)
    if query_params.include?(DELIMETER)
      query_params.split(DELIMETER)
    elsif query_params.include?(',')
      query_params.split(',')
    else
      query_params.split
    end
  end

  def header
    { 'Content-Type' => 'text/plain' }
  end
end
