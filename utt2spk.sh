#!/bin/bash
# Copyright 2016  Tsinghua University (Author: Dong Wang, Xuewei Zhang).  Apache 2.0.
#           2016  LeSpeech (Author: Xingyu Na)

#This script pepares the data directory for thchs30 recipe. 
#It reads the corpus and get utt2spk and spk2utt and transcriptions.

for nn in `find  $1 -name "*.wav" | sort -u | xargs -I {} basename {} .wav`; do
	spkid=`echo $nn | awk -F"_" '{print "" $1}'`
	#echo $spkid
	#utt_num=`echo $nn | awk -F"_" '{print $2}'`
	uttid=$nn
	#echo $uttid
	echo $uttid $spkid >> utt2spk
	done 
utils/utt2spk_to_spk2utt.pl utt2spk > spk2utt

