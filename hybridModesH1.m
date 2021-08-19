function hybridModesH1
clc

m = 1;
n = 1;


width = 4;
height = 2;

freqMHz = 2000;
lambda = 300/freqMHz;
k = 2*pi/lambda;
sigma = 0.01;
erH = 10;
erV = 10;
hRMS = 0.1; %RMS
thetaRadRMS = deg2rad(0);

a = width/2;
b = height/2;

x0 = 0;
y0 = 0;

kH = (erH - 1i*sigma);
kV = (erV - 1i*sigma);

x = linspace(-a, a, 205);
y = linspace(-b, b, 205);
z = linspace(300, 300, 1);

[X, Y, Z] = meshgrid (x, y, z);

phiA = pi/2;
if (rem(m, 2) == 0)
  phiA = 0;
end

phiB = 0;
if (rem(n, 2) == 0)
  phiB = pi/2;
end

%term1 = (cos((ta + phix) - sin(2i/(k*a*sqrt(epsa-1)) * ta)).*sin(ta + phix));
%term2 = (sin((tb + phiy) - sin(2i*epsb/(k*b*sqrt(epsb-1)) * tb)).*cos(tb + phiy));


eMNH = sin(m*pi/2/a .* X + phiA) .* cos(n*pi/2/b .* Y + phiB);


%betamn = k*(1 - 0.5*(m*lambda/2/a)^2 - 0.5*(n*lambda/2/b)^2);
%term1 = 2/a * (m*lambda/2/a)^2 * (real(1/sqrt(epsa-1))); 
%term2 = 2/b * (n*lambda/2/b)^2 * (real(epsb/sqrt(epsb-1)));

betaMN = sqrt(k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2);
alphaMNH = 1/2/a * (m*pi/2/a/k)^2 * (real(kV/sqrt(kV-1))) + 1/b/2 * (n*lambda/2/b)^2 * (real(1/sqrt(kH-1)));
alphaL = pi^2 * hRMS^2 * lambda * (1/(2*a)^4 + 1/(2*b)^4);
alphaT = pi^2 * thetaRadRMS^2 / lambda;
CMNH = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* sin(m*pi/2/a .* x0 + phiA) .* cos(n*pi/2/b .* y0 + phiB);

alphaH = alphaMNH + alphaL + alphaT;
beta = betaMN;


% zz = 10:0.1:40;
% wallLoss = 10*log10(exp(-alphaL.*zz));
% refLoss = 10*log10(exp(-alphaMNH.*zz));
% tiltLoss = 10*log10(exp(-alphaT.*zz));
% gammaLoss = 10*log10(exp(-alphaH.*zz));
% 
% figure(2)
% hold off;
% plot (zz, wallLoss);
% hold on;
% plot (zz, refLoss, 'r');
% plot (zz, tiltLoss, 'g');
% plot (zz, gammaLoss, 'k');
% 
% line ([30.48 30.48], [0, min(gammaLoss)]);
% grid on;

decayH = exp(-(alphaH + 1i*beta).*Z);

Ex = CMNH .* eMNH .* decayH;

%surf (X(:,:,1), Y(:,:,1), Z(:,:,1), abs(E11(:,:,1)));
%view (2)
figure (1)
surf (X(:,:,1), Y(:,:,1), abs(Ex(:,:,1)));
view(2)

max(max(abs(Ex(:,:,1))))
