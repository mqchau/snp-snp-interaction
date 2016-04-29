# This file contains shared functions between my method and baseline method
import numpy as np

def read_datafile(filename):
    return np.loadtxt(filename, dtype=int, delimiter=",")
