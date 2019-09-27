clear all;clc;
%% Input Image
 A=imread('lena.bmp');
%size of image
[row,col]=size(A);
%convert to double
A=double(A);
%% compression
p=8;    %Block Size
n=p^2; %number of pixels in one block
%2D-DCT process
f=A-128;
for R=1:p:row
   for C=1:p:col  
        for i=0:p-1
            for j=0:p-1
                sum=0;
                for x=0:p-1
                    for y=0:p-1
 sum=sum+f(x+R,y+C)*cos((2*x+1)*i*pi/(2*p))*cos((2*y+1)*j*pi/(2*p));
                    end 
                end

                Ci=1;Cj=1;
                if i==0
                   Ci=1/sqrt(2);
                end
                if j==0
                    Cj=1/sqrt(2);
                end

                F(i+R,j+C)=(2/p)*Ci*Cj*sum;
            end  
        end
   end
end
F=round(F);

%%%%%%% 2D-IDCT process %%%%%%%%%%%%%%%%%%%% 
for R=1:p:row
   for C=1:p:col
        for x=0:p-1
            for y=0:p-1

                sum=0;
                for i=0:p-1
                    for j=0:p-1
                    %%%%%%%%%%%%%%%%%%%%%    
                    Ci=1;Cj=1;
                    if i==0
                       Ci=1/sqrt(2);
                    end
                    if j==0
                        Cj=1/sqrt(2);
                    end
                    %%%%%%%%%%%%%%%%%%%%%
sum=sum+(Ci*Cj)*F(i+R,j+C)*cos((2*x+1)*i*pi/(2*p))*cos((2*y+1)*j*pi/(2*p));
                    end 
                end
                f(x+R,y+C)=(2/p)*sum;
            end  
        end
   end
end
image_SD=round(f+128);

image_FD=uint8(F);
figure('name','frequency domain image','numbertitle','off');
imshow(image_FD);
imwrite(image_FD,'frequency domain image.bmp');

image_SD=uint8(image_SD);
figure('name','Inverse Image','numbertitle','off');
imshow(image_SD);
% imwrite(image_SD,'Image in spatial domain.bmp');