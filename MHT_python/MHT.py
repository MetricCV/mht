import _setVariables as sv
import numpy as np
from formTrackFamily import formTrackFamily


def MHT(det, kalman_param, other_param):
    det, other_param = sv._setVariables(det, other_param)
    firstFrame = min(det['fr'])
    lastFrame = max(det['fr'])
    print("The number of loops in MHT is from " + str(min(det['fr'])) +
          " to " + str(max(det['fr'])) +
          " and the lenght of the detections is " + str(len(det)))

    for k in range(firstFrame, lastFrame + 1):
        if(k in list(det['fr'])):
            print("k: "+str(k))

            idx = np.nonzero(det.fr == k)
            idx = idx[0]
            print("idx: " + str(idx))
            mht_det = det.loc[idx, :]

            if other_param['isAppModel']:
                mht_det.app = det['app'].iloc[idx]

            print("updating track trees at time "+str(k))
            print(mht_det)
            formTrackFamily(sv.appTreeSet, sv.obsTreeSet, sv.stateTreeSet,
                            sv.scoreTreeSet, sv.idTreeSet, sv.activeTreeSet,
                            sv.obsTreeSetConfirmed, sv.stateTreeSetConfirmed,
                            sv.scoreTreeSetConfirmed, sv.activeTreeSetConfirmed,
                            sv.selectedTrackIDs, mht_det, kalman_param,
                            other_param, sv.familyID, sv.trackID,
                            sv.trackIDtoRegInd, k)
