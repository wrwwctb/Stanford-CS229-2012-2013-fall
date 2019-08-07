% clear all; close all;%clc;
% load nb_train_save
[spmatrix, tokenlist, category] = readMatrix('MATRIX.TEST');
testMatrix  = full(spmatrix);
numTestDocs = size(testMatrix, 1);
numTokens   = size(testMatrix, 2);

% Assume nb_train.m has just been executed, and all the parameters computed/needed
% by your classifier are in memory through that execution. You can also assume 
% that the columns in the test set are arranged in exactly the same way as for the
% training set (i.e., the j-th column represents the same token in the test data 
% matrix as in the original training data matrix).

% Write code below to classify each document in the test set (ie, each row
% in the current document word matrix) as 1 for SPAM and 0 for NON-SPAM.

% Construct the (numTestDocs x 1) vector 'output' such that the i-th entry 
% of this vector is the predicted class (1/0) for the i-th  email (i-th row 
% in testMatrix) in the test set.
output = zeros(numTestDocs, 1);

logphiy   = log( phiy );
log1_phiy = log( 1- phiy );
logphikPos = log( phikPos );
logphikNeg = log( phikNeg );
posComponent = logphiy   * ones( numTestDocs, 1);
negComponent = log1_phiy * ones( numTestDocs, 1);

for idx1 = 1:numTestDocs
    for idx2 = 1:numTokens
        posComponent(idx1) = posComponent(idx1) + testMatrix(idx1,idx2)*logphikPos( idx2 );
        negComponent(idx1) = negComponent(idx1) + testMatrix(idx1,idx2)*logphikNeg( idx2 );
    end
    if ( posComponent(idx1) >= negComponent(idx1) )
        output(idx1) = 1;
    end
end

% Compute the error on the test set
error=0;
for idx=1:numTestDocs
  if ( category(idx) ~= output(idx) )
    error=error+1;
  end
end

disp( error/numTestDocs );

% part 2b
indicator = log(phikPos./phikNeg);
indicator = [indicator' (1:numTokens)'];
indicator = sortrows(indicator,1);
