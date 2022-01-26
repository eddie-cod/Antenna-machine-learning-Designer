clear;
clc;

A=[2,2,3];
x = 1:max(A);

K = size(A,2);                      %//Length of each permutation
%//Create all possible permutations (with repetition) of letters stored in x
C = cell(K, 1);             %//Preallocate a cell array
[C{:}] = ndgrid(x);         %//Create K grids of values
y = cellfun(@(x){x(:)}, C); %//Convert grids to column vectors
y = [y{:}];                 %//Obtain all permutations

D = bsxfun(@le,y,A)
E = all(D,2);
y(E,:)


