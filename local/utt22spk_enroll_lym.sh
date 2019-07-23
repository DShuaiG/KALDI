#!/bin/bash
# Copyright 2016  Tsinghua University (Author: Dong Wang, Xuewei Zhang).  Apache 2.0.
#           2016  LeSpeech (Author: Xingyu Na)

#This script pepares the data directory for thchs30 recipe. 
#It reads the corpus and get utt2spk and spk2utt and transcriptions.

enrolldir=$1

rm -rf data/$enrolldir/utt2spk
rm -rf data/$enrolldir/spk2utt
rm -rf data/$enrolldir/split1/1/utt2spk
rm -rf data/$enrolldir/split1/1/spk2utt

for nn in `find  $enrolldir -name "*.wav" | sort -u | xargs -I {} basename {} .wav`; do
	spkid=`echo $nn | awk -F"_" '{print "" $1}'`
	#echo $spkid
	#utt_num=`echo $nn | awk -F"_" '{print $2}'`
	uttid=$nn
	#echo $uttid
	echo $uttid $spkid >> data/$enrolldir/utt2spk
	done 
utils/utt2spk_to_spk2utt.pl data/$enrolldir/utt2spk > data/$enrolldir/spk2utt
cp data/$enrolldir/utt2spk data/$enrolldir/split1/1/
cp data/$enrolldir/spk2utt data/$enrolldir/split1/1/


