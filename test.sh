#! /bin/bash                                                                                                                     
#SBATCH -t 1:00:00                                                                                                              
#SBATCH --array=1,2,3,4,5,6,7                                                                                                    
#SBATCH -n 1                                                                                                                    
#SBATCH --ntasks=1                                                                                                              
#SBATCH --mem=4G                                                                                                                
#SBATCH -J NoisePipe                                                                                                             
#SBATCH -o NoisePipe_.out                                                                                                       
#SBATCH -e NoisePipe_.out 