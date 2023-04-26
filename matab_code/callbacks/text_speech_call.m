function text_speech_call(obj, msg, vararg)
    global network
    % here we need to understand what the person said
    str = msg.Data;
    if contains(str,"take") && (contains(str,"picture") || contains(str,"photo"))
        send_picture(take_picture);
    elseif contains(str,"move") || contains(str,"go") || contains(str,"rotate")
        idxs = ["x+" "x-" "y+" "y-" "z+" "z-" "a+" "a-" "b+" "b-" "c+" "c-"];
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
        elseif contains(str,"roll")
            move("a+");
        elseif contains(str,"inverse roll")
            move("a-");
        elseif contains(str,"pitch")
            move("b+");
        elseif contains(str,"inverse pitch")
            move("b-");
        elseif contains(str,"yaw")
            move("c+");
        elseif contains(str,"inverse yaw")
            move("c-");
    elseif contains(str,"count") || contains(str,"how many")
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
        disp("throwing");
    end
end