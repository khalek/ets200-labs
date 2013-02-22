function [a,b]=go(N)

k=length(N);
l = 0;
u = 3;
n = sum(N);

while ((u-l)>0.001)
   b=(l+u)/2;
   summa = 0;
   for i=2:k
      namn = exp(-b*(i-1))-exp(-b*i);
      summa = summa+N(i)*(i*exp(-b*i)-(i-1)*exp(-b*(i-1)))/namn;
   end;
   summa = summa+N(1)*(1*exp(-b))/(1-exp(-b*1));
   summa = summa-n*k*exp(-b*k)/(1-exp(-b*k));
   
   if (summa < 0)
      u=b;
   else
      l=b;
   end;
   
end;

a=n/(1-exp(-b*k));