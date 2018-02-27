from anytree import *
import pandas as pd
import numpy as np


def formTrackFamily(appTreeSet, obsTreeSet, stateTreeSet, scoreTreeSet,
                    idTreeSet, activeTreeSet, obsTreeSetConfirmed,
                    stateTreeSetConfirmed, scoreTreeSetConfirmed,
                    activeTreeSetConfirmed, selectedTrackIDs, det,
                    kalman_param, other_param, familyID, trackID,
                    trackIDtoRegInd, k):
    detNo = len(det)
    familyNO = len(obsTreeSetConfirmed)
    tree_df = pd.DataFrame(index=range(detNo))

    if(detNo != 0):
        tree_node = AnyNode(id="root", obsTreeSet=" ",
                            stateTreeSet=" ", scoreTreeSet=" ",
                            idTreeSet=" ", activeTreeSet=" ",
                            appTreeSet=" ")
        obsMembership = pd.DataFrame()
    else:
        obsMembership = []

    if other_param['isAppModel']:
        trackIDtoRegInd_new = []
        trackIDtoRegInd_tmp = []

    print("detNo: " + str(detNo)+"\n")
    for i in range(1, detNo):
        print(i)
        loglik = 1/other_param['const']
        if other_param['isAppModel']:
            indSel = list(range(1, detNo))
            indSel.remove(i)
            # appModel = encontrar libreria en python para el randfeat
        else:
            appModel = []
        if (other_param['is3DTracking'] == 0):

            kalman_init_adjusted = (((kalman_param['covWeight1'] *
                                     det['w'].iloc[i]) ** 2) *
                                    np.identity(kalman_param['ss']))

            print((kalman_param['covWeight1'] * det['w'].iloc[i]) ** 2)
    print("FIN CICLO FORM TRACK FAMILy\n")
    # print(obsMembership)
    # print(trackIDtoRegInd_new)
    # print(trackIDtoRegInd_tmp)
    # print(loglik)
    # print(indSel)
    # print(familyNO)
