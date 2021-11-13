function H = solvePoly(x,y,n)
%求解二次或者三次多项式

if n == 2
    nim = size(x(:,1),1);
    if nim < 6;
        disp('控制点数量太少');
        return;
    end
    A = [ones(nim,1),x(:,1),x(:,2),x(:,1).*x(:,2),x(:,1).^2,x(:,2).^2,];
    ATA = A'*A;
    ATA1 = inv(ATA);
    H = ATA1*(A'*y);
end
 if n == 3
    nim = size(x(:,1),1);
    if nim < 10;
        disp('控制点数量太少');
        return;
    end
    A = [ones(nim,1),x(:,1),x(:,2),x(:,1).*x(:,2),x(:,1).^2,x(:,2).^2,x(:,2).*(x(:,1).^2),x(:,1).*(x(:,2).^2),x(:,1).^3,x(:,2).^3];
    ATA = A'*A;
    ATA1 = inv(ATA);
    H = ATA1*(A'*y);
 end