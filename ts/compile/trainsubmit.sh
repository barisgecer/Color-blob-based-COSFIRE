#PBS -N CCOSFIRE-Training
#PBS -l nodes=1:ppn=1
#PBS -j oe
cd $PBS_O_WORKDIR
./callTraining