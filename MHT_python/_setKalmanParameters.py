import numpy as np

kalman_param = {
    'ss': 4,
    'os': 2,
    'F': [[1, 0, 1, 0], [0, 1, 0, 1], [0, 0, 1, 0], [0, 0, 0, 1]],
    'H': [[1, 0, 0, 0], [0, 1, 0, 0]]
}

# print(kalman_param)

# 3D Tracking Parameters
kalman_param['Q'] = 25000 * np.identity(kalman_param['ss'])
kalman_param['R'] = 25000 * np.identity(kalman_param['os'])
kalman_param['initV'] = 25000 * np.identity(kalman_param['ss'])

kalman_param['Q'][2, 2] = 200
kalman_param['Q'][3, 3] = 200
kalman_param['initV'][2, 2] = 200
kalman_param['initV'][3, 3] = 200

kalman_param['covWeight1'] = 1/10
kalman_param['covWeight2'] = 0.0125
