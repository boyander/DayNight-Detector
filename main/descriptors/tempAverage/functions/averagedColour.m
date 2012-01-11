function [X,Y,Z,mask] = averagedColour(img,mask,delta)

XA = 0;
XTS_last = 0;

mask(:,:,1) = markGreaterThanMask(img(:,:,1),mask(:,:,1),0.05*max(img(:,:,1)));
mask(:,:,2) = markGreaterThanMask(img(:,:,2),mask(:,:,2),0.05*max(img(:,:,2)));
mask(:,:,3) = markGreaterThanMask(img(:,:,3),mask(:,:,3),0.05*max(img(:,:,3)));


while 1
    XA = matrixMaskAverage(img(:,:,1), mask(:,:,1));
    XTS = delta * XA;
    if XTS == XTS_last
        break;
    end
    mask(:,:,1) = markGreaterThanMask(img(:,:,1),mask(:,:,1),XTS);
    XTS_last = XTS;
end

X = XA;
XTS_last = 0;

while 1
    XA = matrixMaskAverage(img(:,:,2), mask(:,:,2));
    XTS = delta * XA;
    if XTS == XTS_last
        break;
    end
    mask(:,:,1) = markGreaterThanMask(img(:,:,2),mask(:,:,2),XTS);
    XTS_last = XTS;
end

Y = XA;
XTS_last = 0;

while 1
    XA = matrixMaskAverage(img(:,:,3), mask(:,:,3));
    XTS = delta * XA;
    if XTS == XTS_last
        break;
    end
    mask(:,:,1) = markGreaterThanMask(img(:,:,3),mask(:,:,3),XTS);
    XTS_last = XTS;
end

Z = XA;

end

