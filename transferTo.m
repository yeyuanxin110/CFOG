function cp= transferTo(tform,pt,H,flag);
%coordinate transformation by geometric transformation parameters

%input parameter
%             tform  - geometric transformation relationship
%             pt     - inputed (x,y) coordinates
%             H      - geometric transformation parameters
%             flag   - the type of geometric transformation, 0: affine, 1:
%                    - projective, 2: quadratic polynomial, 3: cubic
%                    - polynomial

%return value
%             cp    - the transformed (x,y) coordinates

if flag == 0
    cp = tformfwd(tform,pt);;
elseif flag == 1
    cp = tformfwd(tform,pt);;
else
    if flag == 2
        para =[1,pt(1),pt(2), pt(1).*pt(2), pt(1).*pt(1), pt(2).*pt(2)];
    elseif flag == 3
        para =[1,pt(1),pt(2), pt(1).*pt(2), pt(1).*pt(1), pt(2).*pt(2), pt(2).*(pt(1).^2), pt(1).*(pt(2).^2), pt(1).^3, pt(2).^3];
    end
    cp = para*H';
end

