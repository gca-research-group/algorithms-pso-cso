function [poolconfig] = PopulationGeneration(numsolutions,numpools,totthreads)

poolconfig=zeros(numsolutions,numpools);
sumthreads=zeros(numsolutions,1);
n=totthreads-(numpools-1);
availablethreads=zeros(numsolutions,1);

for i=1:numsolutions
    poolconfig(i,1)= randi([1,n]);
    sumthreads(i,1)=poolconfig(i,1);
    availablethreads(i,1)=totthreads-sumthreads(i,1);
end

availablepools=numpools-1;

for i=1:numsolutions
    for j=2:numpools-1
        poolconfig(i,j)= randi([1,availablethreads(i,1)-(availablepools-1)]);
        sumthreads(i,1)=sumthreads(i,1)+ poolconfig(i,j);
        availablethreads(i,1)=totthreads-sumthreads(i,1);
        availablepools=availablepools-1;
    end
    availablepools=numpools-1;
    poolconfig(i,numpools)=totthreads-sumthreads(i,1);
 
end
 

