X = 5;
S0 = 5.25;
T = 1;
sigma = 0.3;
xmax = 5;
r = 0.03;
q = 0.10;
N = 1500;

Is = 100 : 100 : 1500;
fd_ids_results = 1 : (1500 - 100) / 100 + 1;

for I = Is
    fd_ids_results(Is == I) = FD_ids_call_trans(S0, X, r, q, T, sigma, I, N, xmax);
end

plot(Is, fd_ids_results)

%[0.522776022894615,0.523228505305835,0.523105617704949,0.522656345235669,0.522797471560081,0.522898874252548,0.522950382492270,0.522963742476891,0.522959159142429,0.522890228302100,0.522914330062009,0.522936922834744,0.522947345908465,0.522949937081634,0.522947446794060]
%[0.522776022894615,0.521183079888135,0.522918548572753,0.522937552225679,0.521357842187904,0.523228505305835,0.522618313858215,0.521996632179508,0.523035645477025,0.522584244963199,0.523105617704949,0.522793102710150,0.522696797706529,0.522964630545223,0.522906264505896,0.522656345235669,0.522967147825616,0.522879435761243,0.522614103899857,0.522976211668347,0.522797471560081,0.522994883105585,0.522922362275864,0.522824906544182,0.522974975580216,0.522898874252548,0.522823647979956,0.522922693052498,0.522910085505432,0.522787741974512,0.522950382492270,0.522885423615563,0.522957605388294,0.522940409636623,0.522859109115310,0.522963742476891,0.522907790379838,0.522870247085784,0.522945020479239,0.522914849917578,0.522959159142429,0.522936094841535,0.522910457538959,0.522939244302888,0.522940492592347,0.522890228302100,0.522952960308673,0.522928181424517,0.522887621691105,0.522949118272920,0.522914330062009,0.522956336068454,0.522932880253650,0.522918404652490,0.522947908789990,0.522936922834744,0.522910377664084,0.522944313874991,0.522934296869726,0.522895061453431,0.522947345908465,0.522922371618071,0.522951318279545,0.522940628413484,0.522920489999496,0.522949937081634,0.522932821343881,0.522918996144957,0.522940746891342,0.522935220759006,0.522947446794060]

epsilon = 10 ^ (-6);
omega = 1.3;

Is2 = 100 : 25 : 1500;
fd_ids_results2 = 1 : (1500 - 100) / 25 + 1;

for I = Is2
    fd_ids_results2(Is2 == I) = FD_ids_Acall_trans(S0, X, r, q, T, sigma, I, N, xmax, epsilon, omega);
end

plot(Is2, fd_ids_results2)

FD_ids_Acall_trans(S0, X, r, q, T, sigma, I, N, xmax, epsilon, omega)

for I = Is
    FD_ids_call_trans_psor(S0, X, r, q, T, sigma, I, N, xmax, epsilon, omega)
end