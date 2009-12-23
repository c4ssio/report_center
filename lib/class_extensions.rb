class Fixnum
  def ch
    return Chart.find(self)
  end

  def chs
    return ChartSeries.find(self)
  end

  def s
    return Series.find(self)
  end

  def sdp
    return SeriesDataPoint.find(self)
  end

  def chl
    return ChartLabel.find(self)
  end
end

