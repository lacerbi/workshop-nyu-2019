function y = mgausspdf(x,a,b,c,d,w)
%MGAUSSPDF Multivariate truncated Gaussian probability density function.

% a < b < c < d

if nargin < 6 || isempty(w); w = 3; end

hmin = exp(-0.5*w^2);
hstretch = 1/(1 - hmin);
harea = (sqrt(2*pi)*0.5*(erfc(-w/sqrt(2)) - 1) - hmin*w)/w*hstretch;

y = zeros(size(x));
nf = (c - b) + (b - a + d - c)*harea;

for ii = 1:size(x,2)
    
    idx = x(:,ii) >= a(ii) & x(:,ii) < b(ii);
    y(idx,ii) =  (exp(-0.5*((x(idx,ii) - b(ii)) / ((b(ii) - a(ii))/w)).^2) - hmin)*hstretch  / nf(ii);
    
    idx = x(:,ii) >= b(ii) & x(:,ii) < c(ii);
    y(idx,ii) = 1 / nf(ii);
    
    idx = x(:,ii) >= c(ii) & x(:,ii) < d(ii);
    y(idx,ii) = (exp(-0.5*((x(idx,ii) - c(ii))/((d(ii) - c(ii))/w)).^2) - hmin)*hstretch / nf(ii);    
end

y = max(prod(y,2),0);







