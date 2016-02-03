mue = [];
S = [];
y = importdata('digitlabels.txt');
labels = y.data;
Error = [];
%initialisation of clustor centers
randAss = randi([1 1000],1,4);
for i=1:4
    mue(i,:) = Example(strcat('"',num2str(randAss(i)),'"'));
end

C = zeros(1,1000);
iter = [];
for it=1:20
    for i=1:1000
        minMue = Inf;
        x = Example(strcat('"',num2str(i),'"'));
        tempC = [];
        for j=1:4
            temp = sqrt(sum((abs(bsxfun(@minus,x,mue(j,:))).^2),2));
%             tempC(j,:) = [temp,j];
            if(temp<minMue)
                minMue = temp;
                C(i) = j;
            end
        end
%         C(i) = min(tempC(2));
        
    end
    for j=1:4
        denom = zeros(1,786);
        numer = 0;
        for i=1:1000
           x = Example(strcat('"',num2str(i),'"'));
           if(C(i) == j)
               denom = denom + x;
               numer = numer + 1;
           end
        end
        mue(j,:) = denom/numer;
    end
    s = 0;
    clstrLabel = zeros(4,4);
    for i=1:1000
        x = Example(strcat('"',num2str(i),'"'));
        s = s + sum((abs(bsxfun(@minus,x,mue(C(i),:)))),2);
        if(labels(i)==1)
            clstrLabel(C(i),1) = clstrLabel(C(i),1)+1;
        elseif(labels(i)==3)
            clstrLabel(C(i),2) = clstrLabel(C(i),2)+1;
        elseif(labels(i)==5)
            clstrLabel(C(i),3) = clstrLabel(C(i),3)+1;
        else
            clstrLabel(C(i),4) = clstrLabel(C(i),4)+1;
        end
    end 
    S(it) = s;
    iter(it) = it;
    Error(it) = 0;
    for k=1:4
        Error(it) = Error(it) + sum(clstrLabel(k,:)) - max(clstrLabel(k,:));
    end
    Error(it) = Error(it)/1000;
end

figure

plot(iter,S,'rp-');
xlabel('Number of Iteration');
ylabel ('Goodness (S)');
figure
plot(iter,Error,'bp-');
xlabel('Number of Iteration');
ylabel ('Error');