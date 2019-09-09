function p = psyns_like(theta,data)
%PSYNS_LIKE Likelihood per trial of nonstationary psychometric fcn

%% Definition of function arguments

mu = theta(1);              % Psychometric curve bias
lnsigma_start = theta(2);   % Log noise at the beginning of the session
lnsigma_end = theta(3);     % Log noise at the end of the session
lambda = theta(4);          % Lapse rate (probability of random response)

if lambda < 0 || lambda > 1
    error('Lapse rate should be 0 <= LAMBDA <= 1.');    
end

lambda = max(lambda, 1e-6);     % Tiny nonzero lapse rate

x = data(:,1);      % Stimulus location (in deg)
r = data(:,2);      % Response (1 for "left" and 2 for "right")
n = size(data,1);   % Number of trials

%% Compute likelihood

% We assume that log sigma changes linearly from beginning to end
sigma = exp(linspace(lnsigma_start,lnsigma_end,n))';

f = normcdf(x,mu,sigma);        % Psychometric function without lapse
f = lambda/2 + (1-lambda).*f;   % Add random lapse

p = f .* (r == 2) + (1 - f) .* (r == 1);    % Likelihood per trial

end