#!/usr/bin/ruby

def set_traintype(acronym_t, acronym_tc)
  if acronym_t == ""
    if acronym_tc =~ /▲/
      "普通(筑紫から急行)"
    else
      "普通"
    end
  elsif acronym_t == "急"
    if acronym_tc == "筑○"
      "急行(二日市から普通)"
    elsif acronym_tc == "小▲"
      "急行(筑紫から普通)"
    else
      "急行"
    end
  elsif acronym_t == "特"
    "特急"
  end
end

def set_destination(train_num, acronym)
  case acronym
  when ""
    # 列車番号依存 (福岡/太宰府/大牟田)
    if train_num =~ /[68L]..[13579]/
      "太宰府"
    elsif train_num =~ /...[13579]/
      "大牟田"
    elsif train_num =~ /...[02468]/
      "福岡(天神)"
    else
      "(未定義)"
    end
  when "二"
    "二日市"
  when "宰"
    "太宰府"
  when "筑"
    "筑紫"
  when "筑○"
    "筑紫"
  when "小"
    "小郡"
  when "小▲"
    "小郡"
  when "久"
    "久留米"
  when "花", "花■"
    "花畑"
  when "津"
    "津福"
  when "善"
    "大善寺"
  when "柳"
    "柳川"
  when "甘"
    "甘木"
  when "本"
    "本郷"
  when "北"
    "北野"
  end
end

depart_hour = ""

ARGF.each do |line|
  line.gsub!(/&nbsp;/, "")

  # 時の設定
  if line =~ /<td.+class="hour">(.+)<\/td>/
    depart_hour = sprintf("%02d", $~[1].to_i)
  end

  # 分・行先・列車番号の設定
  if line =~ /<a href=".+?keito_cd=..(....).+?">(\d\d)(.??)<br \/>(.*?)<\/a>/
    train_num = $~[1]
    depart_minute = $~[2]

    # 列車種別の設定
    type = set_traintype($~[3], $~[4])

    # 行先の設定
    destination = set_destination($~[1], $~[4])

    puts "#{depart_hour}:#{depart_minute},#{train_num},#{type},#{destination}"
  end
end
