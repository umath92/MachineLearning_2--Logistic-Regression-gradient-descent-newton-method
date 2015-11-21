% Need to run part(a) and part (d) first!!
function biasExpansion()

    colName={'sex','pclass','fare','embarked','parch','sibsp','age'};
    colNameInde={'pclass','age','sibsp','parch','fare'};
    colNumInde=[2,7,6,5,3];
    

    trainX = evalin('base', 'trainXnotNormal');
    testX = evalin('base', 'testXnotNormal');
    
   
   [newTrain,newTest]=appendSquareRoot(trainX,testX,colNumInde);
   %assignin('base', 'newTrain', newTrain);
   %assignin('base', 'newTest', newTest);
   
  
   
   
   newTrainAddedBin=appendBinsTrain(newTrain,colNumInde);
   %assignin('base', 'newTrainAddedBin', newTrainAddedBin);
   
   
   
   newTestAddedBin=appendBinsTrain(newTest,colNumInde);
   %assignin('base', 'newTestAddedBin', newTestAddedBin);
   
   
   
   
   newTrainAppendInteraction=appendInteration(newTrainAddedBin);
   %assignin('base', 'newTrainAppendInteraction', newTrainAppendInteraction);
   
   newTestAppendInteraction=appendInteration(newTestAddedBin);
   %assignin('base', 'newTestAppendInteraction', newTestAppendInteraction);
   
   
   trainFinal=normalizeData(newTrainAppendInteraction);
   testFinal=normalizeData(newTestAppendInteraction);
   
   
   assignin('base', 'trainSameCol', trainFinal);
   assignin('base', 'testSameCol', testFinal);
   
   trainFinalNorm=deleteNanValues(trainFinal);
   testFinalNorm=deleteNanValues(testFinal);
   
   
   assignin('base', 'trainFinalNorme', trainFinalNorm);
   assignin('base', 'testFinalNorme', testFinalNorm);
   
 
end

function [mat] = normalizeData(mat)
    
    for col=1:size(mat,2)
        sum=0;
        for row=1:size(mat,1)
            if isnan(mat(row,col))==0
                sum=sum+mat(row,col);
            end
        end
        m(col)=sum/(size(mat,1));
        % Calculate std
        sum=0;
        for row=1:size(mat,1)
            if isnan(mat(row,col))==0
                sum=sum+power((mat(row,col)-m(col)),2);
            end
        end
        sd(col)=sqrt(sum/(size(mat,1)-1));
        % putting in vals.
        for row=1:size(mat,1)
            if isnan(mat(row,col))==0
                mat(row,col)=(mat(row,col)-m(col))/sd(col);
            end
        end
    end
end

function [new_mat]= deleteNanValues(mat)
    assignin('base', 'checkthisshit', mat);
    new_mat=mat(:,1);
    for col=2:size(mat,2)
        count=0;
        for row=1:size(mat,1)
            if isnan(mat(row,col))
                count=count+1;
            end
        end
        if((size(mat,1)-count)>2) 
            %count
            new_mat=horzcat(new_mat,mat(:,col));
        else
        end
        
    end
end

function [new_mat] = appendInteration(mat)
    count=0;
    new_mat=[];
    for i=1:size(mat,2)
        for j=1:i-1
            new_mat=horzcat(new_mat,mat(:,i).*mat(:,j));
            count=count+1;
        end
    end
    new_mat=horzcat(mat,new_mat);
    
end

%{
function [newTrain] = appendBinsTrain(newTrain,colNumInde)
    % Need to comment this out!
    %colNumInde=[2];
    for col=1:size(colNumInde,2)
        new_col=zeros(size(newTrain,1),2);
        [new_col(:,1),index]=sort(newTrain(:,colNumInde(col)));
        %%%% Setting the mapping value %%%%%%%
        div=size(new_col,1)/10;
        div=int64(div);
        d=[0,div,2*div,3*div,4*div,5*div,6*div,7*div,8*div,9*div];
        i=[0,1,2,3,4,5,6,7,8,9,10];
        for k=2:size(d,2)
            for row=d(k-1)+1:d(k)
                new_col((row),2)=i(k);
            end
        end
        
        for row=d(10)+1:size(new_col,1)
            new_col((row),2)=i(11);
        end
        %%%% Set the mapping value %%%%%%%
        
        new_col_2=zeros(size(newTrain,1),1);
        for i=1:size(index,1)
            new_col_2(index(i))=new_col(i,2);
        end
        %%%%%%% Need to append now %%%%%%%%%
        newTrain=horzcat(newTrain,new_col_2);
        
    end
end

%}

function [newTrain] = appendBinsTrain(newTrain,colNumInde)
    colNumInde=[7,6,5,3];
    
    % Need to comment this out!
    %colNumInde=[2];
    
    
    
    % for rest->
    
    for col=1:size(colNumInde,2)
        new_col=zeros(size(newTrain,1),2);
        [new_col(:,1),index]=sort(newTrain(:,colNumInde(col)));
        %%%% Setting the mapping value %%%%%%%
        div=size(new_col,1)/10;
        div=int64(div);
        d=[0,div,2*div,3*div,4*div,5*div,6*div,7*div,8*div,9*div];
        i=[0,1,2,3,4,5,6,7,8,9,10];
        for k=2:size(d,2)
            for row=d(k-1)+1:d(k)
                new_col((row),2)=i(k);
            end
        end
        
        for row=d(10)+1:size(new_col,1)
            new_col((row),2)=i(11);
        end
        %%%% Set the mapping value %%%%%%%
        
        new_col_2=zeros(size(newTrain,1),1);
        for i=1:size(index,1)
            new_col_2(index(i))=new_col(i,2);
        end
        %%%%%%% Need to append now %%%%%%%%%
        new_col_2=dummyvar(new_col_2);
        k=[];
        for i=1:size(new_col_2,2)-3
            k=horzcat(k,new_col_2(:,i));
        end
        newTrain=horzcat(newTrain,k);
        
    end
    %pcalss->
    
    col=2;
    new_col=zeros(size(newTrain,1),2);
    [new_col(:,1),index]=sort(newTrain(:,colNumInde(col)));
    new_col_2=zeros(size(newTrain,1),1);
    for i=1:size(new_col,1)
        new_col_2(index(i))=new_col(i,1);
    end
    newTrain=horzcat(newTrain,new_col_2);
    assignin('base', 'HOLYSHITTT', newTrain);
    
end


function [trainX,testX]= appendSquareRoot(trainX,testX,colNumInde)

    for col=1:size(colNumInde,2)
        newMat=zeros(size(trainX,1),1);
        for row=1:size(trainX,1)
            newMat(row)=sqrt(trainX(row,colNumInde(col)));            
        end
        trainX=horzcat(trainX,newMat);
    end
    
    
    for col=1:size(colNumInde,2)
        newMat=zeros(size(testX,1),1);
        for row=1:size(testX,1)
            newMat(row)=sqrt(testX(row,colNumInde(col)));
        end
        testX=horzcat(testX,newMat);
    end

    
end