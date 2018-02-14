import _setKalmanParameters as kp
import _setOtherParameters as op
import _setPathVariables as pv
from adjustOtherParameters import adjustOtherParameters
from loadDet import loadDet
from MHT import MHT

for i in range(len(pv.det_input_path)):
    adjustOtherParameters(i)

    # Load detections
    det = loadDet(pv.det_input_path[i], op.other_param)

    # Run MHT
    track = MHT(det, kp.kalman_param, op.other_param)
