function [ mask ] = markGreaterThanMask(mat, mask, th)
    
    [W,H] = size(mat);
    for i = 1:W
        for j = 1:H
            if(mat(i,j) < th)
                mask(i,j) = 0;
            end
        end
    end
    
end

