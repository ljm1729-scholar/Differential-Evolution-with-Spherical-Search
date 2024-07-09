function X=omi_ode_3rd_wave_with_C(t,X0,mu_in,days_point,R_old,kappa_old,alpha_old,p_old,gamma_mild_old,gamma_severe_old,f_old,waningR)


if t==days_point(1)
    mu_index=1;
else
    mu_index=min([length(days_point(days_point<t)),length(days_point)-1]);
end
mu=mu_in(mu_index);

E1=X0(1);
I1=X0(2);
Q11=X0(3);
Q21=X0(4);
R1=X0(5);
D1=X0(6);
S=X0(7);

% X0=X0';
% name=["E1",...
%       "I1",...
%       "Q11",...
%       "Q21",...
%       "R1",...
%       "D1",...
%       "S"];
% for i=1:length(X0)
%     eval(join([name(i),'=X0(i);']))
% end

N=sum(X0([1,2,5,7]));



infection1=R_old*alpha_old*(1-mu)*(I1)/N;

dE1=(S)*(infection1)-kappa_old*E1;
dI1=kappa_old*E1-alpha_old*I1;
dQ11=(1-p_old)*alpha_old*I1-gamma_mild_old*Q11;
dQ21=(p_old)*alpha_old*I1-gamma_severe_old*Q21;
dR1=gamma_mild_old*Q11+(1-f_old)*gamma_severe_old*Q21 -waningR*R1;
dD1=(f_old)*gamma_severe_old*Q21;
dS=-S*infection1+waningR*R1;
dC=alpha_old*I1;

X=[...
    dE1;...
    dI1;...
    dQ11;...
    dQ21;...
    dR1;...
    dD1;...
    dS;...
    dC;...
    ];
end