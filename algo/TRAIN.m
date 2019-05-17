function training = TRAIN()
%TRAIN Returns random indexes by picking 50 out of every 55 in-class images

training = zeros(1,50*62);
for i = 1:62
    training((i-1)*50+1:(i-1)*50+50) = sort(randperm(55,50))+55*(i-1);
end


end

