function [makespan,vetor]=cso
clear all;
tic;
% parametros do problema
timeprocessing=[2.005;2.005;3.005;3.005;2.005;2.005;4.553;2.005;4.553;2.005;2.005];
totmessages=1000000;
totthreads=50;
% definition of the parameters of CSO algorithm
D=size(timeprocessing,1); N=100; MAX=100; MR=0.2;
SMP=80; SRD=0.2; CDC=3; c1=0.5; M=round(totthreads/D*3);
% definition of arrays required by CSO algorithm
copies=zeros(SMP,D); numberOfCopies=SMP;
V=zeros(N,D); EvalPbest=zeros(N,1); Gbest=zeros(1,D);
flag=zeros(N,1);dimensionsToChange=zeros(1,D); Iter=0;
g=zeros(N,D);r=ones(N,D);
% population of cats is randomly created
[P]=PopulationGeneration(N,D,totthreads);
Pbest=P;
% population of cats is evaluated
tic;
for k=1:N
    Eval(k,1)=ProcessingTimeCalculation(timeprocessing,P(k,:),totmessages);
end
toc
EvalPbest(:,1)=Eval(:,1);
% see king the best cat
[Y,It]=min(Eval(:,1));
TheBest=It;
EvalGbest=Y;
Gbest=P(TheBest,:);
% the main loop of the CSO algorithm
while(Iter<MAX)
    Iter=Iter+1;
    catsInSeekingMode=(1-MR)*N;
    for i=1:N
        if i<catsInSeekingMode
            flag(i,1)=0;
        else
            flag(i,1)=1;
        end
    end
    flag=shuffle(flag);
    for i=1:N
        if flag(i,1)==0
            dimensionsToChange(1,:)=0;
            dimensionsToChange(1,1:CDC)=1;
            for c=1:numberOfCopies
                copies(c,:)=P(i,:);
            end
            for c=1:numberOfCopies
                dimensionsToChange=shuffle(dimensionsToChange);
                for j =1:D
                    if dimensionsToChange(1,j)==1
                        if rand( )>0.5
                            copies(c,j)=copies(c,j)+SRD*copies(c,j)*rand( );
                        else
                            copies(c,j)=copies(c,j)-SRD*copies(c,j)*rand( );
                        end
                    end
                end
            end
            selectedCopy=randi(SMP);
            for j =1:D
                P(i,j)=copies(selectedCopy,j);
            end
        else
            for j =1:D
                V(i,j)=V(i,j)+rand( )*c1*(P(TheBest,j)-P(i,j));
                P(i,j)=P(i,j)+V(i,j);
            end
        end
    end
    TheBest=1;
    P=round(P);
    while (isequal(g,r)==0) %testa logico que realiza os dois laços novamente.. 
        for i=1:N
            for j =1:D
                if P(i,j)<=0
                    P(i,j)=randi([1,M]);     % Atribui um número aleatorio para o elemento da particula indicado
                end
            end
        end
        % testa vetores acima do total de threads permitido.
        for i=1:N
            teste=sum(P(i,:));
            if teste>totthreads   % 1) Identifica se a linha tem somatorio igual ou inferior ao permitido
                z=teste-totthreads;
                w=max(P(i,:));
                for j =1:D
                    if P(i,j)==w  % 2) testa se o elemento da linha é o maior para retirar as threads que estão sobrando
                        P(i,j)=P(i,j)-z;
                        if P(i,j)<=0       %3) Testa se o novo valor não é inferior a 1.. Se for atribui 0 para voltar ao laço anterior
                            g(i,j)=0;
                        else
                            g(i,j)=1;       %3) Se o valor não for inferior atribui então 1
                        end
                    else
                        g(i,j)=1;  % 2) se o elemento da linha não for o maior atribui o valor logico 1
                    end
                end
            else
                g(i,:)=1;    % 1) Se a linha possui atribui valor lógico 1 a todos os elementos
            end
        end
    end
    g=zeros(N,D);   % reseta a variavel para uma nova interação
    for i=1:N
        Eval(i,1)=ProcessingTimeCalculation(timeprocessing,P(i,:),totmessages);
        if Eval(i,1)<EvalPbest(i,1)
            Pbest(i,:)=P(i,:);
            EvalPbest(i,1)=Eval(i,1);
        end
        if Eval(i,1)<Eval(TheBest,1)
            TheBest=i;
        end
    end
    if Eval(TheBest,1)<EvalGbest
        Gbest(1,:)=P(TheBest,:);
        EvalGbest=Eval(TheBest,1);
    end
end
makespan=EvalGbest;
vetor=Gbest;
disp(EvalGbest);
disp(Gbest);
toc
end