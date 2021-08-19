function hybridModesCircularTest
clc

width = 4;
height = 1;

mMax = 20;
nMax = 20;

freqMHz = 4000;
sigma = 0.01;
erH = 10;
erV = 10;
hRMS = 0.1; %RMS
thetaRadRMS = deg2rad(.1);

x0 = -1.4;
y0 = 1.4; 
rxHeight = 1.4;

distance = 1000;

%------------------------------------------------------------------------

lambda = 300/freqMHz;
k = 2*pi/lambda;

kH = (erH - 1i*sigma);
kV = (erV - 1i*sigma);

a = width/2;
b = height/2;

noOfXPoints = 21;
noOfYPoints = 1;
noOfZPoints = 201;

x = linspace(-a, a, noOfXPoints);
y = linspace(rxHeight, rxHeight, noOfYPoints);
z = linspace(1, distance, noOfZPoints);

E = zeros (noOfYPoints, noOfXPoints, noOfZPoints);
[X, Y, Z] = meshgrid (x, y, z);


for m = 1:mMax
  for n = 1:nMax
    phiA = pi/2;
    if (rem(m, 2) == 0)
      phiA = 0;
    end

    phiB = 0;
    if (rem(n, 2) == 0)
      phiB = pi/2;
    end

   
    if ((k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2) > 0)
      eMNV = sin(m*pi/2/a .* Y + phiA) .* cos(n*pi/2/b .* X + phiB);
      eMNH = sin(m*pi/2/a .* X + phiA) .* cos(n*pi/2/b .* Y + phiB);

      betaMN = sqrt(k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2);

      alphaMNV = 1/2/a * (m*pi/2/a/k)^2 * (real(1/sqrt(kV-1))) + 1/2/b * (n*pi/2/b/k)^2 * (real(kH/sqrt(kH-1)));
      alphaMNH = 1/2/a * (m*pi/2/a/k)^2 * (real(kV/sqrt(kV-1))) + 1/2/b * (n*pi/2/b/k)^2 * (real(1/sqrt(kH-1)));

      alphaL = pi^2 * hRMS^2 * lambda * (1/(2*a)^4 + 1/(2*b)^4);
      alphaT = pi^2 * thetaRadRMS^2 / lambda;

      CMNV = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* sin(m*pi/2/a .* y0 + phiA) .* cos(n*pi/2/b .* x0 + phiB);
      CMNH = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* sin(m*pi/2/a .* x0 + phiA) .* cos(n*pi/2/b .* y0 + phiB);

      alphaV = alphaMNV + alphaL + alphaT;
      alphaH = alphaMNH + alphaL + alphaT;

      beta = betaMN;


      decayV = exp(-(alphaV + 1i*beta).*Z);
      decayH = exp(-(alphaH + 1i*beta).*Z);

      Ey = CMNV .* eMNV .* decayV;
      Ex = CMNH .* eMNH .* decayH;

      E = E + (Ex + 1i*Ey);

    end  
  end
end

E = E/max(max(E));
figure (2)
h = surf (squeeze(X), squeeze(Z), 10*log10(squeeze(abs(E))));
set (h, 'meshstyle', 'row');
axis ([-2 2 0 distance -60 0])

max(max(abs(E(:,:,1))))
