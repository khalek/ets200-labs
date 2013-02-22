function [Nhat,StdDev,ConfInt,ConfNorm] = capjke(InspectionData)

%
% This version is used in the software testing course 
% Thomas Thelin
%

% set to 1 if printing info to screen
global  out2scr;
   out2scr = 0;


   k = size(InspectionData,2);

   nday = k;

%
% the number of unique faults found
%

%%  D = nnz(sum(InspectionData,2));

rm = nnz(sum(InspectionData,2));
rnsum = sum(sum(InspectionData,1));
mm = min(5,nday);

%
% error control
%

  for i = 1:k,
     f(i) = size(find(sum(InspectionData,2) == i),1); 
  end

  ifreq = f;


    a=ones(5,31);

  endloop=0;
  while (endloop==0),
     a(1,1) = a(1,1)+(k-1)/k;
     if (nday==1),
       break;
     end;
     % nday = 2
     a(2,1) =a(2,1)+(2*k-3) / k;
     a(2,2) = a(2,2)- (k-2)^2 / (k*(k-1)); 
     if (nday==2),
       break;
     end;
     % nday = 3
     a(3,1) = a(3,1)+(3*k-6) / k; 
     a(3,2) = a(3,2)-(3*k^2-15*k+19) / (k*(k-1));
     a(3,3) = a(3,3)+(k-3)^3 / (k*(k-1)*(k-2));
     if (nday==3),
       break;
     end;
     % nday = 4
     a(4,1) = a(4,1)+(4*k-10) / k; 
     a(4,2) = a(4,2)-(6*k^2-36*k+55) / (k*(k-1));
     a(4,3) = a(4,3)+(4*k^3-42*k^2+148*k-175) / (k*(k-1)*(k-2));
     a(4,4) = a(4,4)-(k-4)^4 / (k*(k-1)*(k-2)*(k-3));
     if (nday==4),
       break;
     end;
     % nday =5
     a(5,1) = a(5,1)+(5*k-15) / k; 
     a(5,2) = a(5,2)-(10*k^2-70*k+125) / (k*(k-1));
     a(5,3) = a(5,3)+(10*k^3-120*k^2+485*k-660) / (k*(k-1)*(k-2));
     a(5,4) = a(5,4)-((k-4)^5-(k-5)^5) / (k*(k-1)*(k-2)*(k-3));
     a(5,5) = a(5,5)+(k-5)^5 / (k*(k-1)*(k-2)*(k-3)*(k-4));
     endloop=1;
  end
   if (out2scr==1),
      disp('Computed Jacknife coefficients');
      disp(a')
   end;

% Calculate estimators, stderror and hypoteses test
   if (rm==1),
      Nhat = 1;
      return;
   end;
   q=rm/(rm-1);
   for i=1:5,
      test(i)=0;
      pi(i) = 0;
      power(i) = 0;
      xn(i) = 0;
      vxn(i) = 0;
      for j=1:nday,
         xn(i)=xn(i)+a(i,min(31,j))*ifreq(j);
         vxn(i)=vxn(i)+a(i,j)*a(i,min(31,j))*ifreq(j);
      end
      vxn(i)=sqrt(max(0,vxn(i)-xn(i)));
      xu(i)=xn(i)+1.96*vxn(i);
      xl(i)=xn(i)-1.96*vxn(i);
   end
   ind=min(4,nday-1);
   pi(ind+1) = 1;
   for i=1:ind,
      test(i)=0;
      for j=1:nday,
         test(i)=test(i)+(a(i+1,min(31,j))-a(i,min(31,j)))^2*ifreq(j);
      end;
      w=xn(i+1)-xn(i);
      test(i)=test(i)-w*w/rm;
      if (test(i)~=0),
         test(i)=w*w/(q*test(i));
         if (test(i)<1),
            power(i) = 0.05;
         else
            lambda=max(0,test(i)-1);
            power(i) = cpower(0.05,lambda);
         end;  
         pi(1)=1-power(1);
         piprod=1;
         for ipi=1:(i-1),
            piprod = piprod*power(ipi);
         end;
         pi(i)=piprod*(1-power(i));
         pi(ind+1) = pi(ind+1)*power(i);
      else
         % Nothing at all
      end
   end

   exptnh = 0;
   varcom = 0;
   varco2 = 0;
   for i=1:mm,
      exptnh = exptnh + pi(i)*xn(i);
   end;
   for i=1:mm,
      varcom = varcom + pi(i) * vxn(i) * vxn(i);
      varco2 = varco2 + pi(i) * (xn(i)-exptnh)*(xn(i)-exptnh);
   end;
   varn=varcom+varco2;
   realsd=sqrt(varn);
   if (out2scr==1),
      for i=1:mm,
         fprintf(1,'%i  %3.1f  %3.2f  %3.1f  %3.1f  %3.3f\n',i,xn(i),vxn(i),xl(i),xu(i),test(i));
      end;
   end;
   [est,se]=interp(test,xn,vxn,nday,a,ifreq,rm,rnsum);
   if est==-1,
      Nhat= -1;
      return;
   end;
   relest=est;
   est = floor(est+.5);
   se = realsd;
   if ( (relest-rm) > eps),
      cvalue = exp(1.96*sqrt(log(1+varn/((relest-rm)*(relest-rm)))));
      ilglci = min(est, floor((rm+(relest-rm) / cvalue))+1);
      ilguci = floor(rm +(relest-rm)*cvalue);
   else
      ilglci = rm;    %m(nday+1);
      ilguci = rm;    %m(nday+1);
   end;
   iprlci=ilglci;
   ipruci=ilguci;
   if (out2scr==1),
      fprintf(1,'Interpollated population estimate is %5i\n with standard error %5.4f\n',est,se);
      fprintf(1,'Approximate 95 percent confidence interval %5i to %5i\n',ilglci,ilguci);
   end;
   Nhat=est;  
	StdDev=se;
	ConfInt=[ilglci ilguci];
	ConfNorm= [max(rm,floor(xl));xu];
   clear out2scr;
%*************************************
function power=cpower(alfa,lambda)
   global out2scr;

   power=-1;
   if ((alfa<0)|(alfa>1)),
      return;
   end;
   df = 1;
   idf =df;
   if (lambda<0),
      return;
   end;
   crit = 3.8416;
   if (lambda > 0),
      if (lambda<700),
         poissn=exp(-lambda/2);
      else
         power=1.0;
         return;
      end;
   else
      poissn = 1;
   end;
   sp = chi2cdf(crit,idf);
   p=sp;
   if (p<-0.9),
      power = -2;
      return;
   end
   power=poissn*p;
   sump=poissn;
   if (sump>=0.99999),
      power=1-power; 
      return;
   end;
   k=1;
   newdf=idf;
   poissn=poissn*(lambda/2)/k;
   sump=sump+poissn;
   newdf=newdf+2;
   k=k+1;
   sp=chi2cdf(crit,newdf);
   p=sp;
   if(p<-0.9),
      power=-2;
      return;
   end;
   power=power+poissn*p;
   while (sump<=0.99999),
      poissn=poissn*(lambda/2)/k;
      sump=sump+poissn;
      newdf=newdf+2;
      k=k+1;
      sp=chi2cdf(crit,newdf);
      p=sp;
      if(p<-0.9),
         power=-2;
         return;
      end;
      power=power+poissn*p;
   end
   power=1-power;


%*****************************************

function [xn,vxn]=interp(test,xnhat,vxnhat,nday,a,ifreq,rm,rnsum)

   global out2scr;
   mm = min([5 nday]);
   for i=1:mm,
      mt=i;
      if(test(i)<3.84),
         mt=i;
         break;
      end;
   end;
   
   if (mt~=1),
      alpha=(test(mt-1)-3.84)/(test(mt-1)-test(mt));
      beta = 1-alpha;
      xn=0;
      vxn=0;
      for i=1:nday,
         z=a(mt,i)*alpha+a(mt-1,i)*beta;
         xn=xn+ifreq(i)*z;
         vxn=vxn+z*z*ifreq(i);
      end;
      if(xn<rm),
         xn=xnhat(1);
         vxn=vxnhat(1);
         if (out2scr==1),
            disp('Ill conditioned data');
         end;
        % "goto 60" - Solves with 60 comming right after else.
      else
         vxn=sqrt(max(0,vxn-xn));
      end;
  % label 60   
      ixn=floor(xn+0.5);
      phat=rnsum/(nday*ixn);
      if (out2scr==1),
         fprintf(1,'Average p-hat = %6.4f\n',phat);
      end;
      return;
   end;
   % mt = 1
  % label 70
   xn=a(1,1)*ifreq(1)+rm;
   xtest=xn*ifreq(1)/(xn-ifreq(1));
   if(xtest<=3.84),
      if ((rm>=20) & ((ifreq(1)/rm)<=1)),
        % label 90
         vxn=vxnhat(1);
         if (out2scr==1),
            disp('Most Data have been seen');
         end;
        % "goto 60"
         ixn=floor(xn+0.5);
         phat=rnsum/(nday*ixn);
         if (out2scr==1),
            fprintf(1,'Average p-hat = %6.4f\n',phat);
         end;
         return; 
      else
         xn=xnhat(1);
         vxn=vxnhat(1);
         if (out2scr==1),
            disp('Data ill cond');
         end;
        % "goto 60"
        
         ixn=floor(xn+0.5);
         phat=rnsum/(nday*ixn);
         if (out2scr==1),
            fprintf(1,'Average p-hat = %6.4f\n',phat);
         end;
         return;
      end;
      return;
   end;
  % label 100
   alpha=(xtest-3.84)/(xtest-test(1));
   beta=1-alpha;
   xn=0;
   vxn=0;
   for i=1:nday,
      z=a(1,i)*alpha+beta;
      xn=xn+ifreq(i)*z;
      vxn=vxn+z*z*ifreq(i);
   end;
   vxn=sqrt(max(0,vxn-xn));
   ixn=floor(xn+0.5);
   phat=rnsum/(nday*ixn);
   if (out2scr==1),
      fprintf(1,'Average p-hat = %6.4f\n',phat);
   end;
   return;
