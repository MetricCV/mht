import _setKalmanParameters as kp
import _setOtherParameters as op
import _setPathVariables as pv
from adjustOtherParameters import adjustOtherParameters
from loadDet import loadDet
from MHT import MHT

other_param = op.set_other_param()

# Testing
adjustOtherParameters(0)
# Load detections
det = loadDet(pv.det_input_path[0], other_param)
# Run MHT
MHT(det, kp.kalman_param, other_param)

# for i in range(len(pv.det_input_path)):
#     adjustOtherParameters(i)
#     # Load detections
#     det = loadDet(pv.det_input_path[i], other_param)
#     # Run MHT
#     MHT(det, kp.kalman_param, other_param)
