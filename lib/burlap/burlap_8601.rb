module BurlapIso8601
  # Burlap needs #iso8601 without any dashes or colons. It mimics the 1.8 implementation
  # of #iso8601, including not having a dependency on #strftime.
  # 
  # @param [Integer] fraction_digits number of digits of milliseconds wanted
  # @return [String] 
  # 
  def burlap_iso8601 fraction_digits=0
    sprintf("%d%02d%02dT%02d%02d%02d", year, mon, day, hour, min, sec) + \

    case fraction_digits
    when 0
      ""
    when 1..6
      sprintf(".%06d", usec)[0..3]
    else
      sprintf(".%06d", usec) + "0" * (fraction_digits - 6)
    end + \

    if utc?
      'Z'
    else
      off = utc_offset
      sign = off < 0 ? '-' : '+'
      sprintf('%s%02d:%02d', sign, *(off.abs / 60).divmod(60))
    end
  end
end
