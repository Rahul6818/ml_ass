clear;
Dir = dir('E:\IIT-Acd\Semesters\6th Sem\ML\A3\q4\q5_data\*.pgm');
Images = cell(1,numel(Dir));

avgImgMat = im2double(imread(Dir(1).name));
Images{1} = (imread(Dir(1).name));

for i=2:numel(Dir)
    I = im2double(imread(Dir(i).name));
    avgImgMat = avgImgMat + I;
    Images{i} = imread(Dir(i).name);
end

avgImgMat = avgImgMat/numel(Dir);   
imshow((avgImgMat));
%%%% normalisation of training examples %%%%%%%%%%
ImageMat = zeros(length(Images),361);
for i=1:length(Images)
    ImageMat(i,:) = reshape(cell2mat(Images(i)), 1, 361);
end

for i=1:length(ImageMat)
    ImageMat(i,:) = ImageMat(i,:) - mean(ImageMat);
end

[U,S,V] = svd(ImageMat/sqrt(360));

fid = fopen('PC_50.txt','wt');
for j=1:50
    for i=1:361
        fprintf(fid,'%f\t',V(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);

% show image for Principle component 1
%imshow(vec2mat(V(:,1),19)',[])
