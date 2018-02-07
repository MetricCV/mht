function visTracks(track, other_param, input_frames, output_dir, frameNum)

load external/Pirsiavash_CVPR2011/label_image_file.mat;

bboxes_tracked = dres2bboxes(track, frameNum);
%disp(['this is a track: ',max(track.id)]);
%disp(['this is a frame number: ',frameNum]);
show_bboxes_on_video(input_frames, bboxes_tracked, [], bws, [], -inf, output_dir, other_param);