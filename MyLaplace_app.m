function [s] = MyLaplace_app(r_th,Ns,m,c,h,lambda_bs,alpha_l,alpha_nl,varphi,beta)

% r_th: threshold;
% Ns: number of antennas at the source;
% m: Nakagami-m factor;
% c: approximation parameter for LoS probability;
% h: height;
% lambda_bs: density for BS, range should be larger than 0.0019 (c for 10);
% alpha_l: LoS path loss exponent
% alpha_nl: NLoS path loss exponent

phi_1 = (gamma(Ns*m+1))^(-1/(Ns*m));
phi_2 = (gamma(Ns+1))^(-1/(Ns));

sum_1 = 0;
for n = 0:Ns
    sumterm_1 = integral(@(x)(1-1./(1+varphi.*(exp(-beta.*(180/pi.*atan(h./x)-varphi))))).*2*pi*lambda_bs.*exp(-pi*lambda_bs.*x.^(2*alpha_l/alpha_nl))...
        .*exp(pi*lambda_bs/c.*(exp(-c.*x.^2)-exp(-c.*x.^(2*alpha_l/alpha_nl))))...
        .*(alpha_l/alpha_nl.*x.^(2*alpha_l/alpha_nl-1)-alpha_l/alpha_nl.*x.^(2*alpha_l/alpha_nl-1).*exp(-c.*x.^(2*alpha_l/alpha_nl))+x.*exp(-c.*x.^2))...
        .*(-1)^n.*nchoosek(Ns,n).*exp(-2*pi*lambda_bs.*arrayfun(@(xx)integral(@(y)y.*(1-1./((1+phi_2*n*r_th/m.*(xx^2+h^2)^(alpha_nl/2).*(y.^2+h^2).^(-alpha_l/2))).^m).*1./(1+varphi.*(exp(-beta.*(180/pi.*atan(h./y)-varphi)))),xx,inf),x))...
        .*exp(-2*pi*lambda_bs.*arrayfun(@(xx)integral(@(z) z.*(1-1./(1+phi_2*n*r_th*(xx^2+h^2)^(alpha_nl/2).*(z.^2+h^2).^(-alpha_nl/2))).*(1-1./(1+varphi.*(exp(-beta.*(180/pi.*atan(h./z)-varphi))))),xx^(alpha_l/alpha_nl),inf),x)),...
        0,inf);
    sum_1 = sum_1 + sumterm_1;
    
%     2*pi*lambda_bs.*exp(-pi*lambda_bs.*x.^(2*alpha_l/alpha_nl))...
%         .*exp(pi*lambda_bs/c.*(exp(-c.*x.^2)-exp(-c.*x.^(2*alpha_l/alpha_nl))))...
%         .*(alpha_l/alpha_nl.*x.^(2*alpha_l/alpha_nl-1)-alpha_l/alpha_nl.*x.^(2*alpha_l/alpha_nl-1).*exp(-c.*x.^(2*alpha_l/alpha_nl))+x.*exp(-c.*x.^2))
end
sum_2 = 0;
for n = 0:Ns*m
    sumterm_2 = integral(@(x)(1./(1+varphi.*(exp(-beta.*(180/pi.*atan(h./x)-varphi))))).*2*pi*lambda_bs.*exp(-pi*lambda_bs.*x.^(2*alpha_l/alpha_nl))...
        .*exp(pi*lambda_bs/c.*(exp(-c.*x.^2)-exp(-c.*x.^(2*alpha_l/alpha_nl))))...
        .*(alpha_l/alpha_nl.*x.^(2*alpha_l/alpha_nl-1)-alpha_l/alpha_nl.*x.^(2*alpha_l/alpha_nl-1).*exp(-c.*x.^(2*alpha_l/alpha_nl))+x.*exp(-c.*x.^2))...
        .*(-1)^n.*nchoosek(Ns*m,n).*exp(-2*pi*lambda_bs.*arrayfun(@(xx)integral(@(y)y.*(1-1./((1+phi_1*n*r_th.*(xx^2+h^2)^(alpha_l/2).*(y.^2+h^2).^(-alpha_l/2))).^m).*1./(1+varphi.*(exp(-beta.*(180/pi.*atan(h./y)-varphi)))),xx,inf),x))...
        .*exp(-2*pi*lambda_bs.*arrayfun(@(xx)integral(@(z) z.*(1-1./(1+phi_1*n*m*r_th*(xx^2+h^2)^(alpha_l/2).*(z.^2+h^2).^(-alpha_nl/2))).*(1-1./(1+varphi.*(exp(-beta.*(180/pi.*atan(h./z)-varphi))))),xx^(alpha_l/alpha_nl),inf),x)),...
        0,inf);
    sum_2 = sum_2 + sumterm_2;
    
%    2*pi*lambda_bs.*exp(-pi*lambda_bs.*x.^2).*x
%     2*pi*lambda_bs.*exp(-pi*lambda_bs.*x.^(2*alpha_l/alpha_nl))...
%         .*exp(pi*lambda_bs/c.*(exp(-c.*x.^2)-exp(-c.*x.^(2*alpha_l/alpha_nl))))...
%         .*(alpha_l/alpha_nl.*x.^(2*alpha_l/alpha_nl-1)-alpha_l/alpha_nl.*x.^(2*alpha_l/alpha_nl-1).*exp(-c.*x.^(2*alpha_l/alpha_nl))+x.*exp(-c.*x.^2))
 end
        
s=sum_1+sum_2;
    
    
   % .*Laplace_derivative_NL(r_th,Ns,m,c,h,lambda_bs,alpha_l,alpha_nl,x) xx^2+h^2
   
%    xx^(2*alpha_l/alpha_nl)+h^2