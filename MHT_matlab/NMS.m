function observation = NMS(observation, other_param)

ov_threshold = 0.4;

% calculate overlap
obsNo = length(observation.x);
obsInd = 1:obsNo;
overlap_mat = zeros(obsNo,obsNo);
for i = 1:obsNo
    obsIndSel = setdiff(obsInd,i);
    overlap = calc_overlap(observation,i,observation,obsIndSel);
    overlap_mat(i,obsIndSel) = overlap;
end


overlap_mat(overlap_mat < ov_threshold) = 0;
[Matching cost] = Hungarian(-overlap_mat);
[row,col] = find((Matching==1) & (overlap_mat >= ov_threshold));

% when overlapped, pick more confident detection
obsIndDel = [];
for i = 1:length(row)
   if observation.sc(row(i)) > observation.sc(col(i))
       obsIndDel = [obsIndDel; col(i)];
   else
       obsIndDel = [obsIndDel; row(i)];
   end
end

observation.x(obsIndDel) = [];
observation.y(obsIndDel) = [];
observation.bx(obsIndDel) = [];
observation.by(obsIndDel) = [];
observation.w(obsIndDel) = [];
observation.h(obsIndDel) = [];
observation.sc(obsIndDel) = [];
observation.fr(obsIndDel) = [];

if other_param.isAppModel
    observation.app(obsIndDel,:) = [];
end

