function optionValue = MC_3AssetMD(S0, X, sigma, C, r, q, T, no_samples)
    initialRand = randn(3, no_samples);
    L = chol(C);
    correlatedRand = transpose(initialRand) * L;
    
    mu = r - q - sigma .^ 2. / 2;
    sigma_augmented = repmat(sigma, no_samples, 1);
    price_augmented = repmat(S0 .* exp(mu .* T), no_samples, 1);
    
    ST = price_augmented .* exp(sqrt(T) .* sigma_augmented .* correlatedRand);

    max_prices = max(ST, [], 2);
    optionValues = (max_prices > X);
    
    optionValue = mean(optionValues) * exp(-r * T);
    
end