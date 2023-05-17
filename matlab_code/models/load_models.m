global types positions z_dirs approach_orientations home cloud_pouches scale_pos
types = load("types.mat").types;
positions = load("positions.mat").positions;
z_dirs = load("z_dirs.mat").z_dirs;
cloud_pouches = load("cloud_pouches.mat").cloud_pouches;
approach_orientations = load("approach_orientations.mat").approach_orientations;
home = [0.4,0,0.4,-pi,0,0];
scale_pos = [0.61 0.38 -0.03, -pi, 0, 0];


% moveTo(home);
% idx = 11;
% pickObject(types(idx), positions(idx,:),z_dirs(idx),approach_orientations(idx,:))
% throwAway(types(idx))