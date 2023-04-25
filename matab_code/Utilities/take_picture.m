function rgbImg = take_picture()
    global rgbImgSub 
    curImage = receive(rgbImgSub,4);
    rgbImg = rosReadImage(rgbImgSub.LatestMessage); 
end

