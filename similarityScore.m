function [score] = similarityScore(descriptor1,descriptor2)

% calc score
sameSign = sign(descriptor1)  == sign(descriptor2) & sign(descriptor2) ~=0;
minVec = min(abs(descriptor1),abs(descriptor2));
score = sum(minVec(sameSign) );

end

