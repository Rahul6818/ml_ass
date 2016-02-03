function [V] = add2V(word,V)
    word = strjoin(word);
    if(~isKey(V,word))
        V(word) = word;
%         VarL = length(Var);
%         Var(VarL+1) = cellstr(word);        
    end
end
