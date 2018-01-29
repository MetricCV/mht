kalman_param.ss = 4; % state size
kalman_param.os = 2; % observation size
kalman_param.F = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];
kalman_param.H = [1 0 0 0; 0 1 0 0];

%% 3D tracking parameters (only used for 3D tracking. e.g. PETS2009)
kalman_param.Q = 25000*eye(kalman_param.ss);
kalman_param.R = 25000*eye(kalman_param.os);
kalman_param.initV = 25000*eye(kalman_param.ss);

kalman_param.Q(3,3) = 200;
kalman_param.Q(4,4) = 200;
kalman_param.initV(3,3) = 200;
kalman_param.initV(4,4) = 200;

%% 2D tracking parameters (used for MOT). Q, R and initV are automatically set.
kalman_param.covWeight1 = 1/10;
kalman_param.covWeight2 = 0.0125;

