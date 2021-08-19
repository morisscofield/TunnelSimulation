function hybridModesV1
clc

m = 1;
n = 1;


width = 4.267;
height = 2.134;

freqMHz = 500;
omega = 2*pi*freqMHz*1E6;
lambda = 300/freqMHz;
k = 2*pi/lambda;
sigma = 0.01;
eps0 = 8.85E-12;
erH = 10;
erV = 10;
hRMS = 0.1; %RMS
thetaRadRMS = deg2rad(1);

a = width/2;
b = height/2;

x0 = 0;
y0 = 0;

kH = (erH - 1i*sigma);
kV = (erV - 1i*sigma);

x = linspace(-a, a, 205);
y = linspace(-b, b, 205);
z = linspace(30, 30, 1);

[X, Y, Z] = meshgrid (x, y, z);

phiA = pi/2;
if (rem(m, 2) == 0)
  phiA = 0;
end

phiB = 0;
if (rem(n, 2) == 0)
  phiB = pi/2;
end

eMNV = sin(m*pi/2/a .* Y + phiA) .* cos(n*pi/2/b .* X + phiB);

betaMN = sqrt(k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2);
alphaMNV = 1/2/a * (m*pi/2/a/k)^2 * (real(1/sqrt(kV-1))) + 1/b/2 * (n*lambda/2/b)^2 * (real(kH/sqrt(kH-1)));

alphaL = pi^2 * hRMS^2 * lambda * (1/(2*a)^4 + 1/(2*b)^4);
alphaT = pi^2 * thetaRadRMS^2 / lambda;

CMNV = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* sin(m*pi/2/a .* y0 + phiA) .* cos(n*pi/2/b .* x0 + phiB);

alphaV = alphaMNV + alphaL + alphaT;
beta = betaMN;


zz = 10:0.1:40;
wallLoss = 10*log10(exp(-alphaL.*zz));
refLoss = 10*log10(exp(-alphaMNV.*zz));
tiltLoss = 10*log10(exp(-alphaT.*zz));
gammaLoss = 10*log10(exp(-alphaV.*zz));

figure(3)
hold off;
plot (zz, wallLoss);
hold on;
plot (zz, refLoss, 'r');
plot (zz, tiltLoss, 'g');
plot (zz, gammaLoss, 'k');

line ([30.48 30.48], [0, min(gammaLoss)]);
title ('V mode')
grid on;

decayV = exp(-(alphaV + 1i*beta).*Z);

Ey = CMNV .* eMNV .* decayV;

%surf (X(:,:,1), Y(:,:,1), Z(:,:,1), abs(E11(:,:,1)));
%view (2)
figure (1)
surf (X(:,:,1), Y(:,:,1), abs(Ey(:,:,1)));
view(2)

max(max(abs(Ey(:,:,1))))
