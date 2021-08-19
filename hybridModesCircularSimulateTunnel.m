function hybridModesCircularSimulateTunnel
clc

width = 4;
height = 3;

mMax = 20;
nMax = 20;

freqMHz = 10000;
sigma = 0.01;
erH = 10;
erV = 10;
hRMS = 0.1; %RMS
thetaRadRMS = deg2rad(.1);

x0 = 0;
y0 = 0; 
rxHeight = 0;

distance = 1000;

%------------------------------------------------------------------------

lambda = 300/freqMHz;
k = 2*pi/lambda;

kH = (erH - 1i*sigma);
kV = (erV - 1i*sigma);

a = width/2;
b = height/2;

noOfXPoints = 1;
noOfYPoints = 1;
noOfZPoints = 201;

x = linspace(-a, a, noOfXPoints);
%y = linspace(rxHeight, rxHeight, noOfYPoints);
y = linspace(-b, b, noOfYPoints);
z = linspace(5, 5000, noOfZPoints);

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
      
      if ((m==1) && (n==1))
        scale = max(max(max(CMNV .* eMNV, CMNH .* eMNH)));
      end

      E = E + (Ex + 1i*Ey);

    end  
  end
end

%E = E/max(max(max(E)));
%E = E/scale;
figure (2)
%h = surf (squeeze(X(1,:,:)), squeeze(Z(1,:,:)), 10*log10(squeeze(abs(E(1,:,:)))));
%h = surf (squeeze(X(:,:,1)), squeeze(Y(:,:,1)), 10*log10(squeeze(abs(E(:,:,1)))));
plot(squeeze(Z), 10*log10(squeeze(abs(E))));
%set (h, 'facecolor', 'interp', 'EdgeColor', 'none', 'FaceLighting', 'phong', 'EdgeLighting', 'none');
%set (h, 'facecolor', 'flat', 'EdgeColor', 'none', 'FaceLighting', 'phong', 'EdgeLighting', 'none');


%set (h, 'meshstyle', 'row');
%axis ([-2 2 0 distance -60 0])

max(max(abs(E(:,:,1))))
