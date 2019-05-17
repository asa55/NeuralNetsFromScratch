function truth = TRUTH()
%TRUTH returns the expected output node activations for every input
%   Generates column vectors along dimension 3 corresponding to correct
%   output sequences. This is known for this problem due to image order.

truth = [ones(1,1,55*62);zeros(61,1,55*62)];
for i = 1:55*62
    truth(:,1,i) = circshift(truth(:,1,i),floor((i-1)/55));
end

end

