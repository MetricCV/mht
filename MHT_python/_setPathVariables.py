import _setOtherParameters as op

sequences = ['PETS2009', 'MOT_Challenge_train', 'KITTI_train',
             'MOT_Challenge_test', 'KITTI_test']

det_input_dir = ['input/PETS2009/', 'input/MOT_Challenge/train/',
                 'input/KITTI/train/', 'input/MOT_Challenge/test/',
                 'input/KITTI/test/']

img_output_dir = ['results/', 'results/', 'results/', 'results/', 'results/']

img_input_dir = [
    'Dataset/Crowd_PETS09/',
    '/home/chanho/Research/tracking/2015_ICCV/MOT_Challenge/2DMOT2015/train/',
    '/media/chanho/Extra_Drive/Research/Dataset/devkit_tracking/original_files/data_tracking_image_2/training/image_02/',
    '/home/chanho/Research/tracking/2015_ICCV/MOT_Challenge/2DMOT2015/test/',
    '/media/chanho/Extra_Drive/Research/Dataset/devkit_tracking/original_files/data_tracking_image_2/testing/image_02/'
]

img_input_subdir = [
    'S2/L1/Time_12-34/View_001/frame_%04d.jpg', 'S2/L2/Time_14-55/View_001/frame_%04d.jpg',
    'S2/L3/Time_14-41/View_001/frame_%04d.jpg', 'S1/L1/Time_13-59/View_001/frame_%04d.jpg',
    'S1/L2/Time_14-06/View_001/frame_%04d.jpg', 'ADL-Rundle-6/img1/%06d.jpg', 'ADL-Rundle-8/img1/%06d.jpg',
    'ETH-Bahnhof/img1/%06d.jpg', 'ETH-Pedcross2/img1/%06d.jpg', 'ETH-Sunnyday/img1/%06d.jpg',
    'KITTI-13/img1/%06d.jpg', 'KITTI-17/img1/%06d.jpg', 'PETS09-S2L1/img1/%06d.jpg',
    'TUD-Campus/img1/%06d.jpg', 'TUD-Stadtmitte/img1/%06d.jpg', 'Venice-2/img1/%06d.jpg',
    '0000/%06d.png', '0001/%06d.png', '0002/%06d.png', '0003/%06d.png', '0004/%06d.png', '0005/%06d.png',
    '0006/%06d.png', '0007/%06d.png', '0008/%06d.png', '0009/%06d.png', '0010/%06d.png', '0011/%06d.png',
    '0012/%06d.png', '0013/%06d.png', '0014/%06d.png', '0015/%06d.png', '0016/%06d.png', '0017/%06d.png',
    '0018/%06d.png', '0019/%06d.png', '0020/%06d.png', 'ADL-Rundle-1/img1/%06d.jpg', 'ADL-Rundle-3/img1/%06d.jpg',
    'AVG-TownCentre/img1/%06d.jpg', 'ETH-Crossing/img1/%06d.jpg', 'ETH-Jelmoli/img1/%06d.jpg',
    'ETH-Linthescher/img1/%06d.jpg', 'KITTI-16/img1/%06d.jpg', 'KITTI-19/img1/%06d.jpg', 'PETS09-S2L2/img1/%06d.jpg',
    'TUD-Crossing/img1/%06d.jpg', 'Venice-1/img1/%06d.jpg', '0000/%06d.png', '0001/%06d.png', '0002/%06d.png',
    '0003/%06d.png', '0004/%06d.png', '0005/%06d.png', '0006/%06d.png', '0007/%06d.png', '0008/%06d.png',
    '0009/%06d.png', '0010/%06d.png', '0011/%06d.png', '0012/%06d.png', '0013/%06d.png', '0014/%06d.png',
    '0015/%06d.png', '0016/%06d.png', '0017/%06d.png', '0018/%06d.png', '0019/%06d.png', '0020/%06d.png',
    '0021/%06d.png', '0022/%06d.png', '0023/%06d.png', '0024/%06d.png', '0025/%06d.png', '0026/%06d.png',
    '0027/%06d.png', '0028/%06d.png'
]

det_input_name = [
    'PETS2009-S2L1-c1-app_pca', 'PETS2009-S2L2-c1-app_pca', 'PETS2009-S2L3-c1-app_pca',
    'PETS2009-S1L1-2-c1-app_pca', 'PETS2009-S1L2-1-c1-app_pca', 'ADL-Rundle-6', 'ADL-Rundle-8',
    'ETH-Bahnhof', 'ETH-Pedcross2', 'ETH-Sunnyday', 'KITTI-13', 'KITTI-17', 'PETS09-S2L1', 'TUD-Campus',
    'TUD-Stadtmitte', 'Venice-2', '0000', '0001', '0002', '0003', '0004', '0005', '0006', '0007', '0008',
    '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020',
    'ADL-Rundle-1', 'ADL-Rundle-3', 'AVG-TownCentre', 'ETH-Crossing', 'ETH-Jelmoli', 'ETH-Linthescher',
    'KITTI-16', 'KITTI-19', 'PETS09-S2L2', 'TUD-Crossing', 'Venice-1', '0000', '0001', '0002', '0003',
    '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015',
    '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027','0028'
]

seq_idx = 0
while True:
    if op.other_param['seq'] == sequences[seq_idx]:
        break
    seq_idx = seq_idx + 1

input_idx = 0
if seq_idx == 0:
    input_idx = [x for x in range(1, 6)]
elif seq_idx == 1:
    input_idx = [x for x in range(6, 17)]
elif seq_idx == 2:
    input_idx = [x for x in range(17, 38)]
elif seq_idx == 3:
    input_idx = [x for x in range(38, 49)]
elif seq_idx == 4:
    input_idx = [x for x in range(49, 78)]
else:
    raise ValueError('unexpected sequence index')

det_input_path = list()
for i in range(len(input_idx)):
    det_input_path.append(det_input_dir[seq_idx] + det_input_name[input_idx[i]] + '.mat')

img_output_path = list()
img_input_path = list()
for i in range(len(input_idx)):
    if not op.other_param['appSel']:
        img_output_path.append(img_output_dir[seq_idx] +
                               sequences[seq_idx] + '/' +
                               det_input_name[input_idx[i]] + '/mot/')
    else:
        img_output_path.append(img_output_dir[seq_idx] +
                               sequences[seq_idx] + '/' +
                               det_input_name[input_idx[i]] + '/app/')

    img_input_path.append(img_input_dir[seq_idx] + img_input_subdir[input_idx[i]])

if op.other_param['seq'] == 'PETS2009':
    # ESTO NO LO HE HECHO
    # load input/PETS2009/PETS2009_S2L1_camera_parameters.mat;
    #op.other_param['camParam'] = camParam
    print('_setPathVariables.py still incomplete, line 95')
