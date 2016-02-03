clear;
fid = fopen('digitdata.txt');
pxlPresent = [];
tline = fgetl(fid);
pxl = cellstr(strsplit(tline));
for i=1:length(pxl)-1
    temp = (strsplit(strjoin(pxl(i)),'"'));
    temp = strjoin(temp(2));
    temp = strsplit(temp,'l');
    temp = str2num(strjoin(temp(2)));
    pxlPresent(i) = temp;
end    
Example = containers.Map;
tline = fgetl(fid);
while ischar(tline)
    ex = cellstr(strsplit(tline));
    pixel = [];
    c = 1; 
    j=2;
    for i=1:786
        if((c<157) && (i) == pxlPresent(c))
            pixel(i) = str2num(strjoin(ex(j))); j=j+1; c=c+1;
        else
            pixel(i)=0;
        end
    end
    Example(strjoin(ex(1))) = pixel;
    tline = fgetl(fid);
end
fclose(fid);
while(1)
    promt = 'Give example number: ';
    x = input(promt);
    if(x>1000)
        promt = 'Index Out of range. Please give example less than 1000';
    else
        imgMat = vec2mat(Example(strcat('"',num2str(x),'"')),28);
        image(imgMat);
    end
end  