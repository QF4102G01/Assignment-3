function optionValue = MC_3AssetMDCV(S0, X, sigma, C, r, q, T, no_samples)
    mu = r - q - sigma .^ 2. / 2;
    expectedDigital1 = BS_DigitalCall(S0(1), X, r, q(1), T, sigma(1));
    expectedDigital2 = BS_DigitalCall(S0(2), X, r, q(2), T, sigma(2));
    expectedDigital3 = BS_DigitalCall(S0(3), X, r, q(3), T, sigma(3));
    expectedBasketValue = (expectedDigital1 + expectedDigital2 + expectedDigital3) / 3;
    
    % Pilot simulation to find beta of the control variate
    no_pilot_samples = no_samples / 5;
    initialRand = randn(3, no_pilot_samples);
    L = chol(C);
    correlatedRand = transpose(initialRand) * L;
    
    sigma_augmented = repmat(sigma, no_pilot_samples, 1);
    price_augmented = repmat(S0 .* exp(mu .* T), no_pilot_samples, 1);
    
    pilotST = price_augmented .* exp(sqrt(T) .* sigma_augmented .* correlatedRand);

    max_prices = max(pilotST, [], 2);
    pilotOptionValues = (max_prices > X) * exp(-r * T);
    
    pilotDigitalValues = (pilotST > X) * exp(-r * T);
    pilotBasketValues = mean(pilotDigitalValues, 2);
    covariances = cov(pilotOptionValues, pilotBasketValues);
    beta = covariances(1,2) / covariances(1,1);

    % Actual computation for the final option value
    initialRand = randn(3, no_samples);
    L = chol(C);
    correlatedRand = transpose(initialRand) * L;
    
    sigma_augmented = repmat(sigma, no_samples, 1);
    price_augmented = repmat(S0 .* exp(mu .* T), no_samples, 1);
    
    ST = price_augmented .* exp(sqrt(T) .* sigma_augmented .* correlatedRand);

    max_prices = max(ST, [], 2);
    optionValues = (max_prices > X) * exp(-r * T);
    digitalValues = (ST > X) * exp(-r * T);
    basketValues = mean(digitalValues, 2);
    controlledOptionValues = optionValues - beta * (basketValues - expectedBasketValue);
    
    optionValue = mean(controlledOptionValues);
    
end