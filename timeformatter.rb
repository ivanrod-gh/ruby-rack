# frozen_string_literal: true

class TimeFormatter
  TIME_TABLE = {
    year: '%Y',
    month: '%m',
    day: '%d',
    hour: '%H',
    minute: '%M',
    second: '%S'
  }.freeze

  def initialize
    @output_time_keys = []
    @invalid_input_params = []
  end

  def call(params)
    params.each do |parameter|
      if TIME_TABLE.key?(parameter.to_sym)
        @output_time_keys.push(TIME_TABLE[parameter.to_sym])
      else
        @invalid_input_params.push(parameter)
      end
    end

    body(time_string, warning_string)
  end

  private

  def body(time_string, warning_string)
    if warning_string
      return 400, ["Unknown time format [#{warning_string}]"]
    elsif time_string
      return 200, [time_string]
    end
  end

  def time_string
    Time.now.utc.strftime(@output_time_keys.join('-'))
  end

  def warning_string
    invalid_input_params_string = @invalid_input_params.join(',')
    invalid_input_params_string.size.zero? ? nil : invalid_input_params_string
  end
end
