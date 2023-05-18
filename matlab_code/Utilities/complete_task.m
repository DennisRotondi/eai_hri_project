function complete_task(type,position,task)
    global types positions z_dirs approach_orientations home cloud_pouches scale_pos
    if type == "pouch"
        z_approach = [0 0 0.1 0 0 0];
        ctrs_good = [    0.6217   -0.1294   -0.0816;
        0.5347    0.1301   -0.0817;
        0.6218   -0.0307   -0.0809;
        0.5355   -0.0325   -0.0814;
        0.5345    0.0411   -0.0817;
        0.6224    0.0419   -0.0811]; % a good initial guess (pouches only rotate)
        [labels, ctrs] = kmeans(cloud_pouches, 6, "Start", ctrs_good);
        i = find_nearest(ctrs, position,type);
        pouch_i = cloud_pouches(labels==i,1:2);
        center = mean(pouch_i);
        theta = pouchOrient(pouch_i);
        
        moveTo(home+[0.1,0,-0.1,0,0,0],1);
        moveGripper(0.03, 0);
        moveTo([center, -0.075, -pi, 0, -theta] + z_approach,2);
        moveTo([center, -0.080, -pi, 0, -theta],2);
        moveTo([center, -0.095, -pi, 0, -theta],2);
        moveGripper(0.029/2,50);
        % pause(1);
        moveTo([center, -0.075, -pi, 0, -theta] + z_approach,1);
        moveTo(home+[0.1,0,-0.2,0,0,0],0);
        if task == "weight"
            moveTo(scale_pos + z_approach, 1);
            moveTo(scale_pos, 2);
            moveGripper(0.03, 0.0);
            moveTo(scale_pos+ [0 0 -0.01 0 0 0],2);
            moveGripper(0.029/2,50);
        end
        moveTo(home,0);
        moveTo([-0.35,0.45,0.3,-pi,0,0],5);
        moveGripper(0.04,0);
        moveTo(home)
        return
    end
    idx = find_nearest(positions, position,type);
    disp(idx);
    pickObject(types(idx), positions(idx,:),z_dirs(idx),approach_orientations(idx,:))
    throwAway(types(idx))
    moveTo(home)
end

function idx = find_nearest(list,target,type)
    global types
    idx = 1;
    current_best = 1e9;
    for i=1:size(list)
        tmp = norm(target'-list(i,1:3)');
        if tmp < current_best && (type == types(i) || type == "pouch")
            current_best = tmp;
            idx = i;
        end
    end
end
