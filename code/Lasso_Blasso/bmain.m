clear
close all;


addpath(genpath('./simu'))
addpath(genpath('./lasso'))
addpath(genpath('./dictgen'))
addpath(genpath('./blasso'))

N = 100;    % size of the dictionary A : M*N
K = 4;      % number of sources in the simulated signal
SNR = inf;  % input snr
rng(1)      % set the seed

%%
%%%%%%%%%%%%%%
% Simulation %
%%%%%%%%%%%%%%

simu_opts = bsimuxy('2dgaussian');    % select the type of data to be simulated. possible choices are: 'doa' , 'gaussian' , 'dgaussian')

[ paramr , coef , y , A_simu] = simu_opts.simu(K,SNR);  % simulate the observation vector


%%
%%%%%%%%%%%%%%%%%%%%%%
% Methods parameters %
%%%%%%%%%%%%%%%%%%%%%%

opts.param_grid = simu_opts.test_grid(N);
opts.A = simu_opts.atom(opts.param_grid);

opts.atom = simu_opts.atom;
opts.datom = simu_opts.datom;
opts.B = simu_opts.p_range;
opts.cplx = simu_opts.cplx;

lambda_lambdaMax = .01;
lambdaMax = norm(opts.A'*y,inf);

opts.lambda = lambda_lambdaMax*lambdaMax;
opts.maxIter = 100;
opts.tol = 1.e-5;
opts.disp = true;

%%
%%%%%%%%%%%%%%
% SFW-blasso %
%%%%%%%%%%%%%%
opts.mergeStep = .01;
[param_SFW_blasso, x_SFW_blasso , fc_SFW_blasso , fc_SFW_lasso , fc_SFW_lassodual ] = SFW( y , opts );


%%
%%%%%%%%%%%%%%
% Figures    %
%%%%%%%%%%%%%%

figure

scatter3(paramr(1,:),paramr(2,:),coef)
%scatter(paramr(1,:),paramr(2,:));
hold all
scatter3(param_SFW_blasso(1,:),param_SFW_blasso(2,:),x_SFW_blasso)
%scatter(param_SFW_blasso(1,:),param_SFW_blasso(2,:));
%plot(param_SFW_blasso,x_SFW_blasso,'xr')

figure
plot(fc_SFW_lasso)
xlabel('iter.')
ylabel('lasso cost-function')

