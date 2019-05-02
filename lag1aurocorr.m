function lag1=lag1aurocorr(TT,lag)
a=TT(1:end-lag);
b=TT(lag+1:end);
lag1=corr(a,b);