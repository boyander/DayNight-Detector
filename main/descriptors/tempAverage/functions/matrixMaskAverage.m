function [avg] = matrixMaskAverage(mat, mask)
       
avg = mean2(double(mat).*double(mask));
%     [W,H] = size(mat);
%     totalized = 1;
%     v(1)=0;
%     for i = 1:W
%         for j = 1:H
%             if(mask(i,j)==1)
%                	v(totalized) =  mat(i,j);
%                 totalized = totalized +1;
%             end
%         end
%     end
    %avg = mean(v);
end


