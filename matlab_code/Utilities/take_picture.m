function depthImg = take_picture()
    global rgbImgSub 
    curImage = receive(rgbImgSub,4);
    depthImg = rosReadImage(rgbImgSub.LatestMessage); 
end

