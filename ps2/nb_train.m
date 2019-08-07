clear all; close all;% clc;
[spmatrix, tokenlist, trainCategory] = readMatrix('MATRIX.TRAIN');

trainMatrix = full(spmatrix);
numTrainDocs = size(trainMatrix, 1);
numTokens = size(trainMatrix, 2);

% trainMatrix is now a (numTrainDocs x numTokens) matrix.
% Each row represents a unique document (email).
% The j-th column of the row $i$ represents the number of times the j-th
% token appeared in email $i$. 

% tokenlist is a long string containing the list of all tokens (words).
% These tokens are easily known by position in the file TOKENS_LIST

% trainCategory is a (1 x numTrainDocs) vector containing the true 
% classifications for the documents just read in. The i-th entry gives the 
% correct class for the i-th email (which corresponds to the i-th row in 
% the document word matrix).

% Spam documents are indicated as class 1, and non-spam as class 0.
% Note that for the SVM, you would want to convert these to +1 and -1.

% YOUR CODE HERE
numWordsInPos = numTokens;% laplace smoothing
numWordsInNeg = numTokens;
tokenCountsPos = ones(1,numTokens);% laplace smoothing
tokenCountsNeg = ones(1,numTokens);
numPos         = 0;
for idx1 = 1:numTrainDocs
    if ( trainCategory(idx1) )
        numPos = numPos + 1;
        numWordsInPos = numWordsInPos + sum(trainMatrix(idx1,:));
        for idx2 = 1:numTokens
            tokenCountsPos(idx2) = tokenCountsPos(idx2) + trainMatrix(idx1,idx2);
        end
    else
        numWordsInNeg = numWordsInNeg + sum(trainMatrix(idx1,:));
        for idx2 = 1:numTokens
            tokenCountsNeg(idx2) = tokenCountsNeg(idx2) + trainMatrix(idx1,idx2);
        end
    end
end
phikPos = tokenCountsPos / numWordsInPos;
phikNeg = tokenCountsNeg / numWordsInNeg;
phiy = numPos / numTrainDocs;
disp(numTrainDocs);
save nb_train_save