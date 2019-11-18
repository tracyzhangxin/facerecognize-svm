function [faceContainer,label]=ReadFace(n_persons,flag)
%   ORL�����⡣pgm��ʽ��ͼƬ��40�ˣ�ÿ��10��ͼ��ͼ���СΪ112*92���ء�
%   ÿ������10����Ƭ��ǰ5������ѵ��������5���������Լ�
%   ��flagΪ0ʱ����ʾ����Ϊѵ������flagΪ1ʱ����ʾ����Ϊ���Լ�
%   n_personsΪ��ͬ��������
%   label�������ݵı�ǩ
%   faceContainer��һ����������������������ÿһ��ͼƬת��һ������������ÿ����
I = imread('dataset/train/s1/1.pgm');
[M,N] = size(I);

label=zeros(n_persons*5,1);
faceContainer=zeros(n_persons*5,M*N);
for i=1:n_persons
    %·������
    %����num2str(i)˵����������ת��Ϊ�ַ�
    facepath=strcat('dataset/train/s',num2str(i),'/');  %·����ͬ�������
    temppath=facepath;
    for j=1:5
        facepath=temppath;
        if flag==0      
            facepath=strcat(facepath,num2str(j));
        else
            facepath=strcat(facepath,num2str(j+5));
        end
        label((i-1)*5+j)=i;
        facepath=strcat(facepath,'.pgm');    
        img=imread(facepath);
        faceContainer((i-1)*5+j,:)=img(:)';
    end
end
save('ORL\faceContainer','faceContainer');