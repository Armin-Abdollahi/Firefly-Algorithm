clc;
clear;
close all;

%% Cost funcrion
User.Function = @(x) Rosen_Brock(x);
User.NumbVars = 4;
User.RangeVars = [-20, 20];

%% Parameter of Firefly Algorithm

User.NumbPop = 20;
User.MaxIter = 1000;
User.Beta0 = 1;
User.Gamma = 1;
User.Alpha = 0.2;
User.m = 2;
User.Damp = 0.99;

SampleFireFly.Position = [];
SampleFireFly.Cost = [];
FireFly = repmat(SampleFireFly, User.NumbPop, 1);

BestFireFly.Cost = inf;

for i = 1:User.NumbPop

    FireFly(i).Position = unifrnd(User.RangeVars(1), User.RangeVars(2), [1 User.NumbVars]);
    FireFly(i).Cost = User.Function(FireFly(i).Position);
    if FireFly(i).Cost < BestFireFly.Cost
        BestFireFly = FireFly(i);
    end

end

%% Main loop

BestFireFlyCost = zeros(User.MaxIter, 1);
for iter = 1:User.MaxIter
    NewFireFly = FireFly;
    for i = 1:User.NumbPop
        for j = 1:User.NumbPop
            if FireFly(j).Cost <= FireFly(i).Cost
                Distance = norm(FireFly(j).Position - FireFly(i).Position);
                Beta = User.Beta0 * exp(-User.Gamma * Distance^User.m);
                e = unifrnd(-0.05*(User.RangeVars(2)-User.RangeVars(1)) ...
                    ,0.05*(User.RangeVars(2)-User.RangeVars(1)) ...
                    ,[1, User.NumbVars]);
                NewFireFly(i).Position = FireFly(i).Position + Beta*(FireFly(j).Position - FireFly(i).Position) ...
                    + User.Alpha * e;

                NewFireFly(i).Position = min(User.RangeVars(2), NewFireFly(i).Position);
                NewFireFly(i).Position = max(User.RangeVars(1), NewFireFly(i).Position);

                NewFireFly(i).Cost = User.Function(NewFireFly(i).Position);

                if NewFireFly(i).Cost <= BestFireFly.Cost
                    BestFireFly = NewFireFly(i);
                end
            end
        end
    end

    FireFly = [NewFireFly
        FireFly
        BestFireFly];
    [~, SortOrder] = sort([FireFly.Cost]);
    FireFly = FireFly(SortOrder);
    FireFly = FireFly(1:User.NumbPop);

    User.Alpha = User.Alpha * User.Damp;
    BestFireFlyCost(iter) = BestFireFly.Cost;
    fprintf('Iteration = %i , Best Cost = %d \n', iter, BestFireFlyCost(iter));
    fprintf('-------------------------------------------\n')
    
end
