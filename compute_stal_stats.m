clear;home

filename='test_data.csv'; %data file name
year_column=3; %the column in the excel file containing the year of the lanimates
growth_column=4; %the column in the excel file containing the growth of the lanimates

data=importdata(filename);
data=data.data;
Y=data(:,year_column);
T=data(:,growth_column);

%% clean NaNs
indY=isnan(Y);
indT=isnan(T);
ind=indY | indT;
Y(ind)=[];
T(ind)=[];
%log
Tc=log10(T);
%center-normalize
Tc=Tc-mean(Tc);
Tc=Tc./std(Tc);

%% detrend
figure(1)

%detrend
p=polyfit(Y,Tc,2);
trend=polyval(p,Y);

clf
subplot(2,1,1);hold on
plot(Y,Tc,'k-')
plot(Y,trend,'k-.')
Tc=Tc-trend;
ylabel('Log Yearly growth (mm)')
xlabel('Year')
axis tight
title('Original data with trend')

subplot(2,1,2);hold on
plot(Y,Tc,'k-')
ylabel('Log Yearly growth (mm)')
xlabel('Year')
axis tight
title('Detrended data')

%% variograms
s=size(Y);
pts=[Y,ones(s),ones(s),Tc];
[meanh,gammah,npairs]=Variogram(pts,20,numel(Tc)/2,1,0);

h=0:0.1:numel(Tc)/2;
figure(2);clf;hold on;home
i=1;
plot(meanh,gammah,'k.-');

s1=variofct(h,50,0.45,0,1,0.15);
v{1}=s1;

% automatic variogram fitting
par0=[50,1,0.7];
par=AdjustVario(meanh,gammah,par0,1);
vv=variofct(h,par(1),par(2),1,1,par(3));

plot(h,vv,'k--')
title('fitted variogram')
grid on
xlabel('h');ylabel('\gamma(h)')

r=par(1);
c=par(2);
n=par(3);
IC=c/(c+n);
disp(' ')
disp(['GROWTH STATISTICS'])
disp(['r = ',num2str(r)])
disp(['c = ',num2str(c)])
disp(['n = ',num2str(n)])
disp(['IC = ',num2str(IC)])

%% autocorrelation of increments
TT=flipud(Tc);
YY=flipud(Y);
TT=diff(TT);

for i=1:5
    acf(i)=lag1aurocorr(TT,i);
end
acf=[1 acf];

figure(3);clf; hold on
plot(0:numel(acf)-1,acf,'ro')
plot([-0.1,5.1],[0,0],'k')
title('Autocorrelation of growth increments')
xlim([-0.01 5.1])
ylim([-0.5 1.05])
xlabel('lag (years)')
ylabel('autocorrelation')
grid on

f=acf(2);
disp(['f = ',num2str(f)])

%% local flickering
figure(4);clf
window=30;
allT={};
allY={};
clear localflickering

TT=flipud(Tc);
YY=flipud(Y);

%we look at the differences
TT=diff(TT);

allT=TT;
allY=YY;

for i=window/2+1:size(YY,1)-window/2
    subplot(2,1,2);hold on
    
    first=i-window/2;
    last=i+window/2;
    
    %define window as only continuous years
    for k=first:first+window-1
        if (YY(k+1)-YY(k))>1
            break
        end
    end
    last=k-1;
    
    %put a nan if window is smaller than 3
    if (last-first)<3
        localflickering(i)=nan;
        localmean(i)=nan;
        continue
    end
    
    windowcentroid(i)=mean(YY(first:last));
    ind=windowcentroid==0;
    windowcentroid(ind)=nan;
    
    [acf,lags,bounds] = autocorr(TT(first:last));
    localflickering(i)=acf(2);
    localmean(i)=mean(TT(first:last));
    
end

ax(1)=subplot(2,1,1);
bar(YY(1:end-1),TT,1,'b')
title(['Increments'])
axis tight
xlabel('year');ylabel('f');
ax(2)=subplot(2,1,2);
plot(windowcentroid,localflickering,'-r')
axis([min(YY) max(YY) min(localflickering) max(localflickering)])
title(['local flickering in a window of ',num2str(window),' years'])
axis tight
xlabel('year');ylabel('f');
linkaxes(ax,'x');

