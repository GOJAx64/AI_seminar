clear all
close all
clc

%PARTE 1
data = readtable('data_lineal_1.csv'); % 1, 2, 3
X = data.x;
Y = data.y;
n = size(X,1);
X = [ones(n,1) X];
xl = [-10; -10];
xu = [10; 10];
D = 2;

%PARTE 2 Y 3 - DESCOMENTAR SECCION EN CADA ARCHIVO
% data = readtable('FishLength.csv');
% X1 = data.Age;
% X2 = data.WaterTemperature;
% Y = data.Length;
% n = size(Y,1);
% X = [ones(n,1) X1 X2];
% xl = [-10; -10; -10];
% xu = [10; 10; 10];
% D = 3;

% data = readtable('Salary.csv');
% X = data.YearsExperience;
% Y = data.Salary;
% n = size(Y,1);
% X = [ones(n,1) X];
% xl = [-10; -10];
% xu = [10; 10];
% D = 2;

% data = readtable('SellingPrice.csv');
% Data = data.Variables;
% X = Data(:,1:10);
% Y = Data(:,11);
% n = size(X,1);
% X = [ones(n,1) X];
% xl = -10*ones(11,1);
% xu = 10*ones(11,1);
% D = 11;


f = @(w) (1/(2*n))*sum((Y-(X*w)).^2);

G = 150;
N = 50;

F = 0.6; % o 1.2
CR = 0.9; % o 0.6

x = zeros(D,N);
fit = zeros(1,N);

for i=1:N
    x(:,i) = xl + (xu-xl).*rand(D,1);
    fit(i) = f(x(:,i));
end

for n=1:G
    for i=1:N
        %mutación
        r1 = i;
        while r1 == i
            r1 = randi([1,N]);
        end
        
        r2 = r1;
        while r2==r1 || r2==i
            r2 = randi([1,N]);
        end
    
        r3 = r2;
        while r3==r2 || r3==r1 || r3==i
            r3 = randi([1,N]);
        end

        v = x(:,r1) + F*(x(:,r2)-x(:,r3));

        %Recombinación
        u = zeros(D,1);

        for j=1:D
            r = rand;
            if r<=CR
                u(j) = v(j);
            else
                u(j) = x(j,i);
            end
        end

        %Selección
        fit_u = f(u);

        if fit_u < fit(i)
            x(:,i) = u;
            fit(i) = fit_u;
        end
    end
end

[~,igb] = min(fit);

w = x(:,igb);
disp([' Coeficientes: w = [' num2str(w') ']'])
disp(['f(w) = ' num2str(f(w))])

Yp = X*w;
R2 = 1 - sum((Y-Yp).^2)/sum((Y-mean(Y)).^2);
disp([' R2 score = ' num2str(R2)])

% PARTE 3 Predicciones 
% Descomentar la misma seccion que el archivo que se lee
%FishLength
% y = [1 101 26]*w;
% disp(['Longitud de un pez de 101 días con 26 grados = ' num2str(y)])
% y = [1 100 25]*w;
% disp(['Longitud de un pez de 111 días con 26 grados = ' num2str(y)])

%Salary
% y = [1 15]*w;
% disp(['Salario a los 15 años = ' num2str(y)])
% y = [1 25]*w;
% disp(['Salario a los 25 años = ' num2str(y)])

%SellingPrice
% y = [1 2 7 1.5 2 4 4 30 3 1 1]*w;
% disp('Precio estimado de casa con 2 baños, area de 7 y espacio vital de 1.5, ') 
% disp('2 cocheras, 4 habitaciones, 4 dormitorios con 30 y 3 años de edad')
% disp([' y construcción respectivamente, arquitectura tipo 1 y 1 chimenea= ' num2str(y)])

%return 

figure
hold on
grid on
plot(X(:,2),Y,'bo','LineWidth',2,'MarkerSize',10)
plot(X(:,2),Yp,'g-','LineWidth',3,'MarkerSize',10)
xlabel('x','FontSize',13)
ylabel('y','FontSize',13)
legend({'Muestras','Regresion'},'FontSize',13)
