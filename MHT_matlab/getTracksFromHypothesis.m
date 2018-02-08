function tracks = getTracksFromHypothesis(bestHypothesis, bestScore, trackIndexInTrees, obsTreeSet, stateTreeSet, scoreTreeSet, obsTreeSetConfirmed, stateTreeSetConfirmed, scoreTreeSetConfirmed, activeTreeSetConfirmed, treeConfirmed, clusters, other_param)

id = 1;
tracks.x = [];
tracks.y = [];
tracks.x_hat = [];
tracks.y_hat = [];
tracks.w = [];
tracks.h = [];
tracks.fr = [];
tracks.id = [];
tracks.sc = [];
tracks.isdummy = [];

% collect confirmed tracks
for i = 1:length(obsTreeSetConfirmed)
    
    treeInd = findleaves(obsTreeSetConfirmed(i));
    
    IndSel = 0;
    ct = 0;
    for j = 1:length(treeInd)
        if activeTreeSetConfirmed(i).get(treeInd(j)) == 1
           IndSel = treeInd(j);
           ct = ct+1;           
        end
    end
    
    % a confirmed tree has only one track branch
    if ct ~= 1
       error('error in a confirmed tree');       
    end
    
    tracks_tmp = collectTrack(obsTreeSetConfirmed, stateTreeSetConfirmed, scoreTreeSetConfirmed, i, IndSel, id, other_param);
    tracks.x = [tracks.x; tracks_tmp.x];
    tracks.y = [tracks.y; tracks_tmp.y];
    tracks.x_hat = [tracks.x_hat; tracks_tmp.x_hat];
    tracks.y_hat = [tracks.y_hat; tracks_tmp.y_hat];
    tracks.w = [tracks.w; tracks_tmp.w];
    tracks.h = [tracks.h; tracks_tmp.h];
    tracks.fr = [tracks.fr; tracks_tmp.fr];
    tracks.id = [tracks.id; tracks_tmp.id];
    tracks.sc = [tracks.sc; tracks_tmp.sc];
    tracks.isdummy = [tracks.isdummy; tracks_tmp.isdummy];
    id = id+1;

end

for i = 1:length(clusters)
     scoreTmp = bestScore{i};
     curBestScore = 0;
     idxSel = 1;
     for j = 1:size(bestHypothesis{i},1)        
        if curBestScore < sum(scoreTmp(~~bestHypothesis{i}(j,:)))
            idxSel = j;
            curBestScore = sum(scoreTmp(~~bestHypothesis{i}(j,:)));
        end
     end

     ind = find(bestHypothesis{i}(idxSel,:) == 1);      
     for k = 1:length(ind)          
         treeInd = trackIndexInTrees{i}(ind(k),:);      
         
         % skip confirmed trees
         if sum(treeConfirmed == treeInd(1)) == 1
             continue;
         end
         
         tracks_tmp = collectTrack(obsTreeSet, stateTreeSet, scoreTreeSet, treeInd(1),treeInd(2), id, other_param);
         tracks.x = [tracks.x; tracks_tmp.x];
         tracks.y = [tracks.y; tracks_tmp.y];
         tracks.x_hat = [tracks.x_hat; tracks_tmp.x_hat];
         tracks.y_hat = [tracks.y_hat; tracks_tmp.y_hat];
         tracks.w = [tracks.w; tracks_tmp.w];
         tracks.h = [tracks.h; tracks_tmp.h];
         tracks.fr = [tracks.fr; tracks_tmp.fr];
         tracks.id = [tracks.id; tracks_tmp.id];
         tracks.sc = [tracks.sc; tracks_tmp.sc];
         tracks.isdummy = [tracks.isdummy; tracks_tmp.isdummy];
         id = id+1;
     end        
   
end

end

function track = collectTrack(obsTreeSet, stateTreeSet, scoreTreeSet, familyID, nodeID, id, other_param)

track.x = [];
track.y = [];
track.x_hat = [];
track.y_hat = [];
track.w = [];
track.h = [];
track.fr = [];
track.id = [];
track.sc = [];
track.isdummy = [];

parentNodeID = 1;

while parentNodeID ~= 0
    
    xy = obsTreeSet(familyID).get(nodeID);    
    xy_state = stateTreeSet(familyID).get(nodeID);
    xy_state = xy_state(:,1:5:end)';
    
    if parentNodeID == 1
       score = scoreTreeSet(familyID).get(nodeID); 
       score = score(2);
    end
    
    if other_param.is3Dtracking
        [x_state y_state]=projectToImage(xy_state(:,1),xy_state(:,2),other_param.camParam);  
        track.x = [xy(end:-1:1,1); track.x];
        track.y = [xy(end:-1:1,2); track.y];
        track.x_hat = [x_state(end:-1:1); track.x_hat];
        track.y_hat = [y_state(end:-1:1); track.y_hat];
        track.w = [xy(end:-1:1,3); track.w];
        track.h = [xy(end:-1:1,4); track.h];
        track.fr = [xy(end:-1:1,5); track.fr];
        track.id = [id*ones(length(xy(end:-1:1,5)),1); track.id];
        track.sc = [score*ones(length(xy(:,1)),1); track.sc];
        track.isdummy = [xy(end:-1:1,9); track.isdummy];
    else
        track.x = [xy(end:-1:1,1); track.x];
        track.y = [xy(end:-1:1,2); track.y];
        track.x_hat = [xy_state(end:-1:1,1); track.x_hat];
        track.y_hat = [xy_state(end:-1:1,2); track.y_hat];
        track.w = [xy(end:-1:1,3); track.w];
        track.h = [xy(end:-1:1,4); track.h];
        track.fr = [xy(end:-1:1,5); track.fr];
        track.id = [id*ones(length(xy(end:-1:1,5)),1); track.id];
        track.sc = [score*ones(length(xy(:,1)),1); track.sc];
        track.isdummy = [xy(end:-1:1,9); track.isdummy];
    end
    
    parentNodeID = obsTreeSet(familyID).getparent(nodeID);
    nodeID = parentNodeID;

end

end





