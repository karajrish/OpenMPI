# OpenMPI
Implementing common computational algorithms on a multi node cluster

1) cd into the directory

2) Configure the installation file

./configure --prefix="/home/$USER/.openmpi"

3) Install OpenMPI (This path will take time to complete)

make

sudo make install

4)Setup path in Environment Variable

export PATH="$PATH:/home/$USER/.openmpi/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.openmpi/lib/"
 
5) Test if install was successful

mpirun

