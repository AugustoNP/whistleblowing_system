class CnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    numbers = value.to_s.gsub(/\D/, '')
    
    # DEBUGGING LOGS
    puts "--- CNPJ VALIDATION START ---"
    puts "Original Value: #{value}"
    puts "Cleaned Numbers: #{numbers}"
    puts "Length: #{numbers.length}"

    unless valid_cnpj?(numbers)
      record.errors.add(attribute, (options[:message] || "não é um CNPJ válido"))
    end
  end

  private

  def valid_cnpj?(numbers)
    return false unless numbers.length == 14
    return false if numbers.chars.uniq.size <= 1

    digits = numbers.chars.map(&:to_i)

    weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    sum1 = digits[0...12].zip(weights1).map { |a, b| a * b }.sum
    check1 = (sum1 % 11 < 2) ? 0 : 11 - (sum1 % 11)
    
    puts "1st Digit Calc: Expected #{check1}, Got #{digits[12]}"

    weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    sum2 = digits[0...13].zip(weights2).map { |a, b| a * b }.sum
    check2 = (sum2 % 11 < 2) ? 0 : 11 - (sum2 % 11)
    
    puts "2nd Digit Calc: Expected #{check2}, Got #{digits[13]}"
    puts "--- CNPJ VALIDATION END ---"

    digits[12] == check1 && digits[13] == check2
  end
end