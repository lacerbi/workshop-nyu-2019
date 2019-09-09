function p = psy_like(theta,data)
%PSY_LIKE Likelihood per trial of psychometric function for left/right data

%% Definition of function arguments

% THETA is a vector of model parameters.

mu = theta(1);              % Psychometric curve bias
sigma = exp(theta(2));      % Psychometric curve "inverse slope"
                            % (note the logarithmic representation)
lambda = theta(3);          % Lapse rate (probability of random response)

if lambda < 0 || lambda > 1
    error('Lapse rate should be 0 <= LAMBDA <= 1.');    
end

% To avoid numerical issues, we always assume a tiny nonzero lapse rate
lambda = max(lambda, 1e-6);

% DATA is a N-by-2 matrix where each row is a trial, and:
% - the 1st column is stimulus location in each trial (in deg);
% - the 2nd column contains the observer's response in each trial,
%          with 1 for "left" and 2 for "right".

x = data(:,1);
r = data(:,2);

%% Compute likelihood

% First, we compute the psychometric function without lapses
% We assume a cumulative normal distribution with mean MU (representing bias)
% and standard deviation SIGMA (representing sensory noise)

% Compute normal cumulative distribution function 
f = normcdf(x,mu,sigma);

% Now we add lapse (we assume that when lapsing, the answer is random)
f = lambda/2 + (1-lambda).*f;

% f now is the probability of responding "right" (vs. "left") in each trial

% Now we compute the probability of observing each response
p = f .* (r == 2) + (1 - f) .* (r == 1);

% This function returns the likelihood *per trial* -- the total log 
% likelihood is computed as sum(log(p))

end