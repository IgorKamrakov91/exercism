# frozen_string_literal: true

module ETL
  def self.transform(old_data)
    new_data = {}

    old_data.each do |key, values|
      values.each do |value|
        new_data[value.downcase] = key
      end
    end

    new_data
  end
end
