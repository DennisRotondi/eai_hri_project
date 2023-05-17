function ptCloudWorld = getPointCloud()
%GETPOINTCLOUD Takes the pointcloud from the depth sensor and transforrm it
%to world coordinates
%   Input:
%
%   Output:
%       pcCloudWorld: pointcloud in world coordinates
    tftree = rostf; %finds TransformationTree directly from ros
    pointCloudSub = rossubscriber('/camera/depth/points');
    pause(1);
    camera_transf = getTransform(tftree, 'panda_link0', 'camera_depth_link','Timeout',inf);
    %camera_transf = getTransform(tftree, 'camera_link', 'world');
    pointcloud = receive(pointCloudSub);
    xyz = readXYZ(pointcloud); 
    camera_transl = camera_transf.Transform.Translation;
    camera_rotation = camera_transf.Transform.Rotation;
    camera_quaternion = [camera_rotation.W, camera_rotation.X,...
        camera_rotation.Y,camera_rotation.Z];
    camera_translation = [camera_transl.X,...
        camera_transl.Y,camera_transl.Z];
    quat = camera_quaternion;
    rotm = quat2rotm(quat);
    tform = rigidtform3d(rotm,camera_translation);

    % Remove NaNs
    xyzLess = double(rmmissing(xyz));
    % Create point cloud object
    ptCloud = pointCloud(xyzLess);
    % Transform point cloud to world frame
    ptCloudWorld = pctransform(ptCloud,tform);
end

