clear;

scoreTable = [];
for fn=1:5
    file = strcat('copy train',num2str(mod(fn,5)),'.txt + train', num2str(mod(fn+1,5)), '.txt + train', num2str(mod(fn+2,5)), '.txt + train', num2str(mod(fn+3,5)), '.txt train.txt')
    system(file);
    V = containers.Map;
    % Var = cellstr('');
    ClassWords = containers.Map;
    ClassWordFre = containers.Map;
    exPerClass = containers.Map;
    % for fn=1:4
    %     fname = strcat('train',num2str(fn),'.txt');
    %     fid = fopen(fname);
        fid = fopen('train.txt');
        tline = fgetl(fid);
        N = 0;
        % Classes = cellstr('');
        while ischar(tline)
            temp = cellstr(strsplit(tline));
            if(isempty(ClassWords))
                exPerClass(strjoin(temp(1))) = 1;
                tempCW = cellstr('');
                CWF = containers.Map; %frequency of words in class
                for i=2:length(temp)    
        %            ClassWords(1,i) = temp(i);
                     tempCW(i-1) = temp(i);
                     if(isKey(CWF,strjoin(temp(i))))
                         f = CWF(strjoin(temp(i)));
                         CWF(strjoin(temp(i))) = f+1;
                     else
                         CWF(strjoin(temp(i))) = 1;
                     end
                     [V]=add2V(temp(i),V);
                end
        %         Classes(1) = temp(1);
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
        %                   ClassWords(j,x+i-1) = temp(i);
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
        %                    ClassWords(j+1,i) =temp(i);
                            tempCW(i-1) = temp(i);
                            if(isKey(CWF,strjoin(temp(i))))
                                 f = CWF(strjoin(temp(i)));
                                CWF(strjoin(temp(i))) = f+1;
                            else
                                CWF(strjoin(temp(i))) = 1;
                            end
                           [V] =  add2V(temp(i),V);
                       end
        %                Classes(j+1) = temp(1);
                       ClassWords(strjoin(temp(1))) = tempCW;
                       ClassWordFre(strjoin(temp(1))) = CWF;
                      break;
                   end
                end
            end
             N=N+1;
            tline = fgetl(fid);
        end
        fclose(fid);
    %     fn
    % end


    % Learning Naive Bayes Text
    prior = containers.Map;
    condProb = [];
    index = containers.Map;
    Classes = keys(exPerClass);
    Var = keys(V);
    for i=1:length(exPerClass)
        class =  strjoin(Classes(i));
    %     prior(i) = (exPerClass(class)+1)/(N+length(exPerClass));
        prior(class) = log(exPerClass(class)+1) - log(N+length(exPerClass));
        Nc = length(ClassWords(class)); %number of words in a particular class
        for j=1:length(Var) 
            classWordMap = ClassWordFre(class); %frequency of words in a class
            if(isKey(classWordMap,strjoin(Var(j))))
                Nj = classWordMap(strjoin(Var(j)));
            else 
                Nj = 0;
            end
    %         Nj = occur(ClassWordFre(class),Var(j));
    %         condProb(i,j-1) = (Nj+1)/(Nc+length(V));
              condProb(i,j) = log(Nj+1) - log(Nc+length(V));
              index(strjoin(Var(j))) = j;
        end
    end


    %testing of train2.txt
    file1 = strcat('train', num2str(mod(fn+4,5)), '.txt');
    fid1 = fopen(file1);
    tline1 = fgetl(fid1);
    givenClass = cellstr('');
    tempRand = randi([1 8],1,1446);
    randClass = cellstr('');
    predictedClass = cellstr('');
    l=1;
    priorM = [keys(prior);values(prior)];
    while ischar(tline1)
        randClass(l) = priorM(1,tempRand(l));
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
    Rscore = 0;
    for i=1:length(givenClass)
        if(strcmp(givenClass(i),predictedClass(i)))
            Pscore = Pscore+1;
        end
        if(strcmp(givenClass(i),randClass(i)))
            Rscore = Rscore+1;
        end
    end
    scoreTable(fn,1) = Pscore;
    scoreTable(fn,2) = Rscore;
end
PreAvgAcc = (sum(scoreTable(:,1)/1446))/5; % accuracy for prediceted categories
RandAvgAcc = (sum(scoreTable(:,2)/1446))/5; % accuracy  for random Assignment
ConMat = confusionmat(givenClass,predictedClass); % confusion Matrix
