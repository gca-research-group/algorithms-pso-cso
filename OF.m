function[out]=OF(P)
[x,y]=size(P);
out=zeros(x,1);
for i =1:x
for j =1:y
out (i,1)=out(i,1)+P(i,j)^2;
end
end