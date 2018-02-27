close all;
clear;

addpath(genpath('external'));
% CARGA DE PARAMETROS
% prepare parameters and file path
setKalmanParameters;
setOtherParameters;
setPathVariables;



for i = 1:length(det_input_path)
    % set a null hypothesis likelihood REVISAR DONDE OCURRE ESTO EN EL OTRO CODIGO
    adjustOtherParameters;

    % load detections
    det = loadDet(det_input_path{0}, other_param);
    % run MHT
    track = MHT(det, kalman_param, other_param);

    % save tracking output into images
    visTracks(track, other_param, img_input_path{i}, img_output_path{i}, max(det.fr));
end

