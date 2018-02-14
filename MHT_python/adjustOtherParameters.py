import _setOtherParameters as op


def adjustOtherParameters(i):
    if op.other_param['seq'] == 'PETS2009':
        dummyNumberTH = [15, 15, 10, 15, 10]
        op.other_param['dummyNumberTH'] = dummyNumberTH[i]

        if op.other_param['is3DTracking']:
            vc = (-14069.6 - 4981.3) * (-14274.0 - 1733.5)
            op.other_param['pFalseAlarm'] = 1/(vc * 1.15)
        else:
            vc = 768 * 576
            op.other_param['pFalseAlarm'] = 1/vc

    elif op.other_param['seq'] == 'MOT_Challenge_train':
        vc = [1920*1080, 1920*1080, 640*480, 640*480, 640*480, 1242*375,
              1224*370, 768*576, 640*480, 640*480, 1920*1080]
        op.other_param['pFalseAlarm'] = 1/vc[i]
        minDetScore = [20, 20, 3, 3, 3, 10, 10, 0, 0, 0, 10]
        op.other_param['minDetScore'] = minDetScore[i]

    elif op.other_param['seq'] == 'KITTI_train':
        vc = [1242*375, 1242*375, 1242*375, 1242*375, 1242*375, 1242*375,
              1242*375, 1242*375, 1242*375, 1242*375, 1242*375, 1242*375,
              1242*375, 1242*375, 1224*370, 1224*370, 1224*370, 1224*370,
              1238*374, 1238*374, 1241*376]
        op.other_param['pFalseAlarm'] = 1/vc[i]

    elif op.other_param['seq'] == 'MOT_Challenge_test':
        vc = [1920*1080, 1920*1080, 1920*1080, 640*480, 640*480, 640*480,
              1224*370, 1238*374, 768*576, 640*480, 1920*1080]
        op.other_param['pFalseAlarm'] = 1/vc[i]
        minDetScore = [20, 20, 0, 3, 3, 3, 10, 10, 0, 0, 10]
        op.other_param['minDetScore'] = minDetScore[i]

    elif op.other_param['seq'] == 'KITTI_test':
        vc = [1242*375, 1242*375, 1242*375, 1242*375, 1242*375, 1242*375,
              1242*375, 1242*375, 1242*375, 1242*375, 1242*375, 1242*375,
              1242*375, 1242*375, 1242*375, 1242*375, 1242*375, 1224*370,
              1224*370, 1224*370, 1224*370, 1224*370, 1224*370, 1224*370,
              1224*370, 1224*370, 1224*370, 1226*370, 1226*370]
        op.other_param['pFalseAlarm'] = 1/vc[i]
