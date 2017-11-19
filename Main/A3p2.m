%Group members: Chen Penghao, Wang Zexin
%Group number: G01

C = [[1 0.88 0.17]; [0.88 1 0.34]; [0.17 0.34 1]];
S0 = [9.5 10.2 8.8];
sigma = [0.35 0.21 0.18];
r = 0.05;
q = [0.01 0.04 0];
T = 0.75;

no_sampless = [100, 1000, 10000, 100000];
strikes = [8.5, 9.5, 10.5];

simulation_run = 30;

for no_samples = no_sampless
    for X = strikes
        optionValues = 1 : simulation_run;

        for i = 1 : simulation_run
            optionValues(i) = MC_3AssetMD(S0, X, sigma, C, r, q, T, no_samples);
        end

        optionValue = mean(optionValues);
        standardError = std(optionValues);
        
        disp(['For strike price of $', num2str(X), ' and ', num2str(no_samples), ' samples, option value obtained is $', num2str(optionValue), ' and standard error is $', num2str(standardError)]);
    end
end

for no_samples = no_sampless
    for X = strikes
        optionValues = 1 : simulation_run;

        for i = 1 : simulation_run
            optionValues(i) = MC_3AssetMDCV(S0, X, sigma, C, r, q, T, no_samples);
        end

        optionValue = mean(optionValues);
        standardError = std(optionValues);
        
        disp(['For strike price of $', num2str(X), ' and ', num2str(no_samples), ' samples, option value obtained is $', num2str(optionValue), ' and standard error is $', num2str(standardError)]);
    end
end