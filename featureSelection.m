function featureSelection()
    
    mat = evalin('base', 'trainSameCol');
    testInfo = evalin('base', 'testSameCol');
    labelTrainCell = evalin('base', 'surviveTrain');
    labelTestCell = evalin('base', 'surviveTest');
    labelTrain=cell2mat(labelTrainCell);
    labelTest=cell2mat(labelTestCell);
    
    trainFinal=zeros(10,1);
    testingAcc=zeros(10,1);
    V=[];
    featureVectorIndices=[];
    
    for i=1:10
        train=0;
        test=0;
        indexM=-1;
        k=0;
        %testBest=[];
        for j=1:size(mat,2)
            if notInVec(j,featureVectorIndices)==1 && notallNaN(mat(:,j))==1
                k=k+1;
                input=horzcat(mat(:,j),V);
                b=glmfit(input,labelTrain,'binomial','link','logit');
                [trainBest(k),index(k)]=trainingAcc(mat,j,b,labelTrain,V);
                testV=getVofTestSet(testInfo,featureVectorIndices);
                %size(testInfo(:,j))
                %testV is the union of vectord for corresponding indices of
                %train set.
                o=glmval(b,horzcat(testInfo(:,j),testV),'probit');
                testBest(k)=calculateAcc(labelTest,o);
            end
        end
        for l=1:size(testBest,2)
            if(test<testBest(l))
                test=testBest(l);
                testBest(l)=0;
            end
            
        end
        
        
        for l=1:size(trainBest,2)
            if(train<trainBest(l))
                train=trainBest(l);
                trainBest(l)=0;
                indexM=index(l);
            end
        end
        V=horzcat(mat(:,indexM),V);
        featureVectorIndices(i)=indexM;
        %mat = mat(:,setdiff(1:size(mat,2),indexM));
        trainFinal(i)=train;
        
        testFinal(i)=test;
    end
    featureVectorIndices
    testFinal=testFinal';
    table(trainFinal,testFinal)
    iteration=[1,2,3,4,5,6,7,8,9,10];
    figure;
    
    plot(iteration,trainFinal,iteration,testFinal);
    %axis([1 10 .6 .85]);
    xlabel('Size of feature Vector');
    ylabel('Accuracy');
    title('Blue=Training Accuracy and Green=Testing Accuracy');
end

function [count]= notallNaN(mat)
    count=1;
    for i=1:size(mat,1)
        if isnan(mat(i,1))
            count=count+1;
        end
    end
    if (count==size(mat,1))
        count=0;
    end
end


function [k]=notInVec(a,b)
    k=1;
    for j=1:size(b,2)
        if b(j)==a
            k=0;
            break;
        end
    end
end

function [a] = getVofTestSet(testInfo,featureVectorIndices)
    a=[];
    for i=1:size(featureVectorIndices,2)
        a=horzcat(a,testInfo(:,featureVectorIndices(i)));
    end
    
end



function [m,index]=trainingAcc(mat,index,b,labels,V)
    o=glmval(b,horzcat(mat(:,index),V),'probit');
    m=calculateAcc(labels,o);
end



function [count] = calculateAcc(true,get)
    count=0;
    for i=1:size(true,1)
        if(get(i)>=0.5)
            get(i)=1;
        else
            get(i)=0;
        end
        if(true(i)==get(i))
            count=count+1;
        end
    end
    count=count/size(true,1);
end