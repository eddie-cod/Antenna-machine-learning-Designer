function Fi = calcFi(Fr,Z0,Wp,Lp)
    Fr=Fr*1e9;
    la=(3e8/Fr)*1000;
    k=(2*pi)/la;
    x=k*(Wp);
    i1=-2+cos(x)+(x*sinint(x))+(sin(x)/x);
    g1=i1/(120*pi*pi);
    a=@(th)(((sin((x./2).*cos(th))./cos(th)).^2).*(besselj(0,(k.*Lp.*sin(th)))).*(sin(th)).^3);
    a1=integral(a,0,pi);
    g12=a1/(120*pi*pi);
    r_in=1/(2*(g1+g12));
    Fi=(Lp/pi)*(acos(sqrt(Z0/r_in)));
    
    if ~isreal(Fi)
        Fi=0;
    end
end