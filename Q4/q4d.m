while(1)
    promt = 'Face ID: ';
    ex = input(promt);
    Egn = [];
    for i=1:50
        temp = ImageMat(ex,:)*V(:,i);
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
    imshow(vec2mat(ImageMat(ex,:),19)',[]);
end
