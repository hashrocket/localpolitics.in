module ValueParser
  def date?(value)
    true if Date.parse(value) rescue false
  end

  def numeric?(value)
    true if Float(value) rescue false
  end

  def zip_code?(value)
    zip_code = value.kind_of?(Fixnum) ? value.to_s : value
    numeric?(zip_code) && zip_code.length == 5
  end
end
