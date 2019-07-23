#!/bin/bash

. ./cmd.sh
. ./path.sh

set -e # exit on error

H=`pwd`
#owndata=tttest
owndata=ttest2

mfccdir=mfcc
:<<!
### Generate wav.scp    liangym
local/data_pred_test_lym.sh $H $H $owndata

### Generate feats.scp   liangym
steps/make_mfcc_lym.sh --cmd "$train_cmd" --nj 1 data/$owndata exp/make_mfcc/$owndata $mfccdir

### Generate vad.scp	liangym
sid/compute_vad_decision_lym.sh --nj 1 --cmd "$train_cmd" data/$owndata exp/make_mfcc/$owndata $mfccdir


### Extract i-vector	liangym
sid/extract_ivectors_lym.sh --cmd "$train_cmd" --nj 1 \
	exp/extractor_1024 data/ttest2  exp/ivector_ttest2_1024
!
### Generate trials		liangym

#trials=data/tttest/aishell_enroll_speaker_ver.lst
#local/produce_trials.py data/test/enroll/utt2spk $trials
trials=data/test/aishell_speaker_ver.lst

### compute plda score	liangym
$train_cmd exp/ivector_ttest2_1024/log/plda_score.log \
	ivector-plda-scoring --num-utts=ark:exp/ivector_enroll_1024/num_utts.ark \
	exp/ivector_train_1024/plda \
	ark:exp/ivector_enroll_1024/spk_ivector.ark \
	"ark:ivector-normalize-length scp:exp/ivector_ttest2_1024/ivector.scp ark:- |" \
	"cat '$trials' | awk '{print \\\$2, \\\$1}' |" exp/trials_ttest2_out
