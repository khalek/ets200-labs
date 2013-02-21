function c = comb (a, k)

% Calculate the number of combinations of k taken out of a 
%
% version 1.0 980230 written by Håkan Petersson
%

  if (size (a) ~= [1 1] ) or (size (k) ~= [1 1])
    error ('ERROR: (Comb) Can not handle matrix or arrays');
  end
  c = 1;
  for i = 1:(a-k),
    c = c *(( a+1-i)/(a-k+1-i));
  end
  c = round (c);
