function [X_f] = filtrage_spectral(X, A)
// A varie entre 0 et 1. 1 correspond au % des frequences filtrŽes.
// 0 correspond donc a aucun filtrage.
xrec=X;

//check
if length(X)/2<>round(length(X)/2) then
    X=[X;X($)];
end

// transformation directe
TFX = fft(X)


//on remet le signal pour que les plus basses frŽquences soient au milieu
FFT=zeros(TFX)
FFT(1:$/2)=TFX($/2+1:$)
FFT($/2+1:$)=TFX(1:$/2)



larg=round(A*length(X)/2);
larg=length(X)/2-larg;


//une gaussienne
gauss=zeros(TFX);
absc=[1:length(gauss)];


STDEV=larg/2;
MU=length(gauss)/2+1;
gauss=exp(-((absc-MU)/(sqrt(2)*STDEV)).^2)';


//On multiplie la fft par la gaussienne
FFT_gauss=FFT.*gauss;


//On remet a l'endroit le spectre
TF_gauss=zeros(FFT_gauss)
TF_gauss(1:$/2)=FFT_gauss($/2+1:$)
TF_gauss($/2+1:$)=FFT_gauss(1:$/2)


//On fait la transformation inverse
X_f=ifft(TF_gauss)


//
X_f=X_f(1:length(xrec));

endfunction




