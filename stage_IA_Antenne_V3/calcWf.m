function Wf = calcWf(H,Er,Z0)
    B=60*pi*pi/(Z0*sqrt(Er)); 
    m1=2*B-1;
    m=log(m1);   
    n1=B-1;
    n=log(n1);
    Wf=(2*H/pi)*(B-1-m+(((Er-1)/(2*Er))*(n+(0.39*0.61)/Er)));
    
    if ~isreal(Wf)
        Wf=0;
    end
end