classdef SvmClassifier < handle
    properties
        linearClassifier
        dataPoints
        classVector
    end
    
    methods
        
        function obj = SvmClassifier()
            obj.linearClassifier = LinearClassifier([1 1], @()obj.classifier_change());
        end
        
        function loadTrainData(obj,dataPoints,classVector)
            obj.dataPoints = dataPoints;
            obj.classVector = classVector;
        end
        
        function trainSVM(obj)
            obj.linearClassifier.train(obj.dataPoints, obj.classVector, 'b');
        end
        
        function prediction = classify(obj,Point)
            %prediction = svmclassify(obj.linearClassifier.struct,Point,'showplot',true);
            prediction = svmclassify(obj.linearClassifier.struct,Point);
        end
        
        function classifier_change(obj)
               disp('Classifier was changed!')
               disp(obj.linearClassifier.weights);
               disp(obj.linearClassifier.theta);
        end
        
        function showmModel(obj)
            obj.linearClassifier.showmodel();
        end
    end
    
end

