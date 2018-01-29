%% select a seqeunce
other_param.seq = 'MOT_Challenge_train';
% other_param.seq = 'MOT_Challenge_test';
% other_param.seq = 'PETS2009';
% other_param.seq = 'KITTI_train';
% other_param.seq = 'KITTI_test';

%% MHT parameters                        % notation in the paper                              % comment
other_param.pDetection = 0.90;           % P_D
other_param.pFalseAlarm = 0.000001;      % measurement likelihood under the null hypthesis    Please refer to adjustOtherParameters.m or the paper to see how to set this parameter for different videos.
other_param.maxActiveTrackPerTree = 100; % B_{th}
other_param.dummyNumberTH = 15;          % N_{miss}
other_param.N = 5;                       % N (N scan)
other_param.MahalanobisDist = 12;        % d_{th}                                             set this parameter to 6 for motion-based tracking and 12 for motion+appearance-based tracking.


%% appearance parameters                 % notation in the paper                              % comment
other_param.appSel = 'cnn';              %                                                    (1)'cnn': CNN feature  (2)'': No appearnace
other_param.appW = 0.9;                  % w_{app}                                            When appearance is not used (i.e. other_param.appSel = ''), the appearance parameters are ignored.
other_param.motW = 0.1;                  % w_{mot} = 1-w_{app}
other_param.appTH = -0.8;                % c2
other_param.appNullprob = 0.3;           % c1


%% additional parameters
other_param.is3Dtracking = 0;            % set this parameter to 0 for 2D tracking (e.g. MOT) and 1 for 3D tracking (e.g. PETS)
other_param.minDetScore = 0;             % detection pruning. Detections whose confidence score is lower than this threshold are ignored.
other_param.confscTH = 5;                % confirmed track pruning (MOT). Confirmed tracks whose average detection confidence score is lower than this threshold are ignored.
% other_param.confscTH = 0.2;            % confirmed track pruning (PETS)
other_param.dummyRatioTH = 0.5;          % confirmed track pruning based on a ratio of the # of dummy observations to the # of total observations
other_param.minLegnthTH = 5;             % confirmed track pruning based on a track length
other_param.maxScaleDiff = 1.4;          % allowed bounding box scale difference between consecutive frames in each track. Set this parameter to > 1. For example, 1.4 means 40% scale change is allowed.