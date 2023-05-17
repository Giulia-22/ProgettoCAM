clear;
clc;
close all
set(0,'DefaultLineLineWidth',1.5);
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultFigureWindowStyle','docked');
set(0,'DefaultTextInterpreter','Latex');
rng('default');

%% 1. Parametri doppio serbatoio e setting simulazione

% Coefficiente di scarico
k = 0.05; 

% Livello iniziale acqua nei serbatoi
h1_ini = 0.7;
h2_ini = 0.6;

% Livello desiderato acqua nei serbatoi
h1_ref = 1;
h2_ref = 1.2;

% Riferimento ingresso
u1_ref = k*sqrt(h2_ref);
u2_ref = u1_ref;

% Vincoli ingresso
u1_min = 0;
u2_min = 0;
u1_max = 0.9;
u2_max = 0.9;

% Tempo di campionamento
Ts = 0.1; % [s]

% Tempo di simulazione
T_sim = 20; % [s]

model = 'mod1.slx';

%% 2. Creazione modello linearizzato
A = [0 0; 0 -k/(2*sqrt(h2_ref))];
B = [1 -1; 0 1];
C = eye(2);
D = zeros(2,2);

%% 3. Creazione fdt a t.c. e a t.d.
s = tf('s');
G_ct = C * (s * eye(2) - A) \ B;

G = c2d(G_ct, Ts); % di default usa Eulero in avanti

%% 4. Disaccoppiatore in avanti
M12 = -G(1,2)*G(2,2)^(-1);
M = [1 M12; 0 1];

%%  5a. Prima configurazione dei controllori

C1 = 1;
C2 = 1;

output_1 = sim(model);

figure
plot(output_1.h1_log,'DisplayName','$h_1$ [m]');
hold on
plot(output_1.h2_log,'DisplayName','$h_2$ [m]');
hold on
yline(h1_ref,'Label','$h_{1,\mathrm{ref}}$','HandleVisibility','off','interpreter','latex');
yline(h2_ref,'Label','$h_{2,\mathrm{ref}}$','HandleVisibility','off','interpreter','latex');
title('Livello acqua serbatoi');
grid on;
ylabel('Livello acqua [m]');
legend('Interpreter','latex');

figure
subplot(2,1,1);
plot(output_1.control1_log,'DisplayName','Computed control action','LineWidth',1.5);
hold on
plot(output_1.u1_log,'DisplayName','Control action','LineWidth',1.5);
title('Azione di controllo serbatoio 1');
ylabel('Input [m/s]');
grid on;
legend;
subplot(2,1,2);
plot(output_1.control2_log,'DisplayName','Computed control action','LineWidth',1.5);
hold on
plot(output_1.u2_log,'DisplayName','Control action','LineWidth',1.5);
title('Azione di controllo serbatoio 2');
ylabel('Input [m/s]');
grid on;
legend;

%%  5b. Seconda configurazione dei controllori

C1 = 5;
C2 = 1;

output_2 = sim(model);

figure
plot(output_2.h1_log,'DisplayName','$h_1$ [m]');
hold on
plot(output_2.h2_log,'DisplayName','$h_2$ [m]');
hold on;
yline(h1_ref,'Label','$h_{1,\mathrm{ref}}$','HandleVisibility','off','interpreter','latex');
yline(h2_ref,'Label','$h_{2,\mathrm{ref}}$','HandleVisibility','off','interpreter','latex');
grid on
ylabel('Livello acqua [m]');
title('Livello acqua serbatoi');
legend('Interpreter','latex');

figure
subplot(2,1,1);
plot(output_2.control1_log,'DisplayName','Computed control action','LineWidth',1.5);
hold on
plot(output_2.u1_log,'DisplayName','Control action','LineWidth',1.5);
title('Azione di controllo serbatoio 1');
ylabel('Input [m/s]');
grid on;
legend;
subplot(2,1,2);
plot(output_2.control2_log,'DisplayName','Computed control action','LineWidth',1.5);
hold on
plot(output_2.u2_log,'DisplayName','Control action','LineWidth',1.5);
title('Azione di controllo serbatoio 2');
ylabel('Input [m/s]');
grid on;
legend;