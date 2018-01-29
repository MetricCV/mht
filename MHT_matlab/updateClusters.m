function [clusters ICL_clusters other_param] = updateClusters(incompabilityListTreeSet, incompabilityListTreeNodeIDSet, activeTreeSet, other_param)

% Each tree node can be accessed by its familyID and trackID

familyNo = length(incompabilityListTreeSet);
other_param.currentTrackNo = 0;

if familyNo == 0
    clusters = [];
    ICL_clusters = [];
    return
end

clusterFamilyList = cell(familyNo,1);
clusterFamilyIndex = cell(familyNo,1);
familyClusters = zeros(familyNo,1);

for i = 1:familyNo            
    treeInd = findleaves(incompabilityListTreeSet(i));   
    ICL_sel = [];
    for j = treeInd
    
        if activeTreeSet(i).get(j) ~= 1
            continue;
        end
        
        ICL_sel_tmp = incompabilityListTreeNodeIDSet(i).get(j);
        ICL_sel = [ICL_sel; ICL_sel_tmp(:,1)];        
    end
    
    ICL_sel = unique(ICL_sel);        
    clusterFamilyList{i} = ICL_sel;    
end

for i = 1:length(clusterFamilyList)
   ICL_sel = clusterFamilyList{i};
   clusterFamilyIndex{i} = i;
   if i ~= length(clusterFamilyList)
   for j = i+1:length(clusterFamilyList)                  
        
        ICL_sel2 = clusterFamilyList{j};
        for k = 1:length(ICL_sel2)
            if sum(ICL_sel == ICL_sel2(k)) ~= 0
                clusterFamilyIndex{i} = [clusterFamilyIndex{i}; j];
                break;
            end
        end               
   end
   end
end

w = 0;
todolist = 1:familyNo;
while ~isempty(todolist)
    w = w+1;
    i = todolist(1);
    cl_index = clusterFamilyIndex{i};
    cl_index = cl_index';
    for j = cl_index
        if i == j
            continue;
        end        
        clusterFamilyIndex{i} = [clusterFamilyIndex{i}; clusterFamilyIndex{j}];  
        clusterFamilyIndex{j} = [];
    end
    clusterFamilyIndex{i} = unique(clusterFamilyIndex{i});
    todolist = setdiff(todolist,cl_index');  
    if sum(familyClusters(clusterFamilyIndex{i})) == 0
        familyClusters(clusterFamilyIndex{i}) = w;
    else     
        cl_parent = find(familyClusters(clusterFamilyIndex{i})~=0);
        clusterNums = unique(familyClusters(clusterFamilyIndex{i}(cl_parent)));
        for k = 1:length(clusterNums)
            indSel = find(familyClusters==clusterNums(k));
            familyClusters(indSel) = w;            
        end
        familyClusters(clusterFamilyIndex{i}) = w;
    end
end

ICL_clusters = cell(w,1);
clusters = cell(w,1);
for k = 1:max(familyClusters)
    ICL_sel = [];    
    ICL_Ind_sel = [];
    indSel = find(familyClusters == k);
    indSel = indSel';
    
    for i = indSel
        treeInd = findleaves(incompabilityListTreeSet(i));    
                
        for j = treeInd
            if activeTreeSet(i).get(j) ~= 1
                continue;
            end
        
            ICL_sel_tmp = incompabilityListTreeSet(i).get(j);
            ICL_sel = [ICL_sel; ICL_sel_tmp(:,2)];
            ICL_Ind_sel = [ICL_Ind_sel; [i j]]; 
        end
    end
    
    ICL_sel = unique(ICL_sel);
    ICL_clusters{k} = ICL_sel;
    clusters{k} = ICL_Ind_sel;
end
          
ICL_clusters(cellfun('isempty',ICL_clusters)) = [];  
clusters(cellfun('isempty',clusters)) = [];         

% count the number of tracks in each cluster
other_param.currentTrackNo = zeros(length(clusters),1);
for i = 1:length(clusters)
    
%     % print the track number information
%     for k = min(clusters{i}(:,1)):max(clusters{i}(:,1))
%         idx = clusters{i}(:,1) == k;        
%         if sum(idx) == 0
%             continue;
%         end        
%         disp(sprintf('the number of tracks in tree %d of cluster %d is %d.',k, i, sum(idx)));
%     end
    
    other_param.currentTrackNo(i) = size(clusters{i},1);
    
    if size(clusters{i},1) ~= size(ICL_clusters{i},1)
        error('error');
    end
end
