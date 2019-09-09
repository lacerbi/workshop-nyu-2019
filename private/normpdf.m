function p = normpdf(x,mu,sigma)
%NORMPDF Normal probability density function

z = bsxfun(@rdivide,bsxfun(@minus,x,mu),sigma);
p = bsxfun(@rdivide,exp(-0.5*z.^2),sqrt(2*pi)*sigma);
