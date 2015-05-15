#!/usr/bin/python
# -*- coding: utf-8 -*-

from collections import defaultdict
from luigi import six
import luigi
import subprocess
import sys

class WikiJpTitles(luigi.ExternalTask):
  def output(self):
    return luigi.LocalTarget('data/jawiki-20141017-page.csv')

class WikiJpLangLinks(luigi.ExternalTask):
  def output(self):
    return luigi.LocalTarget('data/jawiki-20141017-langlinks.csv')

class P01_JpKrTitleJoin(luigi.Task):
  def output(self):
    return luigi.LocalTarget('work/01_jpkr_title_joined.csv')

  def requires(self):
    return [WikiJpTitles(),WikiJpLangLinks()]

  def run(self):
    jp_titles = {}
    jp_lang_links = {}
    jpkr_joined_titles = []
    with self.input()[0].open('r') as in_file:
      for line in in_file:
        try:
          record = line.strip().split(',')
          jp_titles[int(record[0])] = record[1]
        except ValueError, e:
          continue
    with self.input()[1].open('r') as in_file:
      for line in in_file:
        record = line.strip().split(',')
        if record[1] != 'ko' :
          continue
        jp_lang_links[int(record[0])] = record[2]
    for key in jp_titles.keys():
      try :
        jpkr_joined_titles.append([key,jp_titles[key],jp_lang_links[key]])
      except IndexError, e:
        continue
      except KeyError, e:
        continue
    with self.output().open('w') as out_file:
      for joined_title in jpkr_joined_titles:
        print >> out_file, joined_title[1] + ',' +  joined_title[2]

class P02_GenerateKanjiHanjaDic(luigi.Task):
  target = 'work/02_jpkr_kanji_hanja_dic.csv'
  def output(self):
    return luigi.LocalTarget(self.target)
  def requires(self):
    return P01_JpKrTitleJoin()
  def run(self):
    proc = subprocess.Popen(['ruby','02_generate_kanji_hanja_dic.rb'],stdin=self.input().open('r'),stdout=subprocess.PIPE)
    with self.output().open('w') as out_file:
      ret = proc.communicate()[0]
      print >> out_file, ret

class P03_AppendFieldKanji2Hangul(luigi.Task):
  target = 'work/03_jpkr_kanji_hanja_dic_kanjihangul.csv'
  def output(self):
    return luigi.LocalTarget(self.target)
  def requires(self):
    return P02_GenerateKanjiHanjaDic()
  def run(self):
    proc = subprocess.Popen(['ruby','03_append_field_kanji2hangul.rb'],stdin=self.input().open('r'),stdout=subprocess.PIPE)
    with self.output().open('w') as out_file:
      ret = proc.communicate()[0]
      print >> out_file, ret

class P04_ExtractKanjiSamePronunciation(luigi.Task):
  target = 'work/04_jpkr_kanji_hanja_dic_extracted.csv'
  def output(self):
    return luigi.LocalTarget(self.target)
  def requires(self):
    return P03_AppendFieldKanji2Hangul()
  def run(self):
    proc = subprocess.Popen(['ruby','04_extract_kanji_same_pronunciation.rb'],stdin=self.input().open('r'),stdout=subprocess.PIPE)
    with self.output().open('w') as out_file:
      ret = proc.communicate()[0]
      print >> out_file, ret

class P05_KanaWakati(luigi.Task):
  target = 'work/05_jpkr_kanji_hanja_dic_kana_wakati.csv'
  def output(self):
    return luigi.LocalTarget(self.target)
  def requires(self):
    return P04_ExtractKanjiSamePronunciation()
  def run(self):
    proc = subprocess.Popen(['ruby','05_kana_wakati.rb'],stdin=self.input().open('r'),stdout=subprocess.PIPE)
    with self.output().open('w') as out_file:
      ret = proc.communicate()[0]
      print >> out_file, ret

class P06_ParsePronunciation(luigi.Task):
  target = 'work/06_jpkr_kanji_hanja_dic_parsed_pronunciation.csv'
  def output(self):
    return luigi.LocalTarget(self.target)
  def requires(self):
    return P05_KanaWakati()
  def run(self):
    proc = subprocess.Popen(['ruby','06_parse_pronunciation.rb'],stdin=self.input().open('r'),stdout=subprocess.PIPE)
    with self.output().open('w') as out_file:
      ret = proc.communicate()[0]
      print >> out_file, ret

class P07_CleansingAndAppendLabels(luigi.Task):
  target = 'work/07_jpkr_kanji_hanja_dic.csv'
  def output(self):
    return luigi.LocalTarget(self.target)
  def requires(self):
    return P06_ParsePronunciation()
  def run(self):
    proc = subprocess.Popen(['ruby','07_cleansing_append_labels.rb'],stdin=self.input().open('r'),stdout=subprocess.PIPE)
    with self.output().open('w') as out_file:
      ret = proc.communicate()[0]
      print >> out_file, ret

if __name__ == '__main__':
  luigi.run(main_task_cls=P07_CleansingAndAppendLabels,local_scheduler=True )
