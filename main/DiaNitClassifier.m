% GDSA - Implementació d'un classificador Dia/Nit

% Victor Hidalgo Lorenzo
% Eneas Castan Victor
% Albeto Esteban Perez
% Marc Pomar Torres

classdef DiaNitClassifier < handle
    properties
      image;
      ground_th;
      decision;
      
      path = '';
      thumbPath = ''
      status = -1;
      
      %Descriptors
      luma = 0;
      temp = 0;
      hue = 0;
      contrast = 0;
    end
    methods
        %Class Constructor
        function obj = DiaNitClassifier(img,gt,path,thumbPath)
            obj.image = img;
            obj.ground_th = gt;
            obj.path = path;
            obj.thumbPath = thumbPath;
        end
       
        %Decisor
        function [obj,status] = decide(obj)
            if (obj.luma < 87 && obj.ground_th == 0)
                obj.status = 0; %'NIT CORRECTE'
                obj.decision = obj.ground_th;
            elseif (obj.luma < 87 && obj.ground_th == 1)
                obj.decision = obj.ground_th;
                obj.status = 1; %'NIT INCORRECTE'
            elseif (obj.luma > 87 && obj.ground_th == 1)
                obj.decision = ~obj.ground_th;
                obj.status = 2; %'DIA CORRECTE'
            else
                obj.decision = ~obj.ground_th;
                obj.status = 3; %'DIA INCORRECTE'
            end  
        end

        %Silly function to compute all descriptors, comented descriptors
        %are not calculated
        function obj = computeDescriptors(obj)
             obj.luma = Luminance(obj.image);
             obj.temp = averageTemp(obj.image);
             %obj.hue = calculateHue(obj.image);
             %obj.contrast = calculateContrast(obj.image);
        end  
        
        function obj = set.luma(obj,value)
           if ~(value > 0)
              error('Property value must be positive')
           else
              obj.luma = value;
           end
        end
                
        function obj = set.temp(obj,value)
           if ~(value > 0)
              error('Property value must be positive')
           else
              obj.temp = value;
           end
        end
        
        function vector = getDescriptorVector(obj)
            vector = [obj.luma; obj.temp;]';
        end
        
        function value = setDecision(obj,value)
            L = length(obj);
            for i = 1:L
               obj(i).decision = value(i);
            end
        end
        
        
        function gt = getGT(obj)
            L = length(obj);
            gt = ones(L,1);
            for i = 1:L
                if(obj(i).ground_th == 0)
                    gt(i) = -1;
                end
            end
        end
        
        function gt = binaryGTClassVec(obj)
            L = length(obj);
            gt = ones(2,L);
            for i = 1:L
                if(obj(i).ground_th == 0)
                    gt(:,i) = [0;1];
                else
                    gt(:,i) = [1;0];
                end
            end
        end
        
        function tr = binaryTrainVec(obj)
            L = length(obj);
            tr = ones(2,L);
            for i = 1:L
                if(obj(i).decision == -1)
                    tr(:,i) = [0;1];
                else
                    tr(:,i) = [1;0];
                end
            end
        end
        

        function miss_img = getInvalid(obj)
            L = length(obj);
            t_out = 1;
            miss_img = [];
            for i = 1:L
                gt = 1;
                if(obj(i).ground_th == 0)
                    gt = -1;
                end
                if(gt ~= obj(i).decision)
                    miss_img = [miss_img;obj(i)];
                    t_out = t_out + 1;
                end
            end
        end
        
        function showInvalid(obj)
            L = length(obj);
            for i = 1:L
                gt = 1;
                if(obj(i).ground_th == 0)
                    gt = -1;
                end
                if(gt ~= obj(i).decision)
                    figure('Name','Missclassified img!');
                    fprintf('Image %s Classified as %d but is %d\n',obj(i).path,obj(i).decision,gt)
                    imshow(obj(i).image);
                end
            end
        end
        
    end
end