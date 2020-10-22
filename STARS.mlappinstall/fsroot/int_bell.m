function[e,Dia_exit,Th_Dia,m_dot,Cf,Isp,Dia_cc,L_cc,V_cc,V_cyl,L1,Thickness,Mean_Diameter]= int_bell(p_1,T_1,FT,R,M,g,L_starm)
 p_a=0;
 p_e = 12150;
theta_conver=45;
 Ve = (((2*g*R*T_1)/(M*g-M))*(1-(p_e/p_1)^((g-1)/g)))^0.5;%exit velocity
%pt = p_1*(2/(g+1))^(g/(g-1));
%Tt = (2*T_1/(g+1));
%Te = Tt*(p_e/pt)^((g-1)/g);
Me = sqrt((2/(g-1))*((p_1/p_e)^((g-1)/g)-1));
e= (1/Me)*(((2/(g+1))*(1+((g-1)/2)*Me^2)))^((g+1)/(2*(g-1)));%expansion ratio
a = (2*g)/(g-1);
b = (2/(g+1))^((g+1)/(g-1));
c = 1-(p_a/p_1)^((g-1)/g);
Cf = sqrt(a*b*c)+(((p_e-p_a)/p_1)*(e));%thrust coeff
Th_Area = FT/(p_1 * Cf);%throat area
A_exit = Th_Area * e;%exit area
Dia_exit=((4*A_exit)/3.14)^(0.5);



Th_Dia=((4* Th_Area)/3.14)^(0.5);
Rt= Th_Dia/2;
m_dot1 = (Th_Area*p_1)/((R/M)*T_1)^0.5;
m_dot2 = g*((2/(g+1))^((g+1)/(g-1)));
m_dot = m_dot1 * m_dot2 ;%mass flow rate
Isp = FT/(m_dot * 9.81);%specific impulse
%nozzle plots
theta = 50; %deg
theta_n = theta*pi/180; %rad
area_ratio = A_exit/Th_Area;
Ln = (0.8*((area_ratio)^(0.5)-1)*(Rt))/tand(15);
% Angles for First Curve
Angle_FC=-3*pi/4;
FC_step=(-pi/2-Angle_FC)/9;
theta_FC=(-3*pi/4):FC_step:(-pi/2);
% Coordinates for First Curve
x_FC=cos(theta_FC)*1.5*Rt;
y_FC=sin(theta_FC)*1.5*Rt+(1.5*Rt+Rt);
x_FC1 = x_FC;
y_FC1 = y_FC;

plot(x_FC1,y_FC1)


% Angle for Second Curve
Angle_SC=-pi/2;
SC_step=((theta_n-pi/2)-Angle_SC)/9;
theta_SC=-pi/2:SC_step:(theta_n-pi/2);
% Coordinates for Second Curve
x_SC=cos(theta_SC)*0.382*Rt;
y_SC=sin(theta_SC)*0.382*Rt+(0.382*Rt+Rt);
x_SC1 = x_SC;
y_SC1 = y_SC;
%plot(x_FC1,y_FC1,x_SC1,y_SC1)
theta_e=15*pi/180;
% Angle for Third Curve
x_TC=x_SC1(1,10);
y_TC=y_SC1(1,10);
y_exit=Dia_exit/2;
matrix_y=[2*y_TC 1 0; 2*y_exit 1 0; y_TC^2 y_TC 1];
matrix_x=[1/tan(theta_n); 1/tan(theta_e) ;x_TC];
x_exit= matrix_y^-1*matrix_x;

a=x_exit(1,1);
b=x_exit(2,1);
c=x_exit(3,1);

yn=y_TC:.0001:y_exit;
xn= a*(yn).^2+b*yn+c;

%plot(xn,yn);
% Coordinate of Third Curve

Rao_x=[x_FC1 x_SC1 xn];
Rao_y=[y_FC1 y_SC1 yn];
rao=[Rao_x Rao_y];

plot(Rao_x, Rao_y,Rao_x,-Rao_y);
V_cc=L_starm*Th_Area;
Dia_cc=((4*V_cc)/(2.5*3.14))^(1/3);
L_cc=2.5*Dia_cc;
syms w z
equat1= w-(p_1*0.000145*z)/16000==0;

equat2= z+w/2-(Dia_cc)==0;
[A,B]= equationsToMatrix([equat1,equat2],[w,z]);
R= linsolve(A,B);
Y = reshape(R.',1,[]);
Y1=vpa(Y);
Thickness= Y1(1,1);
Mean_Diameter=Y1(1,2);


L_conver=(Dia_cc-Th_Dia)/(2*(tand(theta_conver))); %Length of convergent part (not the slant height, but straight one).

V_conver=(1/3)*3.14*L_conver*((Th_Dia/2)^2+(Dia_cc/2)*(Th_Dia/2)+(Dia_cc/2)^2);%Volume of the convergent part

V_cyl=V_cc-V_conver; % Volume of cylindrical part

L1=(V_cyl-V_conver)/((3.14/4)*Dia_cc^2); % Length of cylindrical part
x_ct = x_FC(1,1);
y_ct = y_FC(1,1);
x_conver1=x_ct-L_conver;
y_conver1=abs((x_ct-L_conver/tand(45)));

x_conver = [x_conver1 x_ct];
y_conver = [y_conver1 y_ct];
%plot(x_conver,y_conver)

x_cy = x_conver(1,1);
y_cy = y_conver(1,1);
x_cyl=(L1+L_conver)-x_cy;
x_cyl= [x_cyl -x_cy];
y_cyl=y_conver(1,1);
y_cyl=[y_cyl y_cyl];
%plot(x_cyl,y_cyl)
 
 
plot(-x_cyl,y_cyl,-x_cyl,-y_cyl,x_conver, y_conver,x_conver,-y_conver,Rao_x,Rao_y,Rao_x,-Rao_y)

end

