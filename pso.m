tic;
% parametros do problema
timeprocessing=[2.005;2.005;3.005;3.005;2.005;2.005;4.553;2.005;4.553;2.005;2.005];
totmessages=1000000;
totthreads=50;
numsolutions=50;
numpools=size(timeprocessing,1);
% de c larat ion of the parameters of PSO algor i thm
N=50; c1=2; c2=2; MAX=25; Iter =0; D=11;
% cons t r a int s d e f i n i t i o n for a l l de c i s ion v a r i a b l e s
Pmin (1,1:D)=1;Pmax(1,1:D)=5;
% the swarm P is created randomly
[P]=PopulationGeneration(numsolutions,numpools,totthreads);
%P=zeros(N,D)+(Pmax(1,:)-Pmin(1,:)).*rand(N,D)+Pmin(1,:) ;
% vector Gbest} is created
Gbest=zeros(1,D);
% all the particles from swarm P are remembered in swarm Pbest
Pbest=P;
% velocity vectoris created for all particles in swarm P
V=zeros(N,D);
% the whole swarm P i s evaluat ed using objective func t ion OF(.)
for k=1:numsolutions
    Eval(k,1)=ProcessingTimeCalculation(timeprocessing,P(k,:),totmessages);
end
%Eval=ProcessingTimeCalculation(timeprocessing,P,totmessages);
% the swarm Pbest i s e valuat ed using objective func t ion OF(.)
EvalPbest=Eval;
% the best particle is chosen from the swarm P
[Y,I]=min(Eval(:,1));
% the best particle from the swarm P is stored in Gbest
Gbest (1,:)=P(I,:);
% the OF(.) value of the best particle is stored in EvalGbest
EvalGbest=Y;
% main program loop starts
while (Iter<MAX)
    % number of iterationis increased by one
    Iter=Iter+1;
    % the velocity vector for each particle is computed
    V=V+c1*rand()*(Pbest-P)+c2*rand()*(Gbest-P);
    % the new position for each particle is computed
    P=P+V;
    % the constraints for each decision variable are checked
    for i =1:N
        for j =1:D
            if P(i,j)<Pmin(1,j)
                P(i,j)=Pmin(1,j);
            end
            if P(i,j)>Pmax(1,j)
                P(i,j)=Pmax(1,j);
            end
        end
    end
    % the whole swarm P is evaluated using objective function OF(.)
    P=round(P);
    for k=1:numsolutions
    Eval(k,1)=ProcessingTimeCalculation(timeprocessing,P(k,:),totmessages);
    end
    % the Pbest swarm is updated if needed
    for i =1:N
        if Eval(i,1)<EvalPbest(i,1)
            Pbest(i,:)=P(i,:);
        end
    end
    % the best particle is chosen from the swarm P
    [Y,I]=min(Eval(:,1));
    % the Gbest v e c tor is updated i f needed
    if Eval(I,1)<EvalGbest
        Gbest(1,:)=P(I,:);
        EvalGbest=Y;
    end
end
% the result of PSO algorithm is returned
disp(EvalGbest);
disp(Gbest);
toc