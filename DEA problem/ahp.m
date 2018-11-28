function [W, W_approx, IC, ICA, CR] = ahp(C)
%Set Constants
N = length(C); %Number of criteria

%Create Vector of Criteria Weights
Sorted_Weights = [1/9 1/8 1/7 1/6 1/5 1/4 1/3 1/2 1 2 3 4 5 6 7 8 9];

%Use the Matrix received as parameter as the matrix A 
%(Pairwise Comparison Matrix)
A = C;

%Create Normalized Approximated Pairwise Criteria Comparison Matrix
A_column_mean = sum(A);
A_mean_approx = zeros(N,N);
for k = 1:N
    A_mean_approx(:,k) = A(:,k)/A_column_mean(k);
end
W_approx = mean(A_mean_approx,2);

%Create Normalized Precise Pairwise Criteria Comparison Matrix
x0 = rand(N, 1);
x = fsolve(@(x) (A - max(eig(A)) * eye(N)) * x, x0, optimset('Algorithm','trust-region-dogleg','Display','off'));
W = x/sum(x);

%Calculate the Random Consistency Index for Different Amounts of Criteria
Initial_N_Criteria = N;
N_Criteria = N;
n_iter = 100000;
ICA = zeros(n_iter,N_Criteria);
for m = Initial_N_Criteria:N_Criteria
    for i = 1:n_iter
        A_temp = zeros(m,m);
        for j = 1:m
            for k = 1:m
                if j == k
                    A_temp(j,k) = 1;
                else
                    pos = randi(length(Sorted_Weights));
                    card = Sorted_Weights(pos);
                    A_temp(j,k) = card;
                    A_temp(k,j) = 1/A_temp(j,k);
                end
            end
        end
        A_temp = 1./A_temp;
        [v_temp,lambda_temp] = eig(A_temp);
        lambda_max_temp = max(max(lambda_temp));
        ICA(i,m) = (lambda_max_temp - m)/(m - 1);
    end
end
ICA = mean(ICA);
ICA = ICA(1,N);

%Calculate the Consistency Index
[v,lambda] = eig(A);
lambda_max = max(max(lambda));
IC = (lambda_max - N)/(N - 1);

%Calculate Consistency Ratio
CR = IC/ICA;

end