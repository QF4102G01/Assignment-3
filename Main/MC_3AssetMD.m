% Group members: Chen Penghao, Wang Zexin
% Group number: G01

function optionValue = MC_3AssetMD(S0, X, sigma, C, r, q, T, no_samples)
    % Initialize a random 3*no_samples matrix, where each column of the
    % matrix is the value of x for of each of the 3 assets, which follows
    % standard normal distribution.
    initialRand = randn(3, no_samples);
    
    % Use Cholesky factorization to produce a lower triangular from the
    % correlations matrix, since C is symmetric and positive definite.
    L = chol(C)';
    
    % Generation of correlated 
    correlatedRand = L * initialRand;
    
    mu = r - q - sigma .^ 2. / 2;
    sigma_augmented = repmat(sigma, no_samples, 1);
    price_augmented = repmat(S0 .* exp(mu .* T), no_samples, 1);
    
    ST = price_augmented .* exp(sqrt(T) .* sigma_augmented .* correlatedRand);

    max_prices = max(ST, [], 2);
    optionValues = (max_prices > X);
    
    optionValue = mean(optionValues) * exp(-r * T);
    
end