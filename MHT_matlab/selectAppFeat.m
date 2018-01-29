function [cur_observation other_param] = selectAppFeat(cur_observation, other_param)

switch other_param.appSel
    case 'cnn'
        cur_observation.app = cur_observation.cnn;
        other_param.isAppModel = 1;
    otherwise
        cur_observation.app = [];
        other_param.isAppModel = 0;
end
       
end