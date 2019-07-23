#!/bin/bash

testdir=$1
enroll_spk2utt=$2
trialfile=$3

for nn in `find  $1 -name "*.wav" | sort -u | xargs -I {} basename {} .wav`; do
	uttid=$nn

	cat $enroll_spk2utt | while read line
	do
		spkid=`echo $line | awk -F " " '{print $1}'`
		echo $uttid $spkid >> $trialfile
	done
	#echo $uttid
	done

