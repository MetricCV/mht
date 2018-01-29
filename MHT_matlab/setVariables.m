%% set observations
observation = cutDetections(observation,other_param);
[observation other_param] = selectAppFeat(observation, other_param);


%% declare variables
appTreeSet = [];
obsTreeSet = [];
stateTreeSet = [];
scoreTreeSet = [];
idTreeSet = [];
incompabilityListTreeSet = [];
incompabilityListTreeNodeIDSet = [];
activeTreeSet = [];
obsTreeSetConfirmed = [];
stateTreeSetConfirmed = [];
scoreTreeSetConfirmed = [];
activeTreeSetConfirmed = [];
selectedTrackIDs = [];
trackFamilyPrev = [];
trackIDtoRegInd = [];
firstFrame = min(observation.fr);
lastFrame = max(observation.fr);
familyID = 1;
trackID = uint64(1);


%% graph solver
other_param.const = 10;