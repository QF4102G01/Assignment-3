% Group members: Chen Penghao, Wang Zexin
% Group number: G01
% Skeleton codes of A3p1

% Initiate key parameter values
X = 5;
S0 = 5.25;
T = 1;
sigma = 0.3;
xmax = 5;
r = 0.03;
q = 0.10;
N = 1500;

% Initialize number of price steps used and finite difference grids for
% European call option
Is = 100 : 100 : 1500;
fd_ids_results = 1 : (1500 - 100) / 100 + 1;

% Execute FD IDS for different values of I for European call option
for I = Is
    fd_ids_results(Is == I) = FD_ids_call_trans(S0, X, r, q, T, sigma, I, N, xmax);
end

% Plot the European call option values against the values of I
plot(Is, fd_ids_results)

% Initialize omega and eps for PSOR algorithm
epsilon = 10 ^ (-6);
omega = 1.3;

% Initialize number of price steps used and finite difference grids for
% American call option
Is2 = 100 : 100 : 1500;
fd_ids_results2 = 1 : (1500 - 100) / 100 + 1;

% Execute FD IDS for different values of I for American call option 
for I = Is2
    fd_ids_results2(Is2 == I) = FD_ids_Acall_trans(S0, X, r, q, T, sigma, I, N, xmax, epsilon, omega);
end

% Plot the American call option values against the values of I
plot(Is2, fd_ids_results2)
