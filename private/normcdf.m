function f = normcdf(x,mu,sigma)
%NORMCDF Normal cumulative distribution function

z = bsxfun(@rdivide,bsxfun(@minus,x,mu),sqrt(2)*sigma);
f = 0.5 + 0.5*erf(z);
