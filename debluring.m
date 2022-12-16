pic = imread('cameraman.tif');

psf = fspecial('motion',21,11);
imdouble = im2double(pic);
blurred = imfilter(imdouble,psf,'conv','circular');

wnr1 = deconvwnr(blurred,psf);

noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred,'gaussian',noise_mean,noise_var);

wnr2 = deconvwnr(blurred_noisy,psf);

signal_var = var(imdouble(:));
nsr = noise_var / signal_var;
wnr3 = deconvwnr(blurred_noisy,psf,nsr);

blurred_quantized = imfilter(pic,psf,'conv','circular');

wnr4 = deconvwnr(blurred_quantized,psf);

uniform_quantization_var = (1/256)^2 / 12;
signal_var = var(imdouble(:));
nsr = uniform_quantization_var / signal_var;
wnr5 = deconvwnr(blurred_quantized,psf,nsr);

filt = fspecial("average");
fpic = filter2(filt, pic);
sharp_pic = double(pic)-fpic/1.5;

figure,
subplot(521),imshow(pic); title('Original Image');
subplot(522),imshow(blurred); title('Blurred Image');
subplot(523),imshow(wnr1); title('Restored Blurred Image');
subplot(524),imshow(blurred_noisy); title('Blurred and Noisy Image');
subplot(525), imshow(wnr2); title('Restoration of Blurred Noisy Image (NSR = 0)');
subplot(526),imshow(wnr3); title('Restoration of Blurred Noisy Image (Estimated NSR)');
subplot(527),imshow(blurred_quantized); title('Blurred Quantized Image');
subplot(528),imshow(wnr4); title('Restoration of Blurred Quantized Image (NSR = 0)');
subplot(529), imshow(wnr5); title('Restoration of Blurred Quantized Image (Estimated NSR)');
subplot(529), imshow(sharp_pic/70); title('sharpening');





