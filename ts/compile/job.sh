#PBS -N CCOSFIRE-test[NODE]
#PBS -l walltime=00:[MIN]:00
#PBS -l nodes=1:ppn=1
#PBS -j oe
cd $PBS_O_WORKDIR
cd ..
./callTesting [NODE]