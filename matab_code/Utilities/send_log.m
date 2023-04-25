function send_log(str)
    global logger_pub
    msg = rosmessage(logger_pub);
    msg.Data = convertStringsToChars(str);
    send(logger_pub,msg);
end

