#!/usr/bin/env python3

# Copyright 2017 Bengu Wu
# Apache 2.0.

# This script splits the test set utt2spk into enroll set and eval set
# For each speaker, 3 utterances are randomly selected as enroll samples,
# and the others are used as eval samples for evaluation
# input: test utt2spk
# output: enroll utt2spk, eval utt2spk

###  liangym 这个脚本首先先将每个spk和与其对应的utt存入dictutt中，
###  然后再将spk的utt顺序随机打乱，重新分配到enroll（注册集）和eval（评估集）中。
###  可以看到在程序的倒数第六行中，if(i<3):就将utt写入enroll中，否则就写入eval中。
###  所以我们可以通过改这个值来改变注册集和评估集中的语音数。

import sys,random

dictutt = {}

for line in open(sys.argv[1]):
  line = line.rstrip('\r\t\n ')
  utt, spk = line.split(' ')
  if spk not in dictutt:
    dictutt[spk] = []
  dictutt[spk].append(utt)

fenroll = open(sys.argv[2], 'w')
feval = open(sys.argv[3], 'w')

for key in dictutt:
  utts = dictutt[key]
  random.shuffle(utts)
  for i in range(0, len(utts)):
    line = utts[i] + ' ' + key
    if(i < 3):
      fenroll.write(line + '\n')
    else:
      feval.write(line + '\n')

fenroll.close()
feval.close()
