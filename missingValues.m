function missingValues()
    colNum=[3,1,8,10,6,5,4];
    colName={'sex','pclass','fare','embarked','parch','sibsp','age'};
    
    restTrainMv = evalin('base', 'restTrain');
    restTestMv = evalin('base', 'restTest');
    labelTrainCell= evalin('base', 'surviveTrain');
    labelTestCell= evalin('base', 'surviveTest');
    labelTrain=cell2mat(labelTrainCell);
    labelTest=cell2mat(labelTestCell);
    
    trainX=zeros(size(restTrainMv,1),size(colNum,2));
    testX=zeros(size(restTestMv,1),size(colNum,2));
    
    for col=1:size(colNum,2)
        for row=1:size(trainX,1)
            if col==1
                if strcmp(restTrainMv{row,colNum(col)},'female')==1
                    trainX(row,col)=0;
                end
                if strcmp(restTrainMv{row,colNum(col)},'male')
                    trainX(row,col)=1;
                end    
            end
            % parch and pclass
            if col==2 || col==5 || col==6 || col==7
                trainX(row,col)=restTrainMv{row,colNum(col)};
            end
            % fare
            if col == 3
                if isnan(restTrainMv{row,colNum(col)}(1))==1
                    trainX(row,col)=33.2955;
                else
                    trainX(row,col)=restTrainMv{row,colNum(col)};
                end
            end
            if col==4
                if isnan(restTrainMv{row,colNum(col)}(1))==1
                    trainX(row,col)=1;
                else
                    if strcmp(restTrainMv{row,colNum(col)},'S')==1
                       trainX(row,col)=1; 
                    elseif strcmp(restTrainMv{row,colNum(col)},'C')==1
                        trainX(row,col)=2;
                    else
                        trainX(row,col)=3;
                    end
                                
                end
            end
        end
    end
    
    
    for col=1:size(colNum,2)
        for row=1:size(testX,1)
            if col==1
                if strcmp(restTestMv{row,colNum(col)},'female')==1
                    testX(row,col)=0;
                end
                if strcmp(restTestMv{row,colNum(col)},'male')
                    testX(row,col)=1;
                end    
            end
            % parch and pclass
            if col==2 || col==5 || col==6 || col==7
                testX(row,col)=restTestMv{row,colNum(col)};
            end
            % fare
            if col == 3
                if isnan(restTestMv{row,colNum(col)}(1))==1
                    testX(row,col)=33.2955;
                else
                    testX(row,col)=restTestMv{row,colNum(col)};
                end
            end
            if col==4
                if isnan(restTestMv{row,colNum(col)}(1))==1
                    testX(row,col)=1;
                else
                    if strcmp(restTestMv{row,colNum(col)},'S')==1
                       testX(row,col)=1; 
                    elseif strcmp(restTestMv{row,colNum(col)},'C')==1
                        testX(row,col)=2;
                    else
                        testX(row,col)=3;
                    end
                                
                end
            end
        end
    end
    
    assignin('base', 'testXnotNormal', (testX));
    
    assignin('base', 'trainXnotNormal', (trainX));
    
    %%% Normalizing traing data
    for col=1:6
        m(col)=mean(trainX(:,col));
        sd(col)=std(trainX(:,col));
        for row=1:size(trainX,1)
            trainX(row,col)=(trainX(row,col)-m(col))/(sd(col));
        end
    end
    
    % for 7th column
    sum=0;
    
    for row=1:size(trainX,1)
        if isnan(trainX(row,7))==0
            sum=sum+trainX(row,7);
            
        end
    end
    m(7)=sum/(size(trainX,1));
    % Calculate std
    sum=0;
    for row=1:size(trainX,1)
        if isnan(trainX(row,7))==0
            sum=sum+power((trainX(row,7)-m(7)),2);
        end
    end

    sd(7)=sqrt(sum/(size(trainX,1)-1));
    % putting in vals.
    for row=1:size(trainX,1)
        if isnan(trainX(row,7))==0
            trainX(row,7)=(trainX(row,7)-m(7))/sd(7);
        end
    end
    assignin('base', 'trainX', (trainX));
    
    
    %%% Normalizing for test data
  
    
    for row=1:size(testX,1)
        for col=1:size(testX,2)
            if isnan(testX(row,col))==0
                testX(row,col)=(testX(row,col)-m(col))/sd(col);
            end
        end
    end
    assignin('base', 'testX', (testX));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%GLMFIT%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %trainFitTotal=calculatefitTrain(trainX,labelTrain,trainX);
    %%% Training Acc  %%%%%%%%
    %train_accu=calculateAcc(labelTrain,trainFitTotal);
    %fprintf(sprintf( 'Multiple models METHOD 1 training Acc  = %.3f\n',train_accu ));
    
    %%% testing
    acc=get(trainX,labelTrain,trainX,labelTrain);
    fprintf(sprintf( 'Multiple models training Acc  = %.3f\n',acc ));
    
    acc=get(trainX,labelTrain,testX,labelTest);
    fprintf(sprintf( 'Multiple models testing Acc  = %.3f\n',acc ));
    
    %%%%%%%%%%%%%%%%%% Subsituting Value %%%%%%%%%%%%%%%%%
    trainAvgX=getAvgMatrix(trainX);
    testAvgX=getAvgMatrix(testX);
    
    assignin('base', 'test_Partg', (testAvgX));
    assignin('base', 'train_Partg', (trainAvgX));
    
    %%%%%%%%%%%%%%%%%%%%%%%%*********Need to normalize**********%%%%%%%%%%%%%%%%%%%%%%%
    
    col=7;
    m=mean(testAvgX(:,col));
    s=std(testAvgX(:,col));
    for row=1:size(testAvgX,1)
        testAvgX(row,col)=(testAvgX(row,col)-m)/(s);
    end
    
    col=7;
    m=mean(trainAvgX(:,col));
    s=std(trainAvgX(:,col));
    for row=1:size(trainAvgX,1)
        trainAvgX(row,col)=(trainAvgX(row,col)-m)/(s);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%*******************%%%%%%%%%%%%%%%%%%%%%%%
    %trainAvgX(:,7)=normc(trainAvgX(:,7));
    %testAvgX(:,7)=normc(testAvgX(:,7));
    
    %%% Traning Accuracy %%%
    acc=getAvgAcc(trainAvgX,labelTrain,trainAvgX,labelTrain);
    fprintf(sprintf( 'Subsituting value training Acc = %.3f\n',acc ));
    
    acc=getAvgAcc(trainAvgX,labelTrain,testAvgX,labelTest);
    fprintf(sprintf( 'Subsituting value testing Acc = %.3f\n',acc ));
    
    
    
    
end

function [z] = getAvgAcc(trainX,labelTrain,what,compare)
    c=getTest(trainX,labelTrain,what);
    for k=1:size(c,1)
        if c(k)>=0.5
            true(k)=1;
        else
            true(k)=0;
        end
    end
    
    z=calculateAcc(true',compare);
    
    
end

function [trainX] = getAvgMatrix(trainX)
    sum=0;
    total=0;
    for i=1:size(trainX,1)
        if isnan(trainX(i,7))==0
            sum=sum+trainX(i,7);
            total=total+1;
        end
    end
    avg=sum/total;
    for i=1:size(trainX,1)
        if isnan(trainX(i,7))==1
            trainX(i,7)=avg;
        end
    end
end

function [test_acc] = get(trainX,labelTrain,testX,labelTest)
    testFitTotal=getTest(trainX,labelTrain,testX);
    trainX6(:,1)=trainX(:,1);
    trainX6(:,2)=trainX(:,2);
    trainX6(:,3)=trainX(:,3);
    trainX6(:,4)=trainX(:,4);
    trainX6(:,5)=trainX(:,5);
    trainX6(:,6)=trainX(:,6);
    
    testX6(:,1)=testX(:,1);
    testX6(:,2)=testX(:,2);
    testX6(:,3)=testX(:,3);
    testX6(:,4)=testX(:,4);
    testX6(:,5)=testX(:,5);
    testX6(:,6)=testX(:,6);
    
   
    testFitLess=getTest(trainX6,labelTrain,testX6);
   
    
    for q=1:size(testFitTotal,1)
        if isnan(testFitTotal(q))==1
            testFitTotal(q)=testFitLess(q);
        end
        if(testFitTotal(q)>=0.5)
            testFitTotal(q)=1;
        else
            testFitTotal(q)=0;
        end
    end
    test_acc=calculateAcc(labelTest,testFitTotal);
    
end

function [getFit] = getTest(trainX,labelTrain,what)
    % Calculating traing accuracies:
    b=glmfit(trainX,labelTrain,'binomial','link','logit');
    getFit=glmval(b,what,'probit');
end


function [trainFitTotal] = calculatefitTrain(trainX,labelTrain,what)
    % Calculating traing accuracies:
    
    b=glmfit(trainX,labelTrain,'binomial','link','logit');
    trainFitTotal=glmval(b,what,'probit');
    
    
    
    %%% Producing trainXLeaveAge for those where age =Nan
    
    row=0;
    count=0;
    for i=1:size(trainX,1)
        if isnan(trainX(i,7))==1
            count=count+1;
            row=row+1;
            labelTrainWhereAgeNan(row)=labelTrain(i);
            for col=1:6
                trainXLeaveAge(row,col)=trainX(i,col);
            end
        end
    end
    
    labelTrainWhereAgeNan=labelTrainWhereAgeNan';
    
    
    b=glmfit(trainXLeaveAge,labelTrainWhereAgeNan,'binomial','link','logit');
    trainFitAgeNan=glmval(b,trainXLeaveAge,'probit');
    
    r=0;
    for row=1:size(trainFitTotal,1)
        if isnan(trainFitTotal(row))==1
            r=r+1;
            trainFitTotal(row)=trainFitAgeNan(r);
        end
        if(trainFitTotal(row)>=0.5)
            trainFitTotal(row)=1;
        else
            trainFitTotal(row)=0;
        end
            
    end
end

function [count] = calculateAcc(true,get)
    count=0;
    for i=1:size(true,1)
        if(true(i)==get(i))
            count=count+1;
        end
    end
    count=count/size(true,1);
end