#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M s.moia@bcbl.eu

module load singularity/3.3.0

##########################################################################################################################
##---START OF SCRIPT----------------------------------------------------------------------------------------------------##
##########################################################################################################################

date

wdr=/bcbl/home/public/PJMASK_2/EuskalIBUR_dataproc

cd ${wdr}

if [[ ! -d ../LogFiles ]]
then
	mkdir ../LogFiles
fi

# Run fALFF
for sub in 001 002 003 004 007 008 009
do
	for ses in $(seq -f %02g 1 10)
	do
		rm ${wdr}/../LogFiles/${sub}_${ses}_falff_pipe
		qsub -q short.q -N "falff_${sub}_${ses}_EuskalIBUR" \
		-o ${wdr}/../LogFiles/${sub}_${ses}_falff_pipe \
		-e ${wdr}/../LogFiles/${sub}_${ses}_falff_pipe \
		${wdr}/98.hcp/run_falff.sh ${sub} ${ses}
	done
done

# Mennes
task=motor
rm ${wdr}/../LogFiles/Mennes_${task}_pipe
qsub -q long.q -N "${task}_Mennes_EuskalIBUR" \
-hold_jid "falff_${sub}_${ses}_EuskalIBUR" \
-o ${wdr}/../LogFiles/Mennes_${task}_pipe \
-e ${wdr}/../LogFiles/Mennes_${task}_pipe \
${wdr}/98.hcp/run_Mennes.sh ${task}