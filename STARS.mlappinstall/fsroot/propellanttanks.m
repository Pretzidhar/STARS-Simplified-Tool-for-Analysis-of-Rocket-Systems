function [Totmassprop,ms_ox,ms_fuel,ts_ox,ts_fuel,rs_ox,rs_fuel,Vp]= propellanttanks(pf,po,r,go,Isp,p_1)

%initialize constants

deltav=input('Enter deltaV: ');      %m/s         (including 125 m/s for RCS)
      %kg/m^3      (chosen fuel)
     %kg/m^3      (chosen oxidizer)  
	   	%s           (specific for particular engine chosen)
   %mass_ox/mass_fuel   (specific for engine)
minitial=input('Enter initial mass: ');	%kg          (vehicle mass)
	%m/s^2       (gravitational constant
material=input('Enter the option of your desired material \n 1.Alluminum \n 2.Titanium \n');
if material==1
    Max_allowable_stress=137500000; %Mpa
    rho=2710;  %kg/m3
elseif material==2
     Max_allowable_stress=240000000;  %Mpa
     rho=4420; %kg/m3
else
    fprintf('Enter the correct option 1 or 2 \n')
end
pi=3.14;

%determine mass and volume of propellant
mfinal=minitial/(exp(deltav/(go*Isp)));      %kg        (rocket equation)
mprop=minitial-mfinal;              %kg
mfuel=mprop/r     ;              %kg      (from fuel ratio)  .....
mox=mprop-mfuel;
volox=1.1*(mox/po);       %m^3     (volume of ox, multiply by 0.5 using 2 tanks for ox, add 10% ullage)
volfuel=1.1*(mfuel/pf);
Vp=volox+volfuel;%m^3     (volume of fuel, multiply by 0.5 using 2 tanks for fuel, add 10% ullage)
% fprintf("%f %f",volox,volfuel);            

%tank thicknesses
                   %Pa (N/m^2)    (specific to engine)
delpdyn_ox=0.5*po*100;    %change dynamic pressure  (velocity=10 m/s (Humble))
delpdyn_fuel=0.5*pf*100;      %change dynamic pressure (velocity=10 m/s (Humble))
delpfeed=42500;                %change feed pressure (Humble) Pa
delpinj=0.2*p_1;                %change injection pressure (Humble) Pa
sf=2;                          %safety factor
maxop_ox=sf*(p_1+delpdyn_ox+delpfeed+delpinj);          %max expected operating pressure (burst)
maxop_fuel=sf*(p_1+delpdyn_fuel+delpfeed+delpinj);      %max expected operating pressure (burst)
%fprintf(" \n %f %f",maxop_ox,maxop_fuel);
rs_fuel=((3/4)*volfuel/pi)^(1/3);
rs_ox=((3/4)*volox/pi)^(1/3);

ts_fuel=((maxop_fuel*rs_fuel)/(2*Max_allowable_stress)); %(thickness of sphere (2 endcaps) of fuel ) (m)
ts_ox=((maxop_ox*rs_ox)/(2*Max_allowable_stress));       %(thickness of sphere (2 endcaps) of ox ) (m)


%tank masses and dimensions
ms_ox=(((4/3)*pi*(rs_ox+ts_ox)^(3)-volox)*rho);
ms_fuel=(((4/3)*pi*(rs_fuel+ts_fuel)^(3)-volfuel)*rho);
mtank_ox=ms_ox;                %mass of each oxidizer tank (kg)
mtank_fuel=ms_fuel;          %mass of each fuel tank (kg)
%fprintf('Total mass of the propellant is : %f %f Kg \n',ms_ox,ms_fuel);

Totmassprop=mtank_ox+mtank_fuel+mfuel+mox;
%fprintf('Total mass of the propellant is : %f Kg \n',Totmassprop);
end
