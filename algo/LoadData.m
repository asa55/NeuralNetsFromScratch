function x = LoadData()
%LOADDATA Loads all images data and performs some basic preprocessing
%   Looking at all the images, there is a lot of variability in terms of
%   the translation, rotation, and scale for each character. Luckily, we
%   are dealing with binary masks so the characters themselves are very
%   clean, and it was easy to do specify some simple preprocessing.
%   The neural net was first trained without any preprocessing of the image
%   data, but the performance was subpar. The below code does the following:
%   (1)  loads the next image pointed to in imagePaths
%   (2)  converts the rgb image to grayscale (since image is a mask, this could have been handled by simply cutting out 2 of the 3 channels, but in the off chance there was a problem with a single channel, rgb2gray is the more robust option)
%   (3)  inverts image color (some operations pad with 0, but the original image has 255 values at the border and 0's where the character is drawn. The complement makes it so that the padding has the same value as the non-character part of the binary mask)
%   (4)  casts the uint8 entries as type double (before operating on the image)
%   (5)  creates a bounding box version of the image by cutting out all horizontal and vertical lines that don't contain any character information
%   (6)  proportionally scales the bounding box image up until it has the same pixel size as that of the smallest dimension of the original image (900x1200)
%   (7)  pads the remaining dimension with whitespace so that the new size is 900x1200
%   (8)  pads the smaller dimension with whitespace so that the new image is square and of size 1200x1200
%   (9)  calculates the center of mass of the image (which in this case is the center of the character)
%   (10) translates the image so that the character is centered in the image
%   (11) downsamples the image so that the new size is 38x38
%   (12) stretches the image into a column vector and appends it to the feature matrix x
%   (13) repeats from step 1 until there are no more images
%
% This basically normalizes the data in terms of translation and scale.
% Potential rotations of each character is handled differently by the Main script.
%
% Also, the image loading and preprocessing is kind of slow - maybe 5
% minutes on my PC. I included the preprocessed data as a .mat file in the
% submission - it definitely saves time to load that to the workspace. I
% recommend you do that now unless you want to watch the preprocessing step
% in action. Main will skip this preprocessing step if x is already defined.

show_images = 0;  % this is disabled by default but if you want to see the preprocessing visually, set this 0 to a 1. I inserted pauses so you could get a visual and I intend for you to abort the process (using Ctrl + c) after you're satisfied that you follow the steps taken by the preprocessor. The images don't load fast but it will be much faster when show_images is set to 0.

f = waitbar(0,'Finding image paths...');
[~,imagePaths_] = fileattrib('EnglishHnd\*');  
for i=1:length(imagePaths_)
    if isfile(imagePaths_(1,i).Name)
        imagePaths{i,1} = imagePaths_(1,i).Name;
    else imagePaths{i,1}='';
    end
end
clear i
filePaths = imagePaths;
filePaths(cellfun('isempty',imagePaths))=[];
clear imagePaths imagePaths_ i
x = zeros(38*38,62*55);  % I tweak this by hand to preallocate size.

for i = 1:62*55
    
    waitbar(i/(62*55),f,'Preprocessing images...');
    if show_images
        imshow(imread(filePaths{i}));
        pause(1)
    end
    
    % invert image color
    im_ = double(imcomplement(rgb2gray(imread(filePaths{i}))));
    imsize_ = size(im_);
    
    if show_images
        imshow(im_);
        pause(1)
    end
    
    % cut down around bounding box
    im_ = im_(sum(im_,2)>0,sum(im_,1)>0);
    [pad_,dir_] = max(imsize_-size(imresize(im_,min(imsize_./size(im_)))));
    
    
    if show_images
        imshow(im_);
        pause(1)
    end
    
    % rescale and pad one side of image
    switch dir_
        case 1
            im_ = padarray(imresize(im_,min(imsize_./size(im_))),pad_,0,'post');
            im_ = padarray(im_,1200-min(size(im_)),0,'post');
        case 2
            im_ = padarray(imresize(im_,min(imsize_./size(im_)))',pad_,0,'post')';
            im_ = padarray(im_,1200-min(size(im_)),0,'post');
    end
    
    if show_images
        imshow(im_);
        pause(1)
    end    
    
    % center character in image
    imsize_ = size(im_);
    [X,Y] = meshgrid([1:imsize_(2)],[1:imsize_(1)]);
    xshift = sum(sum(im_.*X))/sum(sum(im_));
    yshift = sum(sum(im_.*Y))/sum(sum(im_));
    im_ = (imtranslate(im_,[imsize_(2)/2-floor(xshift),imsize_(1)/2-floor(yshift)]));

    if show_images
        imshow(im_);
        pause(1)
    end
    
    % downsample and append to feature matrix
    x(:,i) = reshape(downsample(downsample(im_(:,:,1),32)',32)',[length(x(:,1)),1]);

    if show_images
        imshow(downsample(downsample(im_(:,:,1),32)',32)');
        pause(1)
    end

end
clear i
close(f)
x = double(x/255.0);
clear im_ filePaths
end


