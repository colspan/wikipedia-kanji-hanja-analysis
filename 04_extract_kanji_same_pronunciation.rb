#!/usr/bin/ruby -Ku

jp_words = {}

STDIN.each do |line|
  # parsing
  record = line.chomp.split(',')
  next unless record[-1] == record[-2]
  next if record[-4] == '*'
  jp_words[record[0]] = record
end

jp_words.each do |key, jp_word|
  puts [jp_word[0],jp_word[-4],jp_word[-3],jp_word[-1]].join(',')
end
