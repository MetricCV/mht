function [incompabilityListTreeSet incompabilityListTreeNodeIDSet] = updateICL(obsTreeSet, idTreeSet, incompabilityListTreeNodeIDSetPrev,activeTreeSet, cur_observation, obsMembership)

familyNo = length(obsTreeSet);
if familyNo ~= 0
    incompabilityListTreeSet(familyNo,1) = tree;
    incompabilityListTreeNodeIDSet(familyNo,1) = tree;
else
    incompabilityListTreeSet = [];
    incompabilityListTreeNodeIDSet = [];
    return
end


% initialize the incompability lists
for i = 1:familyNo        
    incompabilityListTreeSet(i) = tree(idTreeSet(i), 'clear');
    incompabilityListTreeNodeIDSet(i) = tree(idTreeSet(i), 'clear');
end

% store the tree information in the table because tree operations are slow now
treeIndCache = cell(length(incompabilityListTreeNodeIDSetPrev),1);
trackIDCache = cell(length(incompabilityListTreeNodeIDSetPrev),1);
ICLCache = cell(length(incompabilityListTreeNodeIDSetPrev),1);
indexMapping = cell(length(incompabilityListTreeNodeIDSetPrev),1);
for i = 1:length(incompabilityListTreeNodeIDSetPrev)
   treeInd = findleaves(incompabilityListTreeNodeIDSetPrev(i));
   treeIndCache{i} = cell(length(treeInd),1);
   trackIDCache{i} = cell(length(treeInd),1);
   ICLCache{i}     = cell(length(treeInd),1);
   indexMapping{i} = zeros(treeInd(end),1);
   for j = 1:length(treeInd)       
       ICLCache{i}{j} = incompabilityListTreeNodeIDSetPrev(i).get(treeInd(j));
       indexMapping{i}(treeInd(j)) = j;
       
       childList = idTreeSet(i).getchildren(treeInd(j));
       
       if ~isempty(childList)
           treeIndCache{i}{j} = zeros(length(childList),2);  % [familyID branchInd]
           trackIDCache{i}{j} = zeros(length(childList),2);  % [familyID trackID]
           for k = 1:length(childList)
               if activeTreeSet(i).get(childList(k)) ~= 1
                   continue;
               end
               treeIndCache{i}{j}(k,:) = [i childList(k)];
               trackIDCache{i}{j}(k,:) = idTreeSet(i).get(childList(k));
           end
           idx = (trackIDCache{i}{j}(:,2)==0);
           trackIDCache{i}{j}(idx,:) = [];
           treeIndCache{i}{j}(idx,:) = [];
       end       
   end
end

% delete nonactive tracks 
for i = 1:length(obsMembership)
   if ~isempty(obsMembership{i})
       obsInd = zeros(size(obsMembership{i},1),1);
       for j = 1:size(obsMembership{i},1)
           if activeTreeSet(obsMembership{i}(j,1)).get(obsMembership{i}(j,2)) ~= 1
               obsInd(j) = 1;
           end
       end
       obsInd = ~~obsInd;
       obsMembership{i}(obsInd,:) = [];
   end
end

% find incompatible tracks
for i = 1:familyNo
   treeInd = findleaves(obsTreeSet(i));         
   for j = 1:length(treeInd) 
       
       if activeTreeSet(i).get(treeInd(j)) ~= 1
           continue;
       end
       
       idTemp = idTreeSet(i).getparent(treeInd(j));
       % find incompatible tracks from the same family. This is done once when a new family is created.
       if idTemp == 0        
           incompabilityListTreeSet(i) = incompabilityListTreeSet(i).set(treeInd(j),idTreeSet(i).get(treeInd(j)));   
           incompabilityListTreeNodeIDSet(i) = incompabilityListTreeNodeIDSet(i).set(treeInd(j), [i treeInd(j)]);
           
       % find incompatible tracks from parents nodes 
       else                                         
            iclParentTemp = ICLCache{i}{indexMapping{i}(idTemp)};
            incompabilityListSet = [];
            incompabilityNodeIDListSet = [];
            for k = 1:size(iclParentTemp,1)
                familyIDTemp = iclParentTemp(k,1);
                trackSelInd = indexMapping{familyIDTemp}(iclParentTemp(k,2));  

                iclTrackListTemp = trackIDCache{familyIDTemp}{trackSelInd}; 
                iclIndListTemp = treeIndCache{familyIDTemp}{trackSelInd};
                
                if ~isempty(iclTrackListTemp)                     
                    incompabilityListSet = [incompabilityListSet; iclTrackListTemp];
                    incompabilityNodeIDListSet = [incompabilityNodeIDListSet; iclIndListTemp];                    
                end
            end
            incompabilityListTreeSet(i) = incompabilityListTreeSet(i).set(treeInd(j), incompabilityListSet); 
            incompabilityListTreeNodeIDSet(i) = incompabilityListTreeNodeIDSet(i).set(treeInd(j), incompabilityNodeIDListSet);             
       end
       
       % find incompatible tracks from other families
       sel_observation1 = obsTreeSet(i).get(treeInd(j));              
       
       % check whether the leaf node is a dummy node or not
       if ~isnan(sel_observation1(9))        
           ind1 = cur_observation.x == sel_observation1(1);
           ind2 = cur_observation.y == sel_observation1(2);
           iclSel = cell2mat(obsMembership(ind1 & ind2)); % [familyID branchIndex trackID]
           if ~isempty(iclSel)                        
               incompatibleTrackList = [incompabilityListTreeSet(i).get(treeInd(j)); iclSel(:,[1 3])];
               incompabilityListTreeSet(i) = incompabilityListTreeSet(i).set(treeInd(j),incompatibleTrackList);   
       
               incompatibleTrackList = [incompabilityListTreeNodeIDSet(i).get(treeInd(j)); iclSel(:,1:2)];
               incompabilityListTreeNodeIDSet(i) = incompabilityListTreeNodeIDSet(i).set(treeInd(j),incompatibleTrackList);   
           end
       end
       
       % remove redundant tracks from the list
       incompabilityListSet = incompabilityListTreeSet(i).get(treeInd(j));
       [incompabilityListSet index] = unique(incompabilityListSet,'rows');
       incompabilityListTreeSet(i) = incompabilityListTreeSet(i).set(treeInd(j),incompabilityListSet);
       
       incompabilityListSet = incompabilityListTreeNodeIDSet(i).get(treeInd(j));
       incompabilityListTreeNodeIDSet(i) = incompabilityListTreeNodeIDSet(i).set(treeInd(j),incompabilityListSet(index,:));
   end        
end

end


