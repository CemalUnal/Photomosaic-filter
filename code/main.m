
source = imread('sample.jpg');
temp = source;
temp = imresize(temp,[2000,2000]);

[x,y,dump]=size(source);

source = rgb2lab(source);
source=imresize(source,[2000,2000]);

l=source(:,:,1);
a=source(:,:,2);
b=source(:,:,3);

imagecount=20;
amount=size(source,1)/imagecount;

% Give the directory of image stock
Directory=fullfile('C:','Users','PC','Desktop','BBM413-Proje','Resimler');
MyImages = dir(fullfile(Directory,'*.jpg'));
Names={MyImages.name};

Colors=zeros(3,size(Names,2),'double');


% Read image stock
Counter=0;
tic;
parfor m=1:size(Names,2)
    for k=1:3
    labcolors=rgb2lab(imread(fullfile(Directory,Names{m})));
    Colors(m,k)=mode(mode(labcolors(:,:,k)));
    end
    Counter=Counter+1
end
toc

Counter=0;
tic;
for i=1:amount
    
    for j=1:amount
        
        lsource=mode(mode(l((i*imagecount)-(imagecount-1):(i*imagecount),(j*imagecount)-(imagecount-1):(j*imagecount))));
        asource=mode(mode(a((i*imagecount)-(imagecount-1):(i*imagecount),(j*imagecount)-(imagecount-1):(j*imagecount))));
        bsource=mode(mode(b((i*imagecount)-(imagecount-1):(i*imagecount),(j*imagecount)-(imagecount-1):(j*imagecount))));
         
        min=sqrt( ((lsource-Colors(1,1)).^2) + (asource-Colors(1,2)).^2 + ((bsource-Colors(1,3)).^2) );
        
		% compare images from image stock with input image's current small piece
		% take the image which gives minimum distance
        index=1;
         for k=2:size(Names,2)
             if(min>sqrt( ((lsource-Colors(k,1)).^2) + (asource-Colors(k,2)).^2 + ((bsource-Colors(k,3)).^2) ))                    
             index=k;
             min=sqrt((lsource-Colors(k,1)).^2 + (asource-Colors(k,2)).^2 + ((bsource-Colors(k,3)).^2));
             end
         end
		
         randimage=imread(fullfile(Directory,Names{index}));
           
         randimage=imresize(randimage,[imagecount,imagecount]);
          
         temp((i*imagecount)-(imagecount-1):(i*imagecount),(j*imagecount)-(imagecount-1):(j*imagecount),:)=randimage(:,:,:);
         
         Counter=Counter+1
         
    end
    
end
toc
        source=temp;
        source=imresize(source,[x,y]);
        imshow(source);
		imwrite(source,'result.jpg');
