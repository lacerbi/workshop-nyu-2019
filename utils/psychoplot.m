% Psychometric function plot
function psychoplot(fig,data)

if nargin < 1 || isempty(fig); fig = 3; end

if nargin < 2 || isempty(data)
    temp = load('1_causalinf_leftright.mat');
    data = temp.comp_dataset(temp.comp_dataset(:,1) == 1,[2 5]);
    clear temp;
end

% Plot properties
fontsize = 32;
axesfontsize = 24;

close all;
rng(0);

s = data(:,1);      % Stimuli
r = data(:,2) - 1;  % Responses (0 for 'Left', 1 for 'Right')
n = size(data,1);
r_jittered = r+0.02*randn(n,1); % Small jitter on y-axis for plotting

% X axis (used later)
xlims = [-30,30];
xx = linspace(xlims(1),xlims(2),1e4)';


% Fit psychometric function
LB = [-30,log(0.1),0];
UB = [30,log(60),1];
x0 = [0,log(1),0.05];
nll_psy = @(x) -sum(log(psy_like(x,data))); % Negative log likelihood
[theta,nll] = fminsearchbnd(nll_psy,x0,LB,UB)
mu = theta(1);          % Bias
sigma = exp(theta(2));  % Standard deviation (~ inverse slope)

switch fig
    
    case 1      % Plot only data
        drawplot(s,r_jittered,xx,xlims,theta,fontsize,axesfontsize,1,0,0);
        
    case 2      % Plot data and psychometric curve
        drawplot(s,r_jittered,xx,xlims,theta,fontsize,axesfontsize,1,1,1);        
        
    case 3      % How the psychometric curve is generated demo
        s_pos = [-20 -15 -10 -7.5 -5 -2.5 0 2.5 5 7.5 10 15 20];

        for i = 1:numel(s_pos)
            % s_pos = -5;
            hold off;
            drawplot(s,r_jittered,xx,xlims,theta,fontsize,axesfontsize,0,0,1);
            y = normpdf(xx,s_pos(i),sigma);
            plot(xx,y,'k-','LineWidth',2);
            idx = xx >= mu;
            area(xx(idx),y(idx),'FaceColor','b');
            plot(s_pos(i)*[1 1],[0,normcdf(s_pos(i),mu,sigma)],'k:','LineWidth',1);
            for j = 1:i
                scatter(s_pos(j),normcdf(s_pos(j),mu,sigma),'o','FaceColor','b');
            end
            text(s_pos(i),-0.1,['s = ' num2str(s_pos(i)) ' deg'],'HorizontalAlignment','Center','FontSize',axesfontsize);

            drawnow;
            pause;
        end
end

set(gcf,'Units','inches'); pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

end

function drawplot(s,r_jittered,xx,xlims,theta,fontsize,axesfontsize,plotdata,plotpsy,plotbias)
    mu = theta(1);          % Bias
    n = size(s,1);

    % Scatter plot of all responses, with small jitter on y-axis
    if plotdata
        scatter(s,r_jittered,'k');
        hold on;
    end

    % Plot 0 deg line
    plot([0 0],ylim,'-','Color',0.8*[1 1 1],'LineWidth',1);
    hold on;

    % Prettify plot
    box off;
    xlim(xlims); ylim([-0.2,1.2]);
    set(gca,'TickDir','out','YTick',[0,1],'FontSize',axesfontsize);
    xlabel('Heading direction (deg)','FontSize',fontsize);
    ylabel('Probability of responding ''right''','FontSize',fontsize);
    set(gcf,'Color','w');
    
    if plotdata
        text(20,0.8,'''Right'' responses','HorizontalAlignment','Center','FontSize',fontsize);
        text(-20,0.2,'''Left'' responses','HorizontalAlignment','Center','FontSize',fontsize);
        text(-20,1.1,['n = ' num2str(n)],'HorizontalAlignment','Center','FontSize',fontsize);
    end

    if plotbias
        % Plot bias line
        plot(mu*[1 1],[0 1],':b','LineWidth',2);
        if plotpsy; txt = 'bias'; else; txt = 'decision threshold'; end
        text(mu-1,0.7,txt,'HorizontalAlignment','Center','FontSize',fontsize,'Rotation',90);
    end

    if plotpsy
        % Plot psychometric function
        p  = psy_like(theta,[xx,2*ones(numel(xx),1)]);
        plot(xx,p,'b-','LineWidth',4);  
    end
    
    % Useful for printing
    pos = [1,41,1920,963];
    set(gcf,'Position',pos);    
end
