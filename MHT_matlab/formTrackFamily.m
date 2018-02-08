function [appTreeSetNew obsTreeSetNew stateTreeSetNew scoreTreeSetNew idTreeSetNew activeTreeSetNew obsTreeSetConfirmed stateTreeSetConfirmed scoreTreeSetConfirmed activeTreeSetConfirmed familyID trackID treeDel treeConfirmed obsMembership trackIDtoRegInd] = formTrackFamily(appTreeSetPrev, obsTreeSetPrev, stateTreeSetPrev, scoreTreeSetPrev, idTreeSetPrev, activeTreeSetPrev, ...
                                                                                                                                                                                                        obsTreeSetConfirmed, stateTreeSetConfirmed, scoreTreeSetConfirmed, activeTreeSetConfirmed,...
                                                                                                                                                                                                        selectedTrackIDs, cur_observation, kalman_param, other_param, familyID, trackID, trackIDtoRegInd, cur_time)
    
    observationNo = length(cur_observation.x);
    familyNo = length(obsTreeSetPrev);
    
    if observationNo ~= 0
        obsTreeSet(observationNo,1) = tree;
        stateTreeSet(observationNo,1) = tree;
        scoreTreeSet(observationNo,1) = tree;
        idTreeSet(observationNo,1) = tree;
        activeTreeSet(observationNo,1) = tree;
        appTreeSet(observationNo,1) = tree;    
        obsMembership = cell(length(cur_observation.x),1);  
    else
        obsTreeSet = [];
        stateTreeSet = [];
        scoreTreeSet = [];
        idTreeSet = [];
        activeTreeSet = [];
        appTreeSet = [];    
        obsMembership = [];  
    end
    
    if other_param.isAppModel
        trackIDtoRegInd_new = []; 
        trackIDtoRegInd_tmp = [];        
    end
    
    % start new tracks
    ct = 1;       
    for i = 1:observationNo                             
            % initialize track score
            loglik = 1*(1/other_param.const);
%             loglik = log(cur_observation.sc(i)/(1-cur_observation.sc(i)+eps));

            if other_param.isAppModel                                                           
                % initialize an appearance model          
                indSel = setdiff(1:observationNo,i);  
                appModel = LinearRegressor_Data([cur_observation.app(i,:) ; cur_observation.app(indSel,:)], [1; -1*ones(length(indSel),1)]); 
            else
                appModel = [];
            end
            
            % set the initial error cov by the width of the bounding box 
            if ~other_param.is3Dtracking
                kalman_initV_adjusted = (kalman_param.covWeight1*cur_observation.w(i))^2*eye(kalman_param.ss);
                kalman_initV_adjusted(3,3) = kalman_param.covWeight2*cur_observation.w(i);
                kalman_initV_adjusted(4,4) = kalman_param.covWeight2*cur_observation.w(i);             
            else
                kalman_initV_adjusted = kalman_param.initV;
            end
                        
            stateEstimate = [cur_observation.x(i); cur_observation.y(i); 0; 0];
            obsTreeSet(ct) = tree([cur_observation.x(i) cur_observation.y(i) cur_observation.w(i) cur_observation.h(i) cur_observation.fr(i) 1 0 0 1]);       % last four elements : (1) the number of observation nodes (2) the number of dummy nodes (3) the number of total dummy nodes (4) a dummy node indicator        
            stateTreeSet(ct) = tree([stateEstimate kalman_initV_adjusted]);      
            scoreTreeSet(ct) = tree([loglik cur_observation.sc(i)]);
            idTreeSet(ct) = tree([familyID trackID]);  % [familyID trackID]
            activeTreeSet(ct) = tree(1);
            appTreeSet(ct) = tree(appModel);
            
            obsMembership{i} = [obsMembership{i}; [familyID 1 trackID]]; % [familyID branchIndex trackID]   
            
            % save a mapping between trackID and regressorIndex
            if other_param.isAppModel
                trackIDtoRegInd_new = [trackIDtoRegInd_new; familyID trackID 1]; % [familyID trackID regressorIndex]
            end
            
            familyID = familyID + 1;       
            trackID = trackID + uint64(1);
            ct = ct+1;
    end
    
    % update tracks with a new observation or a dummy observation. 
    treeDel = [];   
    treeConfirmed = [];
    for i = 1:familyNo
        treeInd = findleaves(obsTreeSetPrev(i));
        tabuList = zeros(1,length(treeInd));
        ct1 = 0; 
        ct2 = 0;
        
        if other_param.isAppModel 
            key_index = [];
            regInd_to_obsInd = [];
            appModelPointer = [];            
            reg = 0; 
            ind_ct = 1;
            regSize = 0;
            regPastSize = 0;
        end
        
        for j = 1:length(treeInd)                      
            
           % check if a track is active
           if activeTreeSetPrev(i).get(treeInd(j)) == 0
               tabuList(j) = treeInd(j);
               continue;
           end
            
           % update with a dummy observation
           L1_prev = appTreeSetPrev(i).get(treeInd(j));
           previousObservation = obsTreeSetPrev(i).get(treeInd(j));
           stateEstimate = stateTreeSetPrev(i).get(treeInd(j));         
           statePredict_missOBS = kalman_param.F*stateEstimate(:,1);       
           scoreSel = scoreTreeSetPrev(i).get(treeInd(j));      
           loglik = scoreSel(1);
           confsc = scoreSel(2);
           
           ID_tmp = idTreeSetPrev(i).get(treeInd(j));
           familyID_tmp = ID_tmp(1);
           trackID_tmp = ID_tmp(2);
           obsNo = previousObservation(6);
           dummyNo = previousObservation(7)+1;
           totalDummyNo = previousObservation(8)+1;                      
           
%            % error check
%            if other_param.isAppModel
%               regSize = size(L1_prev.InputTarget,2);
%               
%               if regSize ~= regPastSize && reg == 1
%                  error('something wrong');
%               end
%               
%               regPastSize = regSize;
%            end
           
           % set the error cov by the width of the bounding box 
           if ~other_param.is3Dtracking
                kalman_Q_adjusted = (kalman_param.covWeight1*previousObservation(3))^2*eye(kalman_param.ss);
                kalman_Q_adjusted(3,3) = kalman_param.covWeight2*previousObservation(3);
                kalman_Q_adjusted(4,4) = kalman_param.covWeight2*previousObservation(3);  
           else
                kalman_Q_adjusted = kalman_param.Q;
           end
           
           % if the track is not confirmed yet
           if dummyNo < other_param.dummyNumberTH               
               % add penalty 
               loglik = max(loglik + (1/other_param.const)*log(1-other_param.pDetection),1*(1/other_param.const)); 

               vPredict = kalman_param.F*stateEstimate(:,2:5)*kalman_param.F' + ((other_param.dummyNumberTH-dummyNo)/other_param.dummyNumberTH)*kalman_Q_adjusted;       
               statePredict = statePredict_missOBS;                             
           else               
               statePredict = statePredict_missOBS;
               vPredict = stateEstimate(:,2:5); 
           end
                      
           appTreeSetPrev(i) = appTreeSetPrev(i).addnode(treeInd(j),{L1_prev});
           obsTreeSetPrev(i) = obsTreeSetPrev(i).addnode(treeInd(j),[previousObservation(1) previousObservation(2) previousObservation(3) previousObservation(4) cur_time obsNo dummyNo totalDummyNo NaN]); 
           stateTreeSetPrev(i) = stateTreeSetPrev(i).addnode(treeInd(j),[statePredict vPredict]);
           scoreTreeSetPrev(i) = scoreTreeSetPrev(i).addnode(treeInd(j),[loglik confsc]);
           idTreeSetPrev(i) = idTreeSetPrev(i).addnode(treeInd(j),[familyID_tmp trackID_tmp]);          
           
           if sum(selectedTrackIDs == trackID_tmp) ~= 1
               activeTreeSetPrev(i) = activeTreeSetPrev(i).addnode(treeInd(j), 0);
           else
               activeTreeSetPrev(i) = activeTreeSetPrev(i).addnode(treeInd(j), 1);
           end                      
           
           if observationNo ~= 0
           
           % get a regression weight matrix. this is done once for each track tree
           if other_param.isAppModel && reg == 0
              appModelPointer = L1_prev;
              regWeight = L1_prev.Regress(10); 
              reg  = 1;
           end
           
           % extrack a weight vector corresponding to a selected tree branch
           if other_param.isAppModel
              regIndSel = trackIDtoRegInd(trackIDtoRegInd(:,2) == trackID_tmp,3); 
              
              if length(regIndSel) ~= 1
                  error('There is not the requested track or there exist mulitple instances of the requested track');
              end
              
              if iscell(regWeight)
                  regWeightSel = regWeight{regIndSel};
              else                  
                  regWeightSel = regWeight(:,regIndSel);
              end   
              vbar = regWeightSel(1) + cur_observation.app*regWeightSel(2:end);
              
              % appearance-based pruning 
              obsSel = vbar >= other_param.appTH;   
           else
              vbar = [];
              obsSel = [];
           end
                     
           % update with a new observation if a track is not confirmed yet
           if dummyNo < other_param.dummyNumberTH               
               [appTreeSetPrev(i) obsTreeSetPrev(i), stateTreeSetPrev(i), scoreTreeSetPrev(i), idTreeSetPrev(i) activeTreeSetPrev(i) trackID obsUsed] = updateNewObservation(appTreeSetPrev(i),obsTreeSetPrev(i),stateTreeSetPrev(i),scoreTreeSetPrev(i),idTreeSetPrev(i),activeTreeSetPrev(i), ...
                                                                                                            treeInd(j),cur_observation,kalman_param,other_param,familyID_tmp,trackID,obsSel,vbar); 
               
               
               % save observation memberships for speeding up the updateICL function
               tryInd = find(obsUsed(:,1));
               for k = 1:length(tryInd)
                   obsMembership{tryInd(k)} = [obsMembership{tryInd(k)}; [i obsUsed(tryInd(k),2:3)]]; % [familyID branchIndex trackID]
               end                              
               
           elseif confsc/obsNo <= other_param.confscTH || (totalDummyNo-dummyNo)/(obsNo+totalDummyNo-dummyNo) >= other_param.dummyRatioTH
               ct1 = ct1+1;
           else
               ct2 = ct2+1; % count good tracks that have been confirmed
           end
                      
           if other_param.isAppModel
               if dummyNo < other_param.dummyNumberTH 
                   key_index(ind_ct) = trackID_tmp;
                   regInd_to_obsInd{ind_ct} = tryInd;
                   obsUsedTable{ind_ct} = obsUsed;
                   ind_ct = ind_ct + 1;
               else    
                   key_index(ind_ct) = trackID_tmp;
                   regInd_to_obsInd{ind_ct} = [];
                   obsUsedTable{ind_ct} = [];
                   ind_ct = ind_ct + 1;
               end 
           end
           
           appTreeSetPrev(i) = appTreeSetPrev(i).set(treeInd(j),[]);           
           end
           
        end
        
        % update appearance model 
        if other_param.isAppModel && ~isempty(key_index) && observationNo ~= 0                  
            InputTarget_tmp = appModelPointer.InputTarget;                        
            InputTarget_new = [];
            V_new = [];
            regCT = 0;
            for k = 1:length(key_index)
                regInd = trackIDtoRegInd(trackIDtoRegInd(:,2) == key_index(k),3);
                obsInd = regInd_to_obsInd{k};
                appParent = InputTarget_tmp(:,regInd);                                               
                regIndList = regCT + (1:(length(obsInd)+1));
                regIndList = regIndList';
                
                if ~isempty(obsInd)
                    trackIDList = [key_index(k); obsUsedTable{k}(obsInd,3)];
                else
                    trackIDList = [key_index(k)];
                end
     
                InputTarget_new = [InputTarget_new repmat(appParent,1,length(obsInd)+1)];
                V_new_tmp = -1*ones(observationNo,length(obsInd)+1);
                for kk = 1:length(obsInd)                      
                   V_new_tmp(obsInd(kk),kk+1) = 1; 
                end                    
                V_new = [V_new V_new_tmp];                               
                
                trackIDtoRegInd_tmp = [trackIDtoRegInd_tmp; i*ones(length(obsInd)+1,1) trackIDList regIndList];
                
                regCT = regCT + length(obsInd) + 1;
            end
            
            if regCT ~= size(InputTarget_new,2)
                error('something wrong');
            end
                                             
            appModelPointer = appModelPointer.renew_targets(InputTarget_new);                           
            appModelPointer = appModelPointer + LinearRegressor_Data(cur_observation.app, V_new);                
        end
        
        % tree deletion 
        tabuList = tabuList(tabuList ~= 0);        
        if ct1 == length(treeInd) - length(tabuList)  
            % tree deletion when all tree branches are dead
            treeDel = [treeDel; i]; 
        % tree confirmation
        elseif ct2 == length(treeInd) - length(tabuList) && ct2 == 1            
            treeConfirmed = [treeConfirmed; i];
        % branch pruning
        else 
            % prune track branches based on its score
            activeTreeSetPrev(i) = activateTrackBranch(scoreTreeSetPrev(i),obsTreeSetPrev(i),activeTreeSetPrev(i),other_param,cur_time);            
        end
    end       
    
    obsTreeSetConfirmed = [obsTreeSetPrev(treeConfirmed); obsTreeSetConfirmed];
    stateTreeSetConfirmed = [stateTreeSetPrev(treeConfirmed); stateTreeSetConfirmed];       
    scoreTreeSetConfirmed = [scoreTreeSetPrev(treeConfirmed); scoreTreeSetConfirmed];    
    activeTreeSetConfirmed = [activeTreeSetPrev(treeConfirmed); activeTreeSetConfirmed];
    
    obsTreeSetNew = [obsTreeSetPrev; obsTreeSet];
    stateTreeSetNew = [stateTreeSetPrev; stateTreeSet];       
    scoreTreeSetNew = [scoreTreeSetPrev; scoreTreeSet];    
    idTreeSetNew = [idTreeSetPrev; idTreeSet];
    activeTreeSetNew = [activeTreeSetPrev; activeTreeSet];
    appTreeSetNew = [appTreeSetPrev; appTreeSet];
    
    if other_param.isAppModel && observationNo ~= 0
        trackIDtoRegInd = [trackIDtoRegInd_tmp; trackIDtoRegInd_new];   
    end
end

