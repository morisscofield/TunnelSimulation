function hybridModes
clc

a = 3; %width
b = 2; %height

freqMHz = 1250;
omega = 2*pi*freqMHz*1E6;
lambda = 300/freqMHz;
sigma = 0.01E8;
e0 = 8.85E-12;
ev = 5;
eh = 5;
ea = 1;

kv = e0*ev + sigma/(1i*2*pi*freqMHz*1E6);
kh = e0*eh + sigma/(1i*2*pi*freqMHz*1E6);
ka = e0*ea;

k = 2*pi/lambda;
kvn = kv/k;
khn = kh/k;

m = 1;
n = 0;

x = linspace(-a, a, 205);
y = linspace(-b, b, 205);
z = linspace(0, 1, 205);

[X, Y, Z] = meshgrid (x, y, z);

phix = pi/2;
if (rem(m, 2) == 0)
  phix = 0;
end

phiy = 0;
if (rem(n, 2) == 0)
  phiy = pi/2;
end

term1 = sin(m*pi/2/a .* X + phix);
term2 = cos(n*pi/2/b .* Y + phiy);

Emn = term1.*term2;

betamn = sqrt(k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2);

term1 = 1/a * (m*pi/2/a/k)^2 * real((kvn/sqrt(kvn-1)));
term2 = 1/b * (n*pi/2/b/k)^2 * real((1/sqrt(khn-1)));
alphamn = term1 * term2;

decay = exp(-(alphamn + 1i*betamn).*Z);

E11 = Emn.*decay;

%surf (squeeze(X(:,:,:)), squeeze(Y(:,:,:)), squeeze(Z(:,:,:)), squeeze(abs(E11(:,:,:))));
surf (squeeze(X(:,:,1)), squeeze(Y(:,:,1)), squeeze(Z(:,:,1)), squeeze(abs(E11(:,:,1))));
view (2)
%surf (squeeze(X(:,100,:)), squeeze(Y(:,100,:)), squeeze(Z(:,100,:)), squeeze(real(E11(:,100,:))));
%view (90,0)

%figure
%surf (squeeze(X(:,100,:)), squeeze(Y(:,100,:)), squeeze(Z(:,100,:)), squeeze(abs(decay(:,100,:))));
%title ('decay')
%view (90,0)

