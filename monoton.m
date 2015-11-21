function monoton()
    % Note: loadData neads to run beofre monoton.m
    colNum=[1,4,5,6,8];
    colName={'pclass','age','sibsp','parch','fare'};
    train = evalin('base', 'restTrain');
    surviveLabel = evalin('base', 'surviveTrain');
    %Divide into 10 bins. This skips NaN values. Each bin does not have
    %same number of samples.
    
    % convert it to a matrix
    
    %find max and min values
    matSt=cell2mat(surviveLabel(:));
    pl=1;
    figure
    for col=1:size(colNum,2)
        countInd=zeros(10,1);
        trainMat=cell2mat(train(:,colNum(col)));
        bin=(max(trainMat)-min(trainMat))/10;
        if bin>1
            % interate through 0, bin .. bin, 2*bin, .. 10* bin
            for i=1:size(train,1)
                if (isnan(trainMat(i))==0)
                    if trainMat(i)<1*bin
                        countInd(1)=countInd(1)+matSt(i);
                    elseif trainMat(i)<2*bin
                        countInd(2)=countInd(2)+matSt(i);
                    elseif trainMat(i)<3*bin
                        countInd(3)=countInd(3)+matSt(i);
                    elseif trainMat(i)<4*bin
                        countInd(4)=countInd(4)+matSt(i);
                    elseif trainMat(i)<5*bin
                        countInd(5)=countInd(5)+matSt(i);
                    elseif trainMat(i)<6*bin
                        countInd(6)=countInd(6)+matSt(i);
                    elseif trainMat(i)<7*bin
                        countInd(7)=countInd(7)+matSt(i);
                    elseif trainMat(i)<8*bin
                        countInd(8)=countInd(8)+matSt(i);
                    elseif trainMat(i)<9*bin
                        countInd(9)=countInd(9)+matSt(i);
                    else
                        countInd(10)=countInd(10)+matSt(i);
                        
                    end
                end
            end
            
            colNum(col);
            subplot(2,3,pl);
            pl=pl+1;
            countInd=countInd.*(1/(size(trainMat(:,1),1)));
            bar(countInd);
            title( char( sprintf( colName{col} ) ) );
        else
            %%%%%%%%%%%%%%%%%%
            %bin
            arr=zeros((bin*10)+1,1);
            index=1;
            %max(trainMat)
            for i=min(trainMat):max(trainMat)
                for row=1:size(train,1)
                    if (isnan(trainMat(row))==0)
                        if trainMat(row)==i
                            arr(index)=arr(index)+matSt(row);
                        end
                    end
                end
                index=index+1;
            end
            subplot(2,3,pl);
            pl=pl+1;
            
            arr=arr.*(1/(size(trainMat(:,1),1)));
            bar(arr);
            title( char( sprintf( colName{col} ) ) );
        end
        
        
    end
    
    
    
    %{
    [sorted, indices] = sort(c)
    train=sort(train);
    l=[x for (y,x) in sorted(zip(train,surviveLabel))];
    
    %[x for (y,x) in sorted(zip(Y,X))]
    countInd=zeros(10,size(colNum,2));
    for col=1:size(colNum,2)
        i=1;
        initial=1;
        for row=1:10
            while(i<(size(train,1)/10)*initial)
                % ==0 means for 
                if (isnan(train{i,colNum(col)}(1))==0)
                    countInd(row,col)=countInd(row,col)+surviveLabel{i};
                end
                i=i+1;
            end
            initial=initial+1;
        end
    end
    countInd
    countInd=countInd.*1/(size(train,1)/10);
    
    figure
    for i=1:5
        subplot(2,3,i);
        bar(countInd(:,i));
        title( char( sprintf( colName{i} ) ) );
    end
    %}
end