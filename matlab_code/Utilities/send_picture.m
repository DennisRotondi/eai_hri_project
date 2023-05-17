function send_picture(img)
    global rgbImgPub
    compImg = rosmessage('sensor_msgs/CompressedImage');
    compImg.Format = 'jpeg';
    compImg.Data = imencode(img, 'jpg', 'Quality', 100);
    send(rgbImgPub,compImg);
end

