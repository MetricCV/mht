

def selectAppFeat(det, other_param):
    if(other_param['appSel'] == 'cnn'):
        det['app'] = det['cnn']
        other_param['isAppModel'] = 1
    else:
        det['app'] = []
        other_param['isAppModel'] = 0
    print('pasamos')
    return det, other_param
