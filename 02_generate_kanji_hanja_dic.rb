#!/usr/bin/ruby -Ku

require "mecab"

stop_counter = 0

output_records = []

m = MeCab::Tagger.new

STDIN.each do |line|
  next if line.chomp.length < 3
  # parsing
  record = line.chomp.split(',')
  jp_title = record[0]
  kr_title = record[1]

  # mecab
  node = m.parseToNode(jp_title)
  jp_surfaces = []
  jp_features = []
  while node
    unless node.surface == "" then
      jp_surfaces << node.surface
      jp_features << node.feature.split(',')
    end
    node = node.next
  end

  # kr
  kr_surfaces = kr_title.split('_')

  # merge
  if jp_surfaces.length == kr_surfaces.length then
    jp_surfaces.each_with_index do |jp_surface,i|
      if /^([一-龠]|[亜-煕])+$/ =~jp_surface then # 漢字のみを抜粋
        puts [jp_surface,jp_features[i], kr_surfaces[i]].flatten.join(',')
      end
    end
  end
  stop_counter += 1
  STDOUT.flush
end
