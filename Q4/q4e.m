hand = im2double(imread('hands.ascii.pgm'));
hand1 = imresize(hand,[19 19]);
handv = reshape(hand1, 1, 361);
for i=1:50
    temp = handv * V(:,i);
    Egn(:,i) = temp*V(:,i);
end
proI = [];
for i=1:361
    proI(i) = 0;
    for j=1:50
        proI(i) = proI(i) + Egn(i,j);
    end
end
figure
imshow(vec2mat(proI,19)',[]);
figure
imshow(hand);