function OptVal = FD_ids_call_trans(S0, X, r, q, T, sigma, I, N, xmax)
	deltaT = T / N;
	deltaX = xmax / I;
    alpha = sigma ^ 2 * deltaT / (deltaX ^ 2);
    beta = 1 + r * deltaT;
    gamma = deltaT * (r - q - sigma ^ 2 / 2) / (2 * deltaX);
	a = gamma - alpha / 2;
	b = beta + alpha;
	c = -gamma - alpha / 2;
	
	U = transpose(max(exp(deltaX * (-I+1 : I-1)) - X, 0));
	
    A = full(gallery('tridiag', 2*I-1, a, b, c));
	Ainverse = inv(A);
	
	for j = N-1 : -1 : 0
		U(2*I-1, 1) = U(2*I-1, 1) - c * exp(-r*(N-j)*deltaT)*(exp(xmax) - X);
        U = Ainverse * U;
	end
	
	i0 = round(log(S0) / deltaX, 0) + I;
    S0down = exp((i0 - I) * deltaX);
    S0up = exp((i0 - I + 1) * deltaX);
    downRatio = (S0up - S0) / (S0up - S0down);
	OptVal = U(i0+1, 1) * (1 - downRatio) + U(i0, 1) * downRatio;
	
end