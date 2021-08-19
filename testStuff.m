function testStuff



width = 3;
height = 3;

freqMHz = 1000;
lambda = 300/freqMHz;
k = 2*pi/lambda;

a = width/2;
b = height/2;

m = 4;
n = 4;

m = linspace(1, 13, 101);
n = linspace(1, 13, 101);
z = linspace(0, 0, 1);

[m, n, z0] = meshgrid (m, n, z);


gammaMN = pi./(a*b*sqrt(1-(m.*pi./2./a./k).^2 - (n.*pi./2./b./k).^2));

figure (1)
surf (m(:,:,1), n(:,:,1), abs(gammaMN(:,:,1)));
xlabel ('m m m m');
ylabel('n n n ');


max(max((gammaMN)))

