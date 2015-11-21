function loadData()
    [~,~,rawOld] = xlsread('titanic3.xls');
    [~,k]=size(rawOld(1,:));
    for i=2:size(rawOld)
        for j=1:k
            raw(i-1,j)=rawOld(i,j);
        end
    end
    
    assignin('base', 'rawOld', rawOld);
    assignin('base', 'raw', raw);
    [r,c]=size(raw);
    col=rawOld(1,:);
    count=zeros(c,1);
    for i=1:c
        for j=1:r
            if isnan(raw{j,i}(1))==1
                count(i,1)=count(i,1)+1;
            end
        end
    end
    for i =1:c
        fprintf(col{i});
        fprintf(sprintf( ' %d\n',count(i)));
    end
    %%%%%%%%% Split data into half %%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    keySet=zeros(r,1);
    valueSet=zeros(r,1);
    mapObj = containers.Map(keySet,valueSet);
    
    
    q=1;
    
    while(q<=(r/2))
        num=randi(r,1);
        if isKey(mapObj,num)~=1
            mapObj(num) = 1;
            trainArr(q,:)=raw(num,:);
            q=q+1;
        end
    end
    q=1;
    for i=1:r
        if isKey(mapObj,i)~=1
            testArr(q,:)=raw(i,:);
            q=q+1;
        end
    end
    
    % get out serviceLabel
    
    surviveTrain=trainArr(:,2);
    assignin('base', 'surviveTrain', surviveTrain);
    restTrain=trainArr(:,1);
    for j=3:c
            restTrain=horzcat(restTrain,trainArr(:,j));
    end
    assignin('base', 'restTrain', restTrain);
    
    %%%%%%%%%%%%%%%%%%%%
    surviveTest=testArr(:,2);
    assignin('base', 'surviveTest', surviveTest);
    restTest=testArr(:,1);
    for j=3:c
            restTest=horzcat(restTest,testArr(:,j));
    end
    assignin('base', 'restTest', restTest);
    
    
    if size(restTest,1)+size(restTrain,1)==size(raw,1)
        fprintf(sprintf( 'Finished making separte files for training and testing...\n'));
    end
    
end
