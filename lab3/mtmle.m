function Nhat=mtmle(InspectionData)
% Calculate an estimation of the number of faults 
% using Mt-Maximumlikelihood estimator
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
% version 1.0 written by Håkan Petersson
% version 1.01 updated by Thomas Thelin
% version 1.02 updated by Thomas Thelin
% version 1.10 updated 980713 by Håkan Petersson (return -1 if unsuccessfull)
%
 
  sInspectionData = size (InspectionData); 
  D = nnz(sum(InspectionData,2));       
  k = sInspectionData(2);                  	
  n = sum (InspectionData,1);        
  checkstop =0;
  Nest = D-1;
  MaxLikeOld = -1000;
  MaxLikeNew = -999;							

%
% iterative until the correct estimation value is found
% 

  rm = nnz(sum(InspectionData,2));
  rnsum = sum(sum(InspectionData,1));
  if (rnsum-rm)<0.5,
      Nhat=-1;
      return;
  end;


  while ((MaxLikeNew>MaxLikeOld) & (checkstop < 200)),
    checkstop = checkstop+1;
    Nest = Nest+1;
    prodd = comb(Nest,D);
    sum1 = 0;
    sum2 = 0;
    for j = 1:k,
      if (n(j) ~= 0),
        sum1 = sum1 + n(j)*log10(n(j));
      end
      if (Nest ~= n(j)),
        sum2 = sum2 + (Nest - n(j))*log10(Nest-n(j));
      end
    end
    MaxLikeOld = MaxLikeNew;
    MaxLikeNew = log10(prodd) +sum1 - Nest*k*log10(Nest)+sum2;
  end
  if (checkstop == 200),
    % disp ('ERROR: (MLE) Not able to estimate!');
	 Nest = -1;
  else
    Nest = Nest -1;
  end
Nhat = Nest;








