import numpy as np


def cutDetections(det, other_param):
    del_idx = np.nonzero(det.r < other_param['minDetScore'])

    del_idx = list(del_idx[0])
    det = det.drop(del_idx)
    return det
