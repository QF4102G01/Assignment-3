% Group members: Chen Penghao, Wang Zexin
% Group number: G01

% Implementation of Black-scholes formula for pricing of Digital Call
% option.
function OptVal = BS_DigitalCall(S0, X, r, q, T, sigma)
    x = (log(S0 / X) + (r - q - sigma ^ 2 / 2) * T) / (sigma * sqrt(T));
    OptVal = exp(-r * T) * normcdf(x);
end