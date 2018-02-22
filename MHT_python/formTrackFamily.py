from anytree import *
import pandas as pd


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

    for i in range(1, detNo):
        print(i)
        loglik = 1/other_param['const']
        if other_param['isAppModel']:
            indSel = list(range(1, detNo))
            indSel.remove(i)

    # print(obsMembership)
    # print(trackIDtoRegInd_new)
    # print(trackIDtoRegInd_tmp)
    # print(loglik)
    # print(indSel)
    # print(familyNO)
