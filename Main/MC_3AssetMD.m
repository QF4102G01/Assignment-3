% Group members: Chen Penghao, Wang Zexin
% Group number: G01

function optionValue = MC_3AssetMD(S0, X, sigma, C, r, q, T, no_samples)
    % Initialize a random 3*no_samples matrix, where each column of the
    % matrix is the value of x for of each of the 3 assets, which follows
    % standard normal distribution.
    initialRand = randn(3, no_samples);
    
    % Use Cholesky factorization to produce a lower triangular from the
    % correlations matrix, since C is positive definite.
    L = chol(C);
    
    % Generation of correlated random variables
    correlatedRand = initialRand * L;
    
    % Initiate the basic variables for pricing
    mu = r - q - sigma .^ 2. / 2;
    % Copy the values of sigma and expected price for no_samples times
    sigma_augmented = repmat(sigma, no_samples, 1);
    price_augmented = repmat(S0 .* exp(mu .* T), no_samples, 1);
    
    % Terminal price simulated
    ST = price_augmented .* exp(sqrt(T) .* sigma_augmented .* correlatedRand);
    
    % Filter in only those samples that have the maximum price above strike
    % price.
    max_prices = max(ST, [], 2);
    optionValues = (max_prices > X);
    
    % Take present value of the mean of these option values, and obtain the
    % final option value from the simulation.
    optionValue = mean(optionValues) * exp(-r * T);
    
end