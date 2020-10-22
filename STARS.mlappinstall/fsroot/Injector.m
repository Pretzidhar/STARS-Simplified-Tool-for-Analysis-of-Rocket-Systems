function [delPo,delPf,Vo,Vf,n,n1,do,df] = Injector(mdot,r,Pc,po,pf)

%Injector design 
%Outer loop(while loop) for increasing n(hole count) then 
%inner loop(for loop) for calculations at different diameter values
%when criteria is met the loop breaks by the use of if statement% Outputs: Pressure drop , Velocity, Holes, Diameter of orifice
% Inputs: Mass flow rate, Mixture ratio, Chamber pressure, Density

Cd=0.87;             %Discharge coefficient (no unit)
LPc=0.15*Pc          %Lower threshold 15%of Chamber pressure   (CHANGE)
HPc=0.25*Pc          %Higher threshold 25%of Chamber pressure   (CHANGE)
mo = (mdot*r)/(r+1) %Mass flow rate of oxidizer kg/s
mf = mdot/(r+1)      %Mass flow rate of fuel kg/s
Qo=mo/po             %Volumetric flow rate of oxidizer m3/s
Qf=mf/pf            %Volumetric flow rate of fuel m3/s
O = 0                %Variable to stop the loop
F = 0                %Variable to stop the loop
n=0  
n1=0                   %No. of holes

while(F==0)                           %FUEL
    n1=n1+10
    
 for df=0.5:0.25:5.0             %(CHANGE RANGE)
        af=(3.14/4)*(df*1e-3)^2
        Af=1.1*af*n1
        delPf=((Qf/(Cd*Af))^2)*(pf/2)
        Vf=mf/(pf*Af)
        if((LPc<=delPf)&&(delPf<=HPc))
            F=1
            break
        end
  end
end 

while(O==0)                               %OXIDIZER 
    n=n+10
    for do=0.5:0.25:5.0             %(CHANGE RANGE)
        ao=(3.14/4)*(do*1e-3)^2
        Ao=ao*n
        delPo=((Qo/(Cd*Ao))^2)*(po/2)
        Vo=mo/(po*Ao)
        if((LPc<=delPo)&&(delPo<=HPc))
            O=1;
            break
        end
    end
end
end %Injector design