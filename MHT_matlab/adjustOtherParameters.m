if strcmp(other_param.seq,'PETS2009')
    % use different parameters for the number of consecutive missing observation
    dummyNumberTH = [15 15 10 15 10];
    other_param.dummyNumberTH = dummyNumberTH(i);

    % set false alarm probability
    if other_param.is3Dtracking
        Vc = (-14069.6-4981.3)*(-14274.0-1733.5);
        other_param.pFalseAlarm = 1/(Vc*1.15);
    else
        Vc = 768*576;
        other_param.pFalseAlarm = 1/Vc;
    end

elseif strcmp(other_param.seq,'MOT_Challenge_train')
    Vc = [1920*1080 1920*1080 640*480 640*480 640*480 1242*375 1224*370 768*576 640*480 640*480 1920*1080];
    other_param.pFalseAlarm = 1/Vc(i);
    minDetScore = [20 20 3 3 3 10 10 0 0 0 10];
    other_param.minDetScore = minDetScore(i);
elseif strcmp(other_param.seq,'KITTI_train')
    Vc = [1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 ...
          1242*375 1224*370 1224*370 1224*370 1224*370 1238*374 1238*374 1241*376];
    other_param.pFalseAlarm = 1/Vc(i);
elseif strcmp(other_param.seq,'MOT_Challenge_test')
    Vc = [1920*1080 1920*1080 1920*1080 640*480 640*480 640*480 1224*370 1238*374 768*576 640*480 1920*1080];
    other_param.pFalseAlarm = 1/Vc(i);
    minDetScore = [20 20 0 3 3 3 10 10 0 0 10];% picked from training sequences
    other_param.minDetScore = minDetScore(i);
elseif strcmp(other_param.seq,'KITTI_test')
    Vc = [1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 1242*375 ...
          1242*375 1242*375 1242*375 1242*375 1224*370 1224*370 1224*370 1224*370 1224*370 1224*370 1224*370 1224*370 1224*370 ...
          1224*370 1226*370 1226*370];
    other_param.pFalseAlarm = 1/Vc(i);
end
