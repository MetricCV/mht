import numpy as np
from cutDetections import cutDetections
from selectAppFeat import selectAppFeat
import pandas as pd


def _setVariables(det, other_param):
    # set observations
    det = cutDetections(det, other_param)
    det, other_param = selectAppFeat(det, other_param)

    other_param['const'] = 10
    return (det, other_param)


# declare variables
appTreeSet = pd.DataFrame()
obsTreeSet = pd.DataFrame()
stateTreeSet = pd.DataFrame()
scoreTreeSet = pd.DataFrame()
idTreeSet = pd.DataFrame()
incompabilityListTreeSet = pd.DataFrame()
incompabilityListTreeNodeIDSet = pd.DataFrame()
activeTreeSet = pd.DataFrame()
obsTreeSetConfirmed = pd.DataFrame()
stateTreeSetConfirmed = pd.DataFrame()
scoreTreeSetConfirmed = pd.DataFrame()
activeTreeSetConfirmed = pd.DataFrame()
selectedTrackIDs = pd.DataFrame()
trackFamilyPrev = pd.DataFrame()
trackIDtoRegInd = []
familyID = 1
trackID = np.uint64(1)
