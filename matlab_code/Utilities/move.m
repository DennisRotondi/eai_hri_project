function move(direction, lin_off,ang_off)
    arguments
        direction = 'x+';
        lin_off = 0.1;
        ang_off = 1;
    end
    global tftree
    persistent dir pos
    if isempty(dir)
        dir = ["x+" "x-" "y+" "y-" "z+" "z-" "a+" "a-" "b+" "b-" "c+" "c-"];
        pos = [[1,0,0,0,0,0]; [-1,0,0,0,0,0]; [0,1,0,0,0,0]; [0,-1,0,0,0,0]; 
               [0,0,1,0,0,0]; [0,0,-1,0,0,0]; [0,0,0,1,0,0]; [0,0,0,-1,0,0]; 
               [0,0,0,0,1,0]; [0,0,0,0,-1,0]; [0,0,0,0,0,1]; [0,0,0,0,0,-1]];
    end
    idx = dir == direction;
    posid = pos(idx,:);
    BASEFRAME = "panda_link0";
    EEFRAME   = "panda_EE";
    base_ee = getTransform(tftree, BASEFRAME, EEFRAME);
    transl = base_ee.Transform.Translation;
    transla = [transl.X transl.Y transl.Z];
    tran_diff = lin_off*posid(1:3);
    rot = base_ee.Transform.Rotation;
    rota = quat2rotm([rot.W, rot.X,rot.Y,rot.Z]);
    rot_diff = eul2rotm(ang_off*posid(4:6),"XYZ");
    angle_final = rotm2eul(rota*rot_diff,"XYZ");
    trans_final = transla + tran_diff;
    moveTo([trans_final angle_final],1,true);
end

