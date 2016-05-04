# --------------------------------------------------
# This script will generate artificial data file to run snp-snp interaction algorithm
# Arguments:
# - num_snp: Number of snp to generate
# - num_case: Number of cases sample size
# - num_control: Number of control sample size
# - correct_snp: array of snp index that we want to target.
#     These snp will get constant value of 1 or 0 for all cases
# --------------------------------------------------
import numpy as np
from random import randint
import random

if __name__ == "__main__":
    num_snp = 100
    num_case = 100
    percent_perfect_correlation = 0.9
    target_snp = [10,15]

    data_array = np.zeros((num_case, num_snp), dtype=np.uint8)

    # generate the case sample, control sample are not necessary
    # for now let's just assume snp1 and snp2 must be 1,1 together to activate
    for i in range(num_case):
        for j in range(num_snp):
            if j not in target_snp or random.random() > percent_perfect_correlation:
                data_array[i,j] = randint(0,1) 
            else:
                data_array[i,j] = 1

    np.savetxt("datafile/sample1.csv", data_array, delimiter=",", fmt='%i')
    
