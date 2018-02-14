import numpy as np


def _setVariables(observation, other_param):
    global firstFrame, lastFrame
    # set observations
    observation = cutDetections(observation, other_param)
    observation, other_param = selectAppFeat(observation, other_param)

    firstFrame = min(observation['fr'])
    lastFrame = max(observation['fr'])

    other_param['const'] = 10

    return (observation, other_param)


# declare variables
appTreeSet = []
obsTreeSet = []
stateTreeSet = []
scoreTreeSet = []
idTreeSet = []
incompabilityListTreeSet = []
incompabilityListTreeNodeIDSet = []
activeTreeSet = []
obsTreeSetConfirmed = []
stateTreeSetConfirmed = []
scoreTreeSetConfirmed = []
activeTreeSetConfirmed = []
selectedTrackIDs = []
trackFamilyPrev = []
trackIDtoRegInd = []
firstFrame = []
lastFrame = []
familyID = 1
trackID = np.uint64(1)
