function det = loadDet(det_input_path, other_param)

load(det_input_path);



if strcmp(other_param.seq,'PETS2009')
    % change the detection variable name
    det = dres;
    if ~other_param.is3Dtracking
        det.x = det.bx+det.w/2;
        det.y = det.by+det.h/2;
    end
elseif ~other_param.is3Dtracking
    det.x = det.x + det.w/2;
    det.y = det.y + det.h/2;
end


det1 = det.x;
det2 = det.y;
det3 = det.bx;
det4 = det.by;
det5 = det.r;
det6 = det.fr;
det7 = det.h;
det8 = det.w;

csvwrite("det_h.csv",det7);
csvwrite("det_w.csv",det8);
csvwrite("det_x.csv",det1);
csvwrite("det_y.csv",det2);
csvwrite("det_bx.csv",det3);
csvwrite("det_by.csv",det4);
csvwrite("det_r.csv",det5);
csvwrite("det_fr.csv",det6);

%struct2csv(det1,"input.csv");
% if there is no detection score field, create it
if ~isfield(det,'r')
    det.r = ones(length(det.x),1);
end