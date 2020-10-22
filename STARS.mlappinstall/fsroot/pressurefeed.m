function [V,Mp,Rpt,Tpt,Mpt]= pressurefeed(Vp,po,pf,Max_stress,p_1)
%inputs required Vp from propellant tanks
               
%finding the pressure of the propellant tanks
%formula P=rho*R*T;
Pox=po*8.314*90; %oxidizer tank pressure
                   %where %rho=1141 kg/m^3
                          %R=8.314
                          %T=90K
Pfuel=pf*8.314*293; %oxidizer tank pressure
                     %where %rho=70.8 kg/m^3
                            %R=8.314
                            %T=293K 
Pp=Pox+Pfuel    ;  %total pressue of propellant tanks (pascals) Pp=1026233.6016 pa; 
Pg=2000000      ;  %Initial Pressure of Pressurant gas (Pg) (thermodynamic data) (pascals)
%Vp=7.6          ;  %Volume of Propellant tank (m^3)

%calculating Volume of the pressurant tank
Vg=Pp*Vp/Pg;
Ullage_volume = 0.1*Vg;
V= Vg+ Ullage_volume;%Total Pressurant gas tank volume 1

%finding mass of the propellant tank
%formula  No of moles (n)=(Pg*V)/(R*T)  in grms
                     %Pg intial pressure of pressurant in atm
                     %V is vol of the pressurant tank Litres
                     %R is the Gas constant L atm K^-1 mol^-1
                     %T is temperature of Helium gas K
 R=0.08206;     
 T=4;
 n=(Pg*9.86923e-6*V*1000)/(R*T); %Grams
 Mp=n*4.002602*0.001; %in kg 2
                                        %where
                                        %mass of one mole of Helium is 4.0026.2 g/mol
 %finding tank dimensions
 %tank thicknesses
%material=input('Enter the option of your desired material \n 1.Alluminum \n 2.Titanium \n');
%if material==1
 %   Max_allowable_stress=137500000; %Mpa
 %   rho=2710;  %kg/m3
%elseif material==2
%     Max_allowable_stress=240000000;  %Mpa
 %    rho=4420; %kg/m3
%else
%    fprintf('Enter the correct option 1 or 2 \n')
%end
pi=3.14;
rho_he=999.84;%kg/m^3
                     
               
delpinj=0.25*p_1;                %change injection pressure (Humble) Pa
sf=2;                          %safety factor
maxop_pre=2.5*(1e5+delpinj)*sf;          %max expected operating pressure (burst)
%fprintf(" \n %f %f",maxop_ox,maxop_fuel);
Rpt=((3/4)*V/pi)^(1/3);
Tpt=((maxop_pre*Rpt)/(2*Max_stress));       %(thickness of sphere (2 endcaps) of ox ) (m)


%tank masses and dimensions
Mpt=(((4/3)*pi*(Rpt+Tpt)^(3)-V)*rho_he);


                                   
  %outputs                                      
% fprintf('Total volume of the pressurant is : %f m^3 \n',V);
% fprintf('Mass of the pressurant is : %f kg \n',Mass_of_pressurant);
% fprintf('Radius of the pressurant tank is : %f m \n',rs_pre);
% fprintf('Thickness of the pressurant tank is : %f m \n',ts_pre);
 %fprintf('Mass of the pressurant tank is : %f Kg \n',ms_pre);
end
 