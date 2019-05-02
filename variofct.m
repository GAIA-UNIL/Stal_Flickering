function [gamma]=variofct(h,a,c,param3,type,nugget)

if type==1
    %exponential
    gamma=-(c.*(1-exp(-(abs(3.*h)/(a)))))+c;
end

if type==2
    %gaussian
    gamma=-(c.*(1-exp(-(h.^2)/(a^2*1/3))))+c;
end

if type==3
    %sphérical
    gamma=c./2*((3.*h/a)-(h.^3/a^3));
    ind= h>a;
    gamma(ind)=c;
    gamma=-gamma+c;
end

if type==4
    %power
    gamma=-(c.*(c./a).*abs(h.^(param3)))+c;
end

if type==5
    %cardinal sine
    gamma=(c.*(a./(2.*pi.*h)).*sin((2*pi.*h)/a));
end

if type==6
    %linear
    gamma=-c.*h;
end

gamma=-gamma+c+nugget;

