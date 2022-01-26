function Gpf = calcGpf(H,Er,Fr,Wp)
    Fr=Fr*1e9;
    e_eff=((Er+1)/2)+ (((Er-1)/2)* (1+((12*H)/Wp))^-0.5);
    Gpf=(3e8*4.65e-9)/(sqrt(2*e_eff)*Fr*10^-9);
    
    if ~isreal(Gpf)
        Gpf=0;
    end
end