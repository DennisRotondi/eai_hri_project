function text_speech_call(obj, msg, vararg)
    global network status text_speech
    % here we need to understand what the person said
    str = msg.Data;
    disp(str);
    % disp("hello");
    if status == "busy"
        send_log("I'm sorry to say that I'm busy completing a previous command, wait a moment please")
        return
    elseif status == "waiting"
        return
    end
    status = "busy";
    if contains(str,"take") && (contains(str,"picture") || contains(str,"photo"))
        disp("here0")
        send_picture(take_picture);
    elseif contains(str,"move") || contains(str,"go") || contains(str,"rotate")
        disp("here1")
        if contains(str,"forward") || contains(str,"ahead")
            move("x+");
        elseif contains(str,"backward") || contains(str,"back")
            move("x-");
        elseif contains(str,"right")
            move("y+");
        elseif contains(str,"left")
            move("y-");
         elseif contains(str,"up")
            move("z+");
        elseif contains(str,"down")
            move("z-");
        elseif contains(str,"inverse roll")
            move("a-");
        elseif contains(str,"roll")
            move("a+");
        elseif contains(str,"inverse pitch")
            move("b-");
            disp("b-");
        elseif contains(str,"pitch")
            move("b+");
        elseif contains(str,"inverse yaw")
            move("c-");
        elseif contains(str,"yaw")
            move("c+");
        end
    elseif contains(str,"count") || contains(str,"how many")
        % disp("here2")
        img = take_picture;
        [bboxes,~,labels] = detect(network,img);
        idxs = -1;
        for el = {'can','bottle', 'pouch'}
            if contains(str,el)
                idxs = labels == el;
                break
            end
        end
        if contains(str,"object")
                idxs = labels == labels;
        end
        if idxs > -1
            send_picture(insertObjectAnnotation(img,"rectangle",bboxes(idxs,:),labels(idxs)));
        else
            send_picture(img);
            idxs = 0;
        end
        if sum(idxs) == 1
            log_msg = 'there is '+string(sum(idxs))+'!!';
        else
            log_msg = 'there are '+string(sum(idxs))+'!!';
        end
        send_log(string(log_msg))
    elseif contains(str,"recycle") || contains(str,"throw") || contains(str,"take")
        if contains(str,"can") 
            obj = "can";
        elseif contains(str,"bottle") 
            obj = "bottle";
        elseif contains(str,"pouch") 
            obj = "pouch";
        else
            send_log("sorry I don't see that object, try moving me around!");
            status = "available";
            return
        end
        img = take_picture;
        depth = take_depth_picture;
        [bboxes,~,labels] = detect(network,img);
        idxs = labels == obj;
        bboxes = bboxes(idxs,:);
        if isempty(bboxes)
            send_log("sorry I don't see any "+obj+" here, try moving me around!");
            status = "available";
            return
        end
        status = "waiting";
        confirm = false;
        for i=1:size(bboxes(:,1))
            send_log("there are more than one, is this one?")
            send_picture(insertObjectAnnotation(img,"rectangle",bboxes(i,:),obj));
            msg = receive(text_speech,2000);
            if contains(msg.Data,"yes")
                confirm = true;
                break
            elseif contains(msg.Data,"no")
                continue
            else
                send_log("sorry but you didn't confirm correctly")
                status = "available";
                return
            end
        end
        if ~confirm
            send_log("sorry but I don't see another "+obj)
            status = "available";
            return
        end
        bbox = bboxes(i,:);
        ctr_img = round([bbox(1) + bbox(3)/2; bbox(2) + bbox(4)/2]);
        p_link0 = reproject(ctr_img, depth);
        complete_task(obj,p_link0,"throw");
    elseif contains(str,"weight") && contains(str,"pouch")
        obj = "pouch";
        img = take_picture;
        depth = take_depth_picture;
        [bboxes,~,labels] = detect(network,img);
        idxs = labels == obj;
        bboxes = bboxes(idxs,:);
        if isempty(bboxes)
            send_log("sorry, I don't see any pouch here, try moving me around!");
            status = "available";
            return
        end
        status = "waiting";
        confirm = false;
        for i=1:size(bboxes(:,1))
            send_log("there are more than one, is this one?")
            send_picture(insertObjectAnnotation(img,"rectangle",bboxes(i,:),obj));
            msg = receive(text_speech,2000);
            if contains(msg.Data,"yes")
                confirm = true;
                break
            elseif contains(msg.Data,"no")
                continue
            else
                send_log("sorry but you didn't confirm correctly")
                status = "available";
                return
            end
        end
        if ~confirm
            send_log("sorry but I don't see another "+obj)
            status = "available";
            return
        end
        bbox = bboxes(i,:);
        ctr_img = round([bbox(1) + bbox(3)/2; bbox(2) + bbox(4)/2]);
        p_link0 = reproject(ctr_img, depth);
        complete_task(obj,p_link0,"weight")
    else
        disp("I didn't get your instruction, sorry!");       
    end
    status = "available";
end