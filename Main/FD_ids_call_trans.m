function OptVal = FD_ids_call_trans(S0, X, r, q, T, sigma, I, N, xmax)
	deltaT = T / N;
	deltaX = xmax / I;
	a = deltaT * (r - q - sigma ^ 2 / 2) / (2 * deltaX);
	b = 1 + r * deltaT;
	c = deltaT * (r - q) / (2 * deltaX);
	
	U = max(exp(deltaX * (-I+1 : I-1) - X, 0);
	
	%Generate A
	Ainverse = inv(A);
	
	for j = N-1 : -1 : 0
		U(2I-1) = U(2I-1) + c * exp(-r*(N-j)*deltaT)*(exp(xmax) - X);
		U = Ainverse * U;
	end
	
	i0 = round(log(S0) / deltaX, 0);
	OptVal = U(i0);
	
end