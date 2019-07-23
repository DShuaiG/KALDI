#!/bin/bash

. ./cmd.sh
. ./path.sh

set -e # exit on error

H=`pwd`
#owndata=tttest
enrolldata=enroll_lym
testdata=test_lym


mfccdir=mfcc
 
###  Generate features and vad on enroll(3/spk) and test dataset 
for x in $enrolldata $testdata; do

	### Generate wav.scp    liangym
	#local/data_pred_test_lym.sh $H $H $x
	local/generate_wavscp_lym.sh $H $H $x

	### Generate feats.scp   liangym
	steps/make_mfcc_lym.sh --cmd "$train_cmd" --nj 1 data/$x exp/make_mfcc/$x $mfccdir

	### Generate vad.scp	liangym
	sid/compute_vad_decision_lym.sh --nj 1 --cmd "$train_cmd" data/$x exp/make_mfcc/$x $mfccdir
done

###	Generate utt2spk and spk2utt on enroll dataset
local/utt22spk_enroll_lym.sh $enrolldata


### Extract enroll i-vector	liangym
sid/extract_ivectors.sh --cmd "$train_cmd" --nj 1 \
	exp/extractor_1024 data/enroll_lym  exp/ivector_enroll_lym_1024
### Extract i-vector	liangym
sid/extract_ivectors_lym.sh --cmd "$train_cmd" --nj 1 \
	exp/extractor_1024 data/test_lym  exp/ivector_test_lym_1024


### Generate trials		liangym
#trials=data/tttest/aishell_enroll_speaker_ver.lst

trials=data/test_lym/aishell_speaker_ver.lst
local/produce_trials_lym.sh $testdata data/$enrolldata/spk2utt $trials

### compute plda score	liangym
$train_cmd exp/ivector_test_lym_1024/log/plda_score.log \
	ivector-plda-scoring --num-utts=ark:exp/ivector_enroll_lym_1024/num_utts.ark \
	exp/ivector_train_1024/plda \
	ark:exp/ivector_enroll_lym_1024/spk_ivector.ark \
	"ark:ivector-normalize-length scp:exp/ivector_test_lym_1024/ivector.scp ark:- |" \
	"cat '$trials' | awk '{print \\\$2, \\\$1}' |" exp/trials_test_lym_out

