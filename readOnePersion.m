function [faceContainer,label]=readOnePersion(facepath)
I = imread('dataset/train/s1/1.pgm');
[M,N] = size(I);
label=zeros(1,1);
faceContainer=zeros(1,M*N);  
img=imread(facepath);
faceContainer(1,:)=img(:)';
save('ORL\faceContainer','faceContainer');