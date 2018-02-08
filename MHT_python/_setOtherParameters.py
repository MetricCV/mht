# Select a sequence
other_param = {
  'seq': 'PETS2009'
}

# MHT Parameters
other_param['pDetection'] = 0.9
other_param['pFalseAlarm'] = 0.000001
other_param['maxActiveTrackPerTree'] = 100
other_param['dummyNumberTH'] = 15
other_param['N'] = 5
other_param['MahalanobisDist'] = 12

# Appearance parameters
other_param['appSel'] = 'cnn'
other_param['appW'] = 0.9
other_param['motW'] = 0.1
other_param['appTH'] = -0.8
other_param['appNullProb'] = 0.3

# Additional parameters
other_param['is3DTracking'] = 0
other_param['minDetScore'] = 0
other_param['confscTH'] = 0.2
other_param['dummyRatioTH'] = 0.5
other_param['minLengthTH'] = 5
other_param['maxScaleDiff'] = 1.4
