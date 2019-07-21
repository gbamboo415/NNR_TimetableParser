#!/usr/bin/ruby

depart_hour = ""

ARGF.each do |line|
  train_num = ""
  depart_minute = ""
  destination = ""
  type = ""

  line.gsub!(/&nbsp;/, "")

  # 時の設定
  if line =~ /<td.+class="hour">(.+)<\/td>/ then
    depart_hour = sprintf("%02d", $~[1].to_i)
  end

  # 分・行先・列車番号の設定
  if line =~ /<a href=".+?keito_cd=..(....).+?">(\d\d)(.??)<br \/>(.*?)<\/a>/ then
    train_num = $~[1]
    depart_minute = $~[2]

    if $~[3] == "" then type = "普通"
    elsif $~[3] == "急" then type = "急行"
    elsif $~[3] == "特" then type = "特急"
    end

    case $~[4]
    when ""
      # 列車番号依存 (福岡/太宰府/大牟田)
      if train_num =~ /[68L]..[13579]/ then
        destination = "太宰府"
      elsif train_num =~ /...[13579]/ then
        destination = "大牟田"
      elsif train_num =~ /...[02468]/ then
        destination = "福岡(天神)"
      else
        destination = "(未定義)"
      end
    when "二"
      destination = "二日市"
    when "宰"
      destination = "太宰府"
    when "筑"
      destination = "筑紫"
    when "筑○"
      type = "急行(二日市から普通)"
      destination = "筑紫"
    when "小"
      destination = "小郡"
    when "小▲"
      type = "急行(筑紫から普通)"
      destination = "小郡"
    when "久"
      destination = "久留米"
    when "花", "花■"
      destination = "花畑"
    when "津"
      destination = "津福"
    when "善"
      destination = "大善寺"
    when "柳"
      destination = "柳川"
    when "甘"
      destination = "甘木"
    when "本"
      destination = "本郷"
    when "北"
      destination = "北野"
    end

    puts "#{depart_hour}:#{depart_minute},#{train_num},#{type},#{destination}"
  end
end
