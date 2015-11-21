function gradDecent()
    train = evalin('base', 'train_Partg');
    test = evalin('base', 'test_Partg');
    
    labelTrainCell = evalin('base', 'surviveTrain');
    labelTestCell = evalin('base', 'surviveTest');
    labelTrain=cell2mat(labelTrainCell);
    labelTest=cell2mat(labelTestCell);
    
    gradPart(train,labelTrain);
    
    newtonsPart(train,labelTrain);
    
    
end

function newtonsPart(train,labelTrain)
  
    fprintf(sprintf( '######## Newtons Method #########\n' ));
    
    figure;
    iterations=[5,10,15,25];
    for i=1:size(iterations,2)
        [~,gradacc(i),glmacc,convergenceIter,converged]=callGrad(train,[0,0],labelTrain,iterations(i));
    end
    fprintf(sprintf( 'Training Accuracy using glmfit =%d\n',glmacc));
    plot(iterations,gradacc)
    xlabel('Iterations');
    ylabel('Accuracy');
    title('Newtons Method taking initial point of [0,..,0]');
    newtonsAccuracy=gradacc';
    iterations=iterations';
    Newton=table(newtonsAccuracy,iterations)


end

function [hessian]= calculateHessian(X,W)
    hessian=transpose(X)*((diag(sigmod(X*W))*diag(1-sigmod(X*W)))*X);
end


function gradPart(train,labelTrain)
    %Gradient Descent
    figure;
    stepsize=.00001;
    %iterations=[500,5000,10000,15000,40000,65000]; 
    iterations=[100,500,1000,1500,5000,7500];
    for i=1:size(iterations,2)
        [~,gradacc1(i),glmacc1,convergenceIter,converged]=callGrad(train,stepsize,labelTrain,iterations(i));
    end
    subplot(2,2,1);
    plot(iterations,gradacc1);
    xlabel('Iterations');
    ylabel('Accuracy');
    title('stepsize=0.00001')
    
    
    stepsize=.0001;
    iterations=[1,500,1000,1500,2000,2500];
    for i=1:size(iterations,2)
        [~,gradacc2(i),glmacc2,convergenceIter,converged]=callGrad(train,stepsize,labelTrain,iterations(i));
        %convergenceIter
    end
    subplot(2,2,2);
    plot(iterations,gradacc2);
    xlabel('Iterations');
    ylabel('Accuracy');
    title('stepsize=0.0001')
    
    
    
    stepsize=.01;
    iterations=[1,5,10,15,20,25];
    for i=1:size(iterations,2)
        [~,gradacc3(i),glmacc3,convergenceIter,converged]=callGrad(train,stepsize,labelTrain,iterations(i));
        %convergenceIter
    end
    subplot(2,2,3);
    plot(iterations,gradacc3);
    xlabel('Iterations');
    ylabel('Accuracy');
    title('stepsize=0.01')
    
    
    
    %Gradient Descent
    predictedVal=[gradacc1(6);gradacc2(6);gradacc3(6)];
    stepSize=[0.00001;.0001;0.01];
    
    fprintf(sprintf( '######## Gradient Descent Method #########\n' ));
    fprintf(sprintf( 'Training Accuracy using glmfit =%d\n',glmacc3));
    fprintf(sprintf( 'Predicted value by gradient descent: \n'));
    gradientDescent=table(stepSize,predictedVal)
    
    
end


function [predictions,gradacc,glmacc,iter,converged] = callGrad(train,stepsize,labelTrain,iterations)
    [predictions,converged,iter]=gradD(train,stepsize,labelTrain,iterations);
    b=glmfit(train,labelTrain,'binomial','link','logit');
    o=glmval(b,train,'probit');
    glmacc=calculateAcc(labelTrain,o);
    if converged==1
        [gradacc]=calcuateAccPredictions(predictions,labelTrain);
    else
        [gradacc]=calcuateAccPredictions(predictions,labelTrain);
    end
end

function [count]=calcuateAccPredictions(predictions,labelTrain)
    count=0;
    for i=1:size(predictions,1)
        if(predictions(i)==labelTrain(i))
            count=count+1;
        end
    end
    count=(count)/(size(predictions,1));
end


function [predictions,converged,iter] = gradD(X,stepsize,labels,iterations)
    % n is the number of features
    iter=iterations;
    converged=0;
    %X=horzcat(ones(size(X,1),1),X);
    W_old=zeros(size(X,2),1);
    
    predictions=zeros(size(X,1),1);
    if(size(stepsize,2)>1)
        
        %W_old
        stepsize=calculateHessian(X,W_old);
        %stepsize
    end
    while(iterations>0)
        transX=transpose(X); 
        %iterations
        if(size(stepsize,2)>1)
            %stepsize
            W_new=W_old-(stepsize)\(transX*(sigmod(X*W_old)-labels));
            %W_new
        else
            W_new=W_old-stepsize*(transX*(sigmod(X*W_old)-labels));
            %W_new
        end
        
        %abs(W_new-W_old)
        %{
        if(checkCondition(W_new,W_old,.0001)==1)
            converged=1;
            break;
        end
        %}
        
        
        W_old=W_new;
        
        iterations=iterations-1;
        if(size(stepsize,2)>1)
            %W_new
            stepsize=calculateHessian(X,W_new);
        end
    end
    %%%%%
    Ypredict=sigmod(X*W_old);
    for i=1:size(Ypredict,1)
        if Ypredict(i)>=0.5
            predictions(i)=1;
        else
            predictions(i)=0;
        end
    end
    iter=iter-iterations;
    
    %%%%%%%
    
end

function [stop]= checkCondition(W_new,W_old,stepsize)
    count=0;
    for i=1:size(W_new,1)
        if(abs(W_new(i,1)-W_old(i,1))<stepsize)
            count=count+1; 
        end
    end
    if(count==size(W_new,1))
        stop=1;
    else
        stop=0;
    end
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
% Given a matrix the sigmoid (m*1)
function [S]=sigmod(S)
    for i=1:size(S,1)
        S(i)=1/(1+exp(-S(i)));
    end
end