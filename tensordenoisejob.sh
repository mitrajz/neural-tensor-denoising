#!/bin/bash
#$ -S /bin/bash
#$ -l mem=8G,time=24:00:00
#$ -cwd
#$ -N td
#$ -j y
#$ -t 1-500
#$ -o /ifs/scratch/zmbbi/la_lab/jss2219/sge-output/
#$ -e /ifs/scratch/zmbbi/la_lab/jss2219/sge-error/

## Some Debugging info
echo "Your UNI: $USER"
echo “Starting on : $(date)”
echo “Running on node : $(hostname)”
echo “Current directory : $(pwd)”
echo “Current job ID : $JOB_ID”
echo “Current job name : $JOB_NAME”

#The following is the job to be performed:
/nfs/apps/matlab/2015a/bin/matlab -singleCompThread -nojvm -nodisplay -nosplash -r 'tensorDenoiseCluster($SGE_TASK_ID)' >/ifs/scratch/zmbbi/la_lab/jss2219/mat-outfile/matoutfile$SGE_TASK_ID

