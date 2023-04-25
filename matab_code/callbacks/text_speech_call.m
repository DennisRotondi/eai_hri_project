function text_speech_call(obj, msg, vararg)
    global network
    % here we need to understand what the person said
    str = msg.Data;
    if contains(str,"take") && contains(str,"picture")
        send_picture(take_picture);
    elseif contains(str,"count") || contains(str,"how many")
        img = take_picture;
        [bboxes,~,labels] = detect(network,img);
        idxs = -1;
        for el = {'can','bottle', 'pouch'}
            if contains(str,el)
                idxs = labels == el;
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
            log_msg = 'there is '+string(sum(idxs))+'!!'
        else
            log_msg = 'there are '+string(sum(idxs))+'!!'
        end
        send_log(string(log_msg))
    end
end