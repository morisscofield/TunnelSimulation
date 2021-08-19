function InitCond

clc

m = 4;
n = 2;

width = 4.267;
height = 2.134;

freqMHz = 1000;
lambda = 300/freqMHz;
k = 2*pi/lambda;

a = width/2;
b = height/2;

phix = pi/2;
if (rem(m, 2) == 0)
  phix = 0;
end

phiy = 0;
if (rem(n, 2) == 0)
  phiy = pi/2;
end

x = linspace(-a, a, 205);
y = linspace(-b, b, 205);
z = linspace(30, 30, 1);

[x0, y0, z0] = meshgrid (x, y, z);


eMN = sin(m*pi/2/a .* x0 + phix) .* cos(n*pi/2/b .* y0 + phiy);

gammaMN = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* eMN;
%gammaMN = cos((n*pi/2/b).*y0 + phiy);

figure (2)
surf (x0(:,:,1), y0(:,:,1), (gammaMN(:,:,1)));

sum(sum(gammaMN))

