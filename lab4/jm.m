function [Nnull,Teta,maxi,summa,s,u]=jm(N)


k=length(N);
s = k;
u = k+500;
n1 = k*sum(N);
i=1:k;

a=0;

while ((u-s)>0.001)
   Nnull=(s+u)/2;
   
   a=a+1;
   n2 = sum(1./(Nnull-i+1));
   n3 = (Nnull-i+1)*N;
  
   summa(a)=n2-n1/n3;
   
   if (summa(a) < 0)
      u=Nnull;
   else
      s=Nnull;
   end;
   
end;

Teta=k/n3;
maxi=a;