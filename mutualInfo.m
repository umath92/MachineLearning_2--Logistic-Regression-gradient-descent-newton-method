function mutualInfo()
    train = evalin('base', 'restTrain');
    surviveLabel = evalin('base', 'surviveTrain');
    
    % remove NaN values. store in new array
    sL=cell2mat(surviveLabel(:));
    
    colNum=[1,4,5,6,8];
    %colNum=[1];
    
    %doing only for first column
    mutualI=zeros(size(colNum,2),1);
    for col=1:size(colNum,2)
        trainMat={};
        index=1;
        for row=1:size(train,1)
            if (isnan(train{row,colNum(col)})==0)
                trainMat{index,1}=train{row,colNum(col)};
                trainMat{index,2}=surviveLabel{row};
                index=index+1;
            end
        end
        % check if double vale|
        trainMat=cell2mat(trainMat);
        % Sort the rows
        [trainMat(:,1), indices] = sort(trainMat(:,1));
        %disp('Iteration number')
        %disp(col)
        %disp('Size of training mat')
        %size(trainMat(:,1))
        trainNew=zeros(size(trainMat(:,1),1),1);
        for k=1:size(indices,1)
            trainNew(k)=trainMat(indices(k),2);
        end        
        %disp('Size of trainign new')
        %size(trainNew)
        trainMat(:,2)=trainNew;
        %disp('Size of training mat')
        %size(trainMat(:,1))
        % sorted tainMat
        len1=int64(size(trainMat,1)/10);
        len=(size(trainMat,1)/10);
        pos=zeros(10,1);
        for j=1:10
            for i=len1*(j-1)+1:len1*j
                if i<size(trainMat,1)
                    if (trainMat(i,2))==1
                        pos(j)=pos(j)+1;
                    end
                end
            end
        end
        neg=len-pos;
        %neg
        %pos
        hVal=0;
        for i=1:10
            hVal=hVal-(1/10)*((pos(i)/len)*log(pos(i)/len)+(neg(i)/len)*log(neg(i)/len));
        end
        %hVal
        mutualI(col)=-(sum(pos)/(sum(pos)+sum(neg)))*log(sum(pos)/(sum(pos)+sum(neg)))-(sum(neg)/(sum(pos)+sum(neg)))*log(sum(neg)/(sum(pos)+sum(neg)));
        mutualI(col)=mutualI(col)-hVal;
        
        
    end
        %colName={'pclass','age','sibsp','parch','fare'}
        %mutualI
        %assignin('base', 'mutual', sort(mutualI));
        %colNum=[2,3,7,9,10,11,12,13];
        mutualRest(mutualI);
end



function mutualRest(mutualI1)
    train = evalin('base', 'restTrain');
    test = evalin('base', 'restTest');
    %%%%%%%%%% Convert all columns to cell array %%%%%%%%%%%%%%
    colNum=[2,3,7,9,10,11,12,13];
    
    for col=1:size(colNum,2)
        for row=1:size(train,1)
            train{row,colNum(col)}=num2str(train{row,colNum(col)});
        end
    end
    
    for col=1:size(colNum,2)
        for row=1:size(test,1)
            test{row,colNum(col)}=num2str(test{row,colNum(col)});
        end
    end
    %%%%%%%%%% Convert all columns to cell array %%%%%%%%%%%%%%
    
    
    surviveLabel = evalin('base', 'surviveTrain');
    colName={'name','sex','ticket','cabin','embarked','boat','body','home.dept'};
    
    as=cell2mat(surviveLabel);
    
    tot=-(sum(as)/(size(as,1)))*log((sum(as)/(size(as,1))))-((size(as,1)-sum(as))/(size(as,1)))*log((size(as,1)-sum(as))/(size(as,1)));
    
    %colNum=[2,3,7,9,10,11,12,13]; 
    colNum=[2,3,7,9,10,11,12,13];
    MI=zeros(size(colNum,1),1);
    %column of reference = colNum(col)
    for col=1:size(colNum,2)
        % create set of unique char
        % get unique elements
        uniq=unique(train(:,colNum(col)));
        %uniq
        
        matrix1=zeros(size(uniq,1),1);
        matrix0=zeros(size(uniq,1),1);
        matrixMI=zeros(size(uniq,1),1);
        
        
        % for ele in setQ
        for index=1:size(uniq,1)
            p=num2str(uniq{index});
            if ~strcmp('NaN',p)
                for row=1:size(train,1)
                        if isequal(uniq(index),train(row,colNum(col)))==1
                            if surviveLabel{row}==1
                                matrix1(index)=matrix1(index)+1;
                            else
                                matrix0(index)=matrix0(index)+1;
                            end
                        end
                end
            end
        end
        %matrix1
        %size(matrix0,1)
        %size(matrix1,1)
        
        assignin('base', 'matrix0', matrix0);
        assignin('base', 'matrix1', matrix1);
        
        % total
        total=0;
        for k=1:size(matrix1,1)
            total=total+matrix1(k)+matrix0(k);
        end
        for k=1:size(matrix1,1)
            if matrix1(k)+matrix0(k)~=0
                if matrix1(k)==0
                    matrixMI(k)=0;
                elseif matrix0(k)==0
                    matrixMI(k)=0;
                else
                    matrixMI(k)=-((matrix1(k)+matrix0(k))/(total));
                    matrixMI(k)=matrixMI(k)*((matrix1(k)/(matrix1(k)+matrix0(k)))*log(matrix1(k)/(matrix1(k)+matrix0(k))) + (matrix0(k)/(matrix1(k)+matrix0(k)))*log(matrix0(k)/(matrix1(k)+matrix0(k))));
                end
            end
           
        end
        
        wAvg=0;
        %matrixMI
        for k=1:size(matrix1,1)
            if isnan(matrixMI(k))==0
                wAvg=wAvg+matrixMI(k);
            end
        end
        MI(col)=tot-wAvg;
    end
    colName={'name','sex','ticket','cabin','embarked','boat','body','home.dept','pclass','age','sibsp','parch','fare'};
    
    %colName
    %MI'
    MI=MI';
    
    MI=vertcat(MI,mutualI1);
    
    
    [MI, indices] = sort(MI,'descend');
    %disp('Iteration number')
    %disp(col)
    %disp('Size of training mat')
    %size(trainMat(:,1))
    
    
    for k=1:size(MI,1)
        colNameNew(k)=colName(indices(k));
    end
    
    %colNameNew
    %MI
    Features=colNameNew';
    table(Features,MI)
    
    
end


