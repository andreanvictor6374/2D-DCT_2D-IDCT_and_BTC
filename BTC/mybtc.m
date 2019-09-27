clear all;clc;
%% Input Image
A=imread('lena.bmp');
%size of image
[row,col]=size(A);
%convert to double
I=double(A);
p=8;    %Block Size
n=p^2; %number of pixels in one block
for R=1:p:row
    for C=1:p:col
        
        h_avg=0;
        h_ms=0;
        for i=0:p-1
            for j=0:p-1
                h_avg=h_avg+I(i+R,j+C);
                h_ms=h_ms+I(i+R,j+C)^2;
            end
        end
        h_avg=h_avg/(p^2);
        h_ms=h_ms/(p^2);
        sigma=sqrt(h_ms-h_avg^2);
        %get bitmap
        for i=0:p-1
            for j=0:p-1
                if I(i+R,j+C)>h_avg
                  bitmap(i+1,j+1)=1; 
                else
                  bitmap(i+1,j+1)=0; 
                end    
            end
        end
        q=sum(sum(bitmap));
        a=h_avg-sigma*sqrt(q/(n-q));           %low mean
        b=h_avg+sigma*sqrt((n-q)/q);           %high mean
        
        %mapping high mean and low mean value
        for i=0:p-1
            for j=0:p-1
                if bitmap(i+1,j+1)==1
                  BTCimage(i+R,j+C)=b; 
                else
                  BTCimage(i+R,j+C)=a; 
                end    
            end
        end
        
    end
end
BTCimage=uint8(BTCimage);
figure('name','Original Image','numbertitle','off');
imshow(A);
figure('name','BTC-Compressed Image','numbertitle','off');
imshow(BTCimage);
imwrite(BTCimage,'BTC-Compressed Image.bmp');
