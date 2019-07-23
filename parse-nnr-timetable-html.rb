#!/usr/bin/ruby

require './nnr-timetable-parser'

RE_HOUR      = /<td.+class="hour">(.+)<\/td>/
RE_TRAINDATA = /<a href=".+?keito_cd=..(....).+?">(\d\d)(.??)<br \/>(.*?)<\/a>/

depart_hour = ""

ARGF.each do |line|
  line.gsub!(/&nbsp;/, "")

  # 時の設定
  if RE_HOUR =~ line
    depart_hour = sprintf("%02d", $~[1].to_i)
  end

  # 分・行先・列車番号の設定
  if RE_TRAINDATA =~ line
    train_num = $~[1]
    depart_minute = $~[2]

    # 列車種別の設定
    type = NNRTimetableParser.set_traintype($~[3], $~[4])

    # 行先の設定
    destination = NNRTimetableParser.set_destination($~[1], $~[4])

    puts "#{depart_hour}:#{depart_minute},#{train_num},#{type},#{destination}"
  end
end
