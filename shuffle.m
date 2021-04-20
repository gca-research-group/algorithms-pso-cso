function [out]= shuffle(x)
out=x(randperm(length(x)));
end