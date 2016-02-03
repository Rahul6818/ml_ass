clear
file = strcat('copy train0.txt + train1.txt + train2.txt + train3.txt train.txt');
system(file);
scoreTable = [];
no=1;
trnEx = 1000;
while(trnEx<=5784)
    V = containers.Map;
    ClassWords = containers.Map;
    ClassWordFre = containers.Map;
    exPerClass = containers.Map;
    fid = fopen('train.txt');
    tline = fgetl(fid);
    N = 0;
    while ischar(tline)
        if(N<=trnEx)
            temp = cellstr(strsplit(tline));
            if(isempty(ClassWords))
                exPerClass(strjoin(temp(1))) = 1;
                tempCW = cellstr('');
                CWF = containers.Map; %frequency of words in class
                for i=2:length(temp)    
                     tempCW(i-1) = temp(i);
                     if(isKey(CWF,strjoin(temp(i))))
                          f = CWF(strjoin(temp(i)));
                          CWF(strjoin(temp(i))) = f+1;
                     else
                          CWF(strjoin(temp(i))) = 1;
                     end
                     [V]=add2V(temp(i),V);
                end
                ClassWords(strjoin(temp(1))) = tempCW;
                ClassWordFre(strjoin(temp(1))) = CWF;

            else
                Classes = keys(ClassWords);
                m = length(Classes);
                for j=1:m
                    cls = Classes(j);
                    if(strcmp(cls,temp(1)))
                        oldNc = exPerClass(strjoin(cls));
                        exPerClass(strjoin(temp(1))) = oldNc+1;
                        tempCW = ClassWords(strjoin(temp(1)));
                        x = length(tempCW);
                        CWF = ClassWordFre(strjoin(temp(1)));
                        for i=2:length(temp)
                            tempCW(x+i-1) = temp(i);
                            if(isKey(CWF,strjoin(temp(i))))
                                 f = CWF(strjoin(temp(i)));
                                 CWF(strjoin(temp(i))) = f+1;
                            else
                                 CWF(strjoin(temp(i))) = 1;
                            end
                            [V] = add2V(temp(i),V);
                         end
                         ClassWords(strjoin(temp(1))) = tempCW;
                         ClassWordFre(strjoin(temp(1))) = CWF;
                         break;
                   end

                   if(j == m)
                        exPerClass(strjoin(temp(1))) = 1;
                        tempCW = cellstr('');
                        CWF = containers.Map;
                        for i=2:length(temp)
                            tempCW(i-1) = temp(i);
                            if(isKey(CWF,strjoin(temp(i))))
                                 f = CWF(strjoin(temp(i)));
                                 CWF(strjoin(temp(i))) = f+1;
                            else
                                 CWF(strjoin(temp(i))) = 1;
                            end
                             [V] =  add2V(temp(i),V);
                        end
                        ClassWords(strjoin(temp(1))) = tempCW;
                        ClassWordFre(strjoin(temp(1))) = CWF;
                        break;
                    end
                end
           end
          N=N+1;
        end
        tline = fgetl(fid);
    end
    fclose(fid);

    'Learning Naive Bayes Text'
    prior = containers.Map;
    condProb = [];
    index = containers.Map;
    Classes = keys(exPerClass);
    Var = keys(V);
    for i=1:length(exPerClass)
        class =  strjoin(Classes(i));
        prior(class) = log(exPerClass(class)+1) - log(N+length(exPerClass));
        Nc = length(ClassWords(class)); %number of words in a particular class
        for j=1:length(Var) 
            classWordMap = ClassWordFre(class); %frequency of words in a class
            if(isKey(classWordMap,strjoin(Var(j))))
                Nj = classWordMap(strjoin(Var(j)));
            else 
                Nj = 0;
            end
              condProb(i,j) = log(Nj+1) - log(Nc+length(V));
              index(strjoin(Var(j))) = j;
        end
    end

    
    'testing of train2.txt'
    file1 = strcat('train5.txt');
    fid1 = fopen(file1);
    tline1 = fgetl(fid1);
    givenClass = cellstr('');
    predictedClass = cellstr('');
    l=1;
    priorM = [keys(prior);values(prior)];
    while ischar(tline1)
        example = cellstr(strsplit(tline1));
        givenClass(l) = example(1);
        prob = -Inf;
        for j=1:length(prior)
            tempProb = cell2mat(priorM(2,j));
            for i=2:length(example)
                if(isKey(index,strjoin(example(i))))
                    indx = index(strjoin(example(i)));
                    tempProb = tempProb + condProb(j,indx);
                else
                    continue;
                end
            end
            if(tempProb > prob)
                predictedClass(l) = priorM(1,j);
                prob = tempProb;
            end
        end
        l = l+1;
        tline1 = fgetl(fid1);
    end
    fclose(fid1);

    Pscore = 0;
    for i=1:length(givenClass)
        if(strcmp(givenClass(i),predictedClass(i)))
            Pscore = Pscore+1;
        end
    end
    acc = Pscore/1446;
    scoreTable(no,:) = [trnEx,acc];no=no+1;
    trnEx
    if(trnEx==5000)
        trnEx = 5784;
    else    
        trnEx = trnEx+1000;
    end
end
figure
plot(scoreTable(:,1),scoreTable(:,2),'rp-');
xlabel('Number of Training Examples');
ylabel('Accuracy');
title ('Learning Curve');
