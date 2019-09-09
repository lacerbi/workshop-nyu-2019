%% Tutorial on modeling & model fitting for psychophysics and neuroscience
% by Luigi Acerbi (2019)

%% Add utilities' folder to MATLAB path

baseFolder = fileparts(which('ModelingTutorial.m'));
addpath([baseFolder,filesep(),'utils']);

%% Prepare Acerbi et al.'s (2018) data

% Load full data in temporary struct
temp = load('1_causalinf_leftright.mat');

% You can find more datasets (of the form "leftright") here:
% https://github.com/lacerbi/visvest-causinf/tree/master/data
% Reference: Acerbi*, L., Dokka*, K., Angelaki, D. E. & Ma, W. J. (2018). 
% Bayesian Comparison of Explicit and Implicit Causal Inference Strategies 
% in Multisensory Heading Perception, PLoS Computational Biology 14(7): 
% e1006110. (*equal contribution)

% Take data from vestibular-only session
data = temp.comp_dataset(temp.comp_dataset(:,1) == 1,[2 5]);

%% Plot raw data (always good to have a look!)
close all;
figure(1);

% Scatter plot of all responses, with small jitter on y-axis
scatter(data(:,1),data(:,2)-1+0.02*randn(size(data,1),1),'k');
hold on;

% Plot 0 deg line
plot([0 0],ylim,'-','Color',0.8*[1 1 1],'LineWidth',1);

% Prettify plot: add axes, labels, legend, etc.
box off;
fontsize = 24; axesfontsize = 18;
xlims = [-30,30];
xlim(xlims); ylim([-0.2,1.2]);
set(gca,'TickDir','out','YTick',[0,1],'FontSize',axesfontsize);
xlabel('Heading direction (deg)','FontSize',fontsize);
ylabel('Probability of responding ''right''','FontSize',fontsize);
set(gcf,'Color','w');
text(20,0.8,'''Right'' responses','HorizontalAlignment','Center','FontSize',fontsize);
text(-20,0.2,'''Left'' responses','HorizontalAlignment','Center','FontSize',fontsize);
text(-20,1.1,['n = ' num2str(size(data,1))],'HorizontalAlignment','Center','FontSize',fontsize);

%% Model fitting!

% Fix random seed for reproducibility
rng(1);

% Define optimization starting point and bounds
LB = [-30 log(0.1) 0];
UB = [30 log(60) 1];
PLB = [-10 log(1) 0.01];
PUB = [10 log(10) 0.1];

% Randomize initial starting point inside plausible box
x0 = rand(1,numel(LB)) .* (PUB - PLB) + PLB;

nLLfun = @(params) -sum(log(psy_like(params, data)));
nLLfun(x0)


%% Fit with (bounded) fminsearch first
figure(2);
options = optimset('fminsearch');   % Default options
options.Display = 'iter';
options.OutputFcn = @(x, optimValues, state) plotProfile(nLLfun,x,PLB,PUB,[],{'\mu','ln \sigma','\lambda'});
[xbest,fval,~,output] = fminsearchbnd(nLLfun,x0,LB,UB,options);
xbest
fval
output

% In reality, we should rerun the optimization multiple times to ensure 
% that we found the global optimum!

%% Plot psychometric curve
figure(1);

xx = linspace(xlims(1),xlims(2),1e4)';
p  = psy_like(xbest,[xx,2*ones(numel(xx),1)]);
plot(xx,p,'b-','LineWidth',4);        

% Plot bias line
mu = xbest(1);  % Psychometric fcn bias
plot(mu*[1 1],[0 1],':b','LineWidth',2);
text(mu-1,0.7,'bias','HorizontalAlignment','Center','FontSize',fontsize,'Rotation',90);


%% Fit with fmincon
options = optimset('fmincon');   % Default options
options.Display = 'iter';
[xbest,fval,~,output] = fmincon(nLLfun,x0,[],[],[],[],LB,UB,[],options);
xbest
fval
output


%% Fit with BADS (download from: https://github.com/lacerbi/bads)
options = bads('defaults');     % Default options
options.Display = 'iter';
options.UncertaintyHandling = false;    % Function is deterministic
[xbest,fval,~,output] = bads(nLLfun,x0,LB,UB,PLB,PUB,options);
xbest
fval
output


%% Model comparison

n = size(data,1);   % Number of trials
nlls = zeros(1,2);  % Store negative log likelihoods

% Refit simple psychometric function (model 1)
options = optimset('fminsearch');   % Default options
options.Display = 'none';
[xbest1,nlls(1)] = fminsearchbnd(nLLfun,x0,LB,UB,options);
k(1) = numel(x0);   % # parameters of model 1

% Fit nonstationary psychometric function (model 2)
LB_ns = [-30 log(0.1) log(0.1) 0];
UB_ns = [30 log(60) log(60) 1];
nLLfun_ns = @(params) -sum(log(psyns_like(params, data)));

% Trick: start from optimum of simpler model, fill in new parameters
% (still, we should *also* do multiple starting points)
x0_ns = [xbest(1) log(xbest(2)) log(xbest(2)) xbest(3)];
[xbest2,nlls(2)] = fminsearchbnd(nLLfun_ns,x0_ns,LB_ns,UB_ns,options);
k(2) = numel(x0_ns);   % # parameters of model 2

% Print model comparison metrics

lls = -nlls                     % Log likelihood
aic = -2*lls + 2*k              % AIC
bic = -2*lls + k*log(n)         % BIC
aic_res = lls - k              % Rescaled AIC
bic_res = lls - k/2*log(n)     % Rescaled BIC


%% Bayesian fit with VBMC (download from: https://github.com/lacerbi/vbmc)
options = vbmc('defaults');
options.Display = 'iter';
options.Plot = true;
[~,lml(1)] = vbmc(@(x) -nLLfun(x),x0,LB,UB,PLB,PUB,options);

PLB_ns = [-10 log(1) log(1) 0.01];
PUB_ns = [10 log(10) log(10) 0.1];
[~,lml(2)] = vbmc(@(x) -nLLfun_ns(x),x0_ns,LB_ns,UB_ns,PLB_ns,PUB_ns,options);

lml
