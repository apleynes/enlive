#!/bin/bash
set -euo pipefail
# brace expand
set -B


if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

out=reco_ENLIVE/pf_vcc
mkdir -p $out


source opts.sh
#generate pf vcc
PF_VCC=data/both_PF
PSF_PF_VCC=data/both_PF_PSF
./vcs.sh $PF $PF_VCC

DEBUG=4
MAPS=2

#partial fourier vcc
# generate VCC PSF
bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS -U -P -p$PSF_PF_VCC $PF_VCC $out/r_mmu >$out/log_r_mmu.log

cfl2png $CFLCOMMON $out/r_mmu $out/r_mmu.png

bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS -P -p$PSF_PF_VCC $PF_VCC $out/r_mm >$out/log_r_mm.log
cfl2png $CFLCOMMON $out/r_mm $out/r_mm.png

bart nlinv -d$DEBUG -m1 $NLINV_OPTS -P -p$PSF_PF_VCC $PF_VCC $out/r_sm >$out/log_r_sm.log

cfl2png $CFLCOMMON $out/r_sm $out/r_sm.png