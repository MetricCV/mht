import numpy as np


def loadDet(det_input_path, other_param):
    # Don't know  what to do here
    # variable dres brought by det_input_path apparently
    # load(det_input_path)
    print(det_input_path)

    if other_param['seq'] == 'PETS2009':
        det = dres

        if not other_param['is3DTracking']:
            det['x'] = det['bx'] + det['w'] / 2
            det['y'] = det['by'] + det['h'] / 2
    elif not other_param['is3DTracking']:
        det['x'] = det['x'] + det['w'] / 2
        det['y'] = det['y'] + det['h'] / 2

    if 'r' not in det:
        det['r'] = np.ones(len(det['x']), 1)
