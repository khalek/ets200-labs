function Nhat=m0mle(InspectionData)
% Calculate an estimation of the number of faults 
% using M0-Maximumlikelihood estimator
%
% Nhat - the estimation value
%
% InspectionData - the matrix containing inspection data 
%
% D - the number of unique faults found
% k - the number of inspectors
% n - the number of faults each inspector found
% Nest - the estimation value
%
% version 1.0 written by Thomas Thelin
% version 1.01 updated by Thomas Thelin
% version 1.02 updated by Thomas Thelin
% version 1.10 980713 updated by Håkan Petersson (returning -1 if unsuccessfull)
% version 1.11 990730 updated by Håkan Petersson (changed Comb to comb)
% 
   sInspectionData = size (InspectionData); 
   D = nnz(sum(InspectionData,2));        
   k = sInspectionData(2);                  	
   n = sum (InspectionData,1);        
   checkstop =0;
   Nest = D-1;
   MaxLikeOld = -1000;
   MaxLikeNew = -999;

   nDot = sum(n,2);
   sum1 = nDot*log10(nDot);

%
% Iterative until the correct estimation value is found
%
					
   while ((MaxLikeNew>MaxLikeOld) & (checkstop < 200)),
     checkstop = checkstop+1;
     Nest = Nest+1;
     prodd = comb(Nest,D);
     
     if (k*Nest ~= nDot),
       sum2 = (k*Nest - nDot)*log10(k*Nest - nDot);
     end

     MaxLikeOld = MaxLikeNew;
     MaxLikeNew = log10(prodd) +sum1 - Nest*k*log10(k*Nest)+sum2;
   end
  if (checkstop == 200),
%    error ('ERROR: (MLE) Not able to estimate!');
     Nest = -1;
	  Nhat = Nest;
  else
    Nest = Nest -1;
    Nhat = Nest;
  end









