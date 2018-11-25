
function main()

% Initialization
N  = 10; % number of solutions
n  = 6;  % number of decision variables
lb = [0.05 0.05 0.05 0.05 0.05 0.05];  % lower bound
ub = [0.5  0.6  1.0  1.2  1.0  0.6];   % upper bound
X  = (repmat(lb(:),1,N) + repmat((ub(:)-lb(:)),1,N).*rand(n,N));

% Evaluation of the candidate solutions
fX = dea(X);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% optimization algorithm (done)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Eliminate Pareto dominated solutions
[X,fX] = nondominatedpoints(X,fX);


save solutions X fX


% Evaluate the solutions on the additional criteria considered
criteria = criterios(X,fX);

% Eliminate Pareto dominated solutions
[X,fX] = nondominatedpoints(X,criteria);

save multicriteriaSolutions X fX




