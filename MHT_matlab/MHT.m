function track = MHT(observation, kalman_param, other_param)

setVariables;

%% start MHT
for k = firstFrame:lastFrame

    % observation at time k
    idx = find(observation.fr == k);
    cur_observation.x = observation.x(idx);
    cur_observation.y = observation.y(idx);
    cur_observation.bx = observation.bx(idx);
    cur_observation.by = observation.by(idx);
    cur_observation.w = observation.w(idx);
    cur_observation.h = observation.h(idx);
    cur_observation.sc = observation.r(idx);
    cur_observation.fr = observation.fr(idx);

    if other_param.isAppModel
        cur_observation.app = observation.app(idx,:);
    end

    if strcmp(other_param.seq,'MOT_Challenge_train') || strcmp(other_param.seq,'MOT_Challenge_test')
       cur_observation = NMS(cur_observation, other_param);
    end

    % build and update track families
    disp(sprintf('\nUpdating track trees at time %d',k));
    [appTreeSet obsTreeSet stateTreeSet scoreTreeSet idTreeSet activeTreeSet obsTreeSetConfirmed stateTreeSetConfirmed scoreTreeSetConfirmed activeTreeSetConfirmed familyID trackID treeDel treeConfirmed obsMembership trackIDtoRegInd] = formTrackFamily(appTreeSet, obsTreeSet, stateTreeSet, scoreTreeSet, idTreeSet, activeTreeSet,...
                                                                                                                                                                                                                                   obsTreeSetConfirmed, stateTreeSetConfirmed, scoreTreeSetConfirmed, activeTreeSetConfirmed,...
                                                                                                                                                                                                                                   selectedTrackIDs, cur_observation, kalman_param, other_param, familyID, trackID, trackIDtoRegInd, k);

    % update the incompability list
    disp(sprintf('\nUpdating the incompability list at time %d',k));
    [incompabilityListTreeSet incompabilityListTreeNodeIDSet]= updateICL(obsTreeSet, idTreeSet, incompabilityListTreeNodeIDSet, activeTreeSet, cur_observation, obsMembership);


    % update the clusters
    disp(sprintf('\nUpdating clusters at time %d',k));
    [clusters ICL_clusters other_param] = updateClusters(incompabilityListTreeSet, incompabilityListTreeNodeIDSet, activeTreeSet, other_param);


    % generate the global hypothesis
    disp(sprintf('\nGenerating the global hypothesis at time %d',k));
    [bestHypothesis bestScore trackIndexInTrees selectedTrackIDs] = generateGlobalHypothesis(scoreTreeSet, idTreeSet, incompabilityListTreeSet, clusters, ICL_clusters, selectedTrackIDs, other_param);    
    
    % save the output
    if k == lastFrame
        track = getTracksFromHypothesis(bestHypothesis, bestScore, trackIndexInTrees, obsTreeSet, stateTreeSet, scoreTreeSet, obsTreeSetConfirmed, stateTreeSetConfirmed, scoreTreeSetConfirmed, activeTreeSetConfirmed, treeConfirmed, clusters, other_param);
        track = getFinalTracks(track, kalman_param, other_param);
    end

    % N scan pruning
    disp(sprintf('\nRunning N scan pruning at time %d',k));
    [appTreeSet, obsTreeSet, stateTreeSet, scoreTreeSet, idTreeSet, incompabilityListTreeNodeIDSet, activeTreeSet, familyID, trackFamilyPrev, trackIDtoRegInd] = nScanPruning(bestHypothesis, trackIndexInTrees, appTreeSet, obsTreeSet, ...
                                                                                                                                            stateTreeSet, scoreTreeSet, idTreeSet, incompabilityListTreeSet, ...
                                                                                                                                            incompabilityListTreeNodeIDSet, activeTreeSet, familyID, treeDel, treeConfirmed, trackFamilyPrev, other_param, trackIDtoRegInd, k);                                                                                                                                         
end

