function [corrRefPt,corrSenPt] = ErrorDect(refPt,senPt,flag,errThe)
% eliminate the error
%flag --- 0 is 'projective'; ~0 is 'cubic ploynomial'
%errThe   the  threshold of error

if flag
    tform = cuPloy(senPt,refPt);%inverse transformation by cubic ploynomial
else
    tform = proj(refPt,senPt);
end
ptNum = size(refPt,1);
%transform the refpt to the sen image
if flag
    T = tform.tdata;
    ptNum = size(refPt,1);
    x1 = refPt(:,1);
    y1 = refPt(:,2);
    para =[ones(ptNum,1),x1,y1, x1.*y1, x1.*x1, y1.*y1, y1.*(x1.^2), x1.*(y1.^2), x1.^3, y1.^3];
    refToSen = para*T;
else
    refToSen = tformfwd(tform,refPt);
end

%cal the residual
% if flag
%     err = senToRef - refPt;
% else
 err = refToSen-senPt;
% end
 residual = sqrt(err(:,1).^2 + err(:,2).^2);
[maxV,ind] = max(residual);
meanErr = norm(residual)/sqrt(ptNum);
while meanErr > errThe & ptNum
    refPt(ind,:) = [];
    senPt(ind,:) = [];
    if flag
        tform = cuPloy(senPt,refPt);
    else
        tform = proj(refPt,senPt);
    end
    %transform the refpt to the sen image
    if flag
        T = tform.tdata;
        ptNum = size(refPt,1);
        x1 = refPt(:,1);
        y1 = refPt(:,2);
        para =[ones(ptNum,1),x1,y1, x1.*y1, x1.*x1, y1.*y1, y1.*(x1.^2), x1.*(y1.^2), x1.^3, y1.^3];
         refToSen = para*T;
    else
        refToSen = tformfwd(tform,refPt);
    end
    
    ptNum = size(refPt,1);
    %cal the residual
%     if flag
%         err = senToRef - refPt;
%     else
        err = refToSen-senPt;
%     end
    residual = sqrt(err(:,1).^2 + err(:,2).^2);
    meanErr = norm(residual)/sqrt(ptNum);
    [maxV,ind] = max(residual);
    ptNum = size(refPt,1);
end

corrRefPt = refPt;
corrSenPt = senPt;
    
    
 
 

function tform = cuPloy(refPt,senPt)
   tform = cp2tform(refPt,senPt,'polynomial',3);

function tform = proj(refPt,senPt)
   tform = cp2tform(refPt,senPt,'projective');
    