function p_link0 = reproject(point, depth_image)
%UNPROJECT Finds the world coordinates of points in an image using the
%depth of the image.
%   Inputs:
%       points: a n x 2 vector of points, in image coordinates
%       depth_image: the depth_image
%   Outputs:
%       p_link0: a n x 3 vector of points in world coordinates
%       corresponding to the points selected in the depth_image   
    % disp(point);
    % disp(size(depth_image));
    depth_value = depth_image(point(2),point(1));
    [K,~] = getCameraMatrix;
    fx=K(1,1);
    fy=K(2,2);
    ox=K(1,3);
    oy=K(2,3);

    p_cam =[(point(1)-ox)*depth_value/fx;
            (point(2)-oy)*depth_value/fy;
            depth_value;];

    tftree = rostf; %finds TransformationTree directly from ros
    pause(1);
    camera_transf = getTransform(tftree, 'panda_link0', 'camera_depth_link');

    camera_transl = camera_transf.Transform.Translation;
    camera_rotation = camera_transf.Transform.Rotation;
    camera_quaternion = [camera_rotation.W, camera_rotation.X,...
        camera_rotation.Y,camera_rotation.Z];
    camera_translation = [camera_transl.X,...
        camera_transl.Y,camera_transl.Z];
    rotm = quat2rotm(camera_quaternion);
    tform = rigidtform3d(rotm,camera_translation);
    p_link0 = tform.transformPointsForward(p_cam');
end

