% Group members: Chen Penghao, Wang Zexin
% Group number: G01
% Finite Difference implicit difference scheme for American call option
% under a transformed Black-Scholes PDE model

function OptVal = FD_ids_Acall_trans(S0, X, r, q, T, sigma, I, N, xmax, epsilon, omega)
    % Initiate parameters for IDS
	deltaT = T / N;
	deltaX = xmax / I;
    alpha = sigma ^ 2 * deltaT / (deltaX ^ 2);
    beta = 1 + r * deltaT;
    gamma = deltaT * (r - q - sigma ^ 2 / 2) / (2 * deltaX);
	a = gamma - alpha / 2;
	b = beta + alpha;
	c = -gamma - alpha / 2;
	
	% Terminal value calculation
    optionPayoffs = transpose(max(exp(deltaX * (-I+1 : I-1)) - X, 0));
	U = optionPayoffs;
	
	for j = N-1 : -1 : 0
		U = PSOR(a, b, c, U, U, epsilon, omega, optionPayoffs, 2*I-1);
	end
	
	% Interpolate between two adjacent nods
	i0 = round(log(S0) / deltaX, 0) + I;
    S0down = exp((i0 - I) * deltaX);
    S0up = exp((i0 - I + 1) * deltaX);
    downRatio = (S0up - S0) / (S0up - S0down);
	OptVal = U(i0+1, 1) * (1 - downRatio) + U(i0, 1) * downRatio;
	
end

function v = PSOR(a, b, c, initial_guess, Vplus, epsilon, omega, phi, Imax)
    k = 0;
    converged = false;
    oldV = initial_guess;
    newV = oldV;
    while ~converged
		% alpha = 0, beta = 1, gamma = 0
        psi = Vplus;
        for i = 2 : Imax - 1
			% a, b, c do not vary for different values of i
            newV(i) = (psi(i) - a * newV(i-1) - c * oldV(i+1)) / b;
			% Max against the intrinsic values of option
            newV(i) = max(omega * newV(i) + (1 - omega) * oldV(i), phi(i));
        end
        if norm(newV - oldV) < epsilon
            converged = true;
        end
        k = k + 1;
        oldV = newV;
    end
    v = newV;
end