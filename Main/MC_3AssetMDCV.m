% Group members: Chen Penghao, Wang Zexin
% Group number: G01

function optionValue = MC_3AssetMDCV(S0, X, sigma, C, r, q, T, no_samples)
    % Initiate expected value of digital call option price for each of the
    % 3 assets as well as the basket of the asset
    mu = r - q - sigma .^ 2. / 2;
    expectedDigital1 = BS_DigitalCall(S0(1), X, r, q(1), T, sigma(1));
    expectedDigital2 = BS_DigitalCall(S0(2), X, r, q(2), T, sigma(2));
    expectedDigital3 = BS_DigitalCall(S0(3), X, r, q(3), T, sigma(3));
    expectedBasketValue = (expectedDigital1 + expectedDigital2 + expectedDigital3) / 3;
    
    % Pilot simulation to find beta of the control variate
    no_pilot_samples = no_samples / 5;
    initialRand = randn(3, no_pilot_samples);
    U = chol(C);
    correlatedRand = transpose(initialRand) * U;
    
    sigma_augmented = repmat(sigma, no_pilot_samples, 1);
    price_augmented = repmat(S0 .* exp(mu .* T), no_pilot_samples, 1);
    
    pilotST = price_augmented .* exp(sqrt(T) .* sigma_augmented .* correlatedRand);

    % Obtain the vectors for option values and basket values from the pilot
    % simulation
    max_prices = max(pilotST, [], 2);
    pilotOptionValues = (max_prices > X) * exp(-r * T);
    pilotDigitalValues = (pilotST > X) * exp(-r * T);
    pilotBasketValues = mean(pilotDigitalValues, 2);
    .
    % Obtain the 2*2 covariance matrix between pilot option values and
    % basket values of the pilot simuation
    covariances = cov(pilotOptionValues, pilotBasketValues);
    
    % The beta would be the ratio of covariance between pilot 3-asset option values
    % and the variance of the basket values of the pilot simulation.
    beta = covariances(1,2) / covariances(2,2);
    
    % Rho is the correlation between the basket values and the 3-asset
    % option values
	rho = covariances(1,2) / sqrt(covariances(1,1) * covariances(2,2));

    % Actual computation for the final option value
    initialRand = randn(3, no_samples);
    L = chol(C);
    correlatedRand = transpose(initialRand) * L;
    
    sigma_augmented = repmat(sigma, no_samples, 1);
    price_augmented = repmat(S0 .* exp(mu .* T), no_samples, 1);
    
    ST = price_augmented .* exp(sqrt(T) .* sigma_augmented .* correlatedRand);

    max_prices = max(ST, [], 2);
    optionValues = (max_prices > X) * exp(-r * T);
    
    % Instead of proceeding with calculating the mean of the option values, 
    % we first obtain the basket values of the full simulation as the
    % control variate.
    digitalValues = (ST > X) * exp(-r * T);
    basketValues = mean(digitalValues, 2);
    
    % Then we compute the controlled option values vector with control
    % variate and the beta
    controlledOptionValues = optionValues - beta * (basketValues - expectedBasketValue);
    
    % The final option value would be the mean of the controlled option
    % values
    optionValue = mean(controlledOptionValues);
    
end