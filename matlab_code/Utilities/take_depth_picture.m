function rgbImg = take_picture()
    global depthImgSub 
    curImage = receive(depthImgSub,4);
    rgbImg = rosReadImage(depthImgSub.LatestMessage); 
end

