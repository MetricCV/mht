import _setVariables as v
from _setVariables import _setVariables


def MHT(observation, kalman_param, other_param):
    observation, other_param = _setVariables(observation, other_param)
