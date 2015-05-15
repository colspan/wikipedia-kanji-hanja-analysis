#!/usr/bin/ruby -Ku

require 'kakasi'
# ー
STDIN.each do |line|
  # parsing
  record = line.chomp.split(',')
  char_yomis_juman = record[2].gsub(/(ク|ー|ン|ッ)/,'\1 ').chomp.split(' ')
  kakasi_buffer = Kakasi.kakasi("-osjis -JK -y",record[0])
  # [事:{こと|ごと|じ},務:{つとむ|む},職:しょく]
  char_yomis_kakasi = []
  kakasi_buffer.gsub(/\{/,'').gsub(/\]\[/,',').gsub(/(\}\])|\]|\}/,',').gsub(/,,/,',').split(',').each do |yomi|
    next if yomi[-1] == ':'
    char_yomis_kakasi << yomi.split(':')[1].split('|')
    # kakasi_buffer.scan(/\{(\S+)(|\S+)*\}/)
  end
  if char_yomis_juman.length == record[0].length then
    output_yomis = []
    kanas = record[1].split('')
    char_yomis_juman.each do |yomi|
      tmp_kana = []
      yomi.length.times do
        tmp_kana << kanas.shift
      end
      output_yomis << tmp_kana.join('')
    end
    puts [record[0],output_yomis.join('|'),char_yomis_juman.join('|'),record[3]].join(',')
  elsif char_yomis_kakasi.length == record[0].length then
    output_yomis = []
    output_yomis_boh = []
    kanas = record[1].split('')
    kanas_boh = record[2].split('')
    yomi_counter = 0
    yomi_juman = record[1].gsub('ッ','ツ')
    char_yomis_kakasi.each do |yomis|
      tmp_kana = []
      tmp_kana_boh = []
      yomi_index = nil
      if yomis.length == 1 then
        yomi_index = 0
      elsif
        yomis.sort! do |a, b|
          a.length <=> b.length
        end
        yomis.each_with_index do |yomi,i|
          #puts yomi.tr('ぁ-ん','ァ-ン') + ',' + record[1][0,yomi.length]
          yomi_index = i if yomi.tr('ぁ-ん','ァ-ン') == yomi_juman[yomi_counter,yomi.length]
        end
      end

      if yomi_index == nil then
        output_yomis << 'unknown'
        output_yomis_boh << 'unknown'
        next
      end
      yomi_counter += yomis[yomi_index].length
      yomis[yomi_index].length.times do
        tmp_kana << kanas.shift
        tmp_kana_boh << kanas_boh.shift
      end
      output_yomis << tmp_kana.join('')
      output_yomis_boh << tmp_kana_boh.join('')
    end
    next if output_yomis.include?('unknown')
    puts [record[0],output_yomis.join('|'),output_yomis_boh.join('|'),record[3]].join(',')
  else
    # do nothing
  end

end
