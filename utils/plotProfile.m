function tf = plotProfile(fun,x0,LB,UB,nx,varnames)
%PLOTPROFILE Plot profile of given function

% Optional argument: number of grid points
if nargin < 5 || isempty(nx); nx = 512; end

% Optional argument: variable names
if nargin < 6; varnames = []; end

fontsize = 18;

nvars = numel(x0);
if isempty(varnames)
    for i = 1:nvars; varnames{i} = ['x' num2str(i)]; end
end

for i = 1:nvars
    % Select i-th subpanel
    subplot(1,nvars,i);
    
    % Compute function profile along i-th coordinate axis
    xspan = linspace(min(LB(i),x0(i)), max(x0(i),UB(i)), nx);    
    xx = repmat(x0,[numel(xspan),1]);
    xx(:,i) = xspan;    
    yy = zeros(nx,1);
    for j = 1:nx; yy(j) = fun(xx(j,:)); end
        
    % Plot function profile
    hold off;
    plot(xspan,yy,'k','LineWidth',1);
    
    % Plot current point
    hold on;
    plot(x0(i)*[1 1],ylim,'k-','LineWidth',2);
    
    % Embellishments
    xlabel(varnames{i},'FontSize',fontsize);
    ylabel('function value','FontSize',fontsize);
    set(gca,'TickDir','out','box','off','FontSize',fontsize-4);
end

set(gcf,'Color','w');
drawnow;

tf = false;