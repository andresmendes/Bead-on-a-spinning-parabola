%% Bead on a spinning parabola
% Simulation and animation of a bead on a spinning parabola for different angular velocities.
%
% Inspired by:
% https://www.reddit.com/r/Physics/comments/ojn0tp/phase_portraits_of_a_bead_on_a_spinning_parabola/
%
% Reference:
% https://gemelli.spacescience.org/~hahnjm/phy3405/2005fall/chap7.pdf
%
%%

clear ; close all ; clc

%% Parameters

% System
g = 9.81;       % Gravity [m/s2]
k = 1;

% Angular velocity
% Case 1
% w = 0; 
% r0 = 0.9;
% title_text = '$\omega=0 \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,$';
% video_name = 'bead_spinning1.mp4';

% Case 2
% w = 3;
% r0 = 0.9;
% title_text = '$0<\omega<\sqrt{2 g k} \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,$';
% video_name = 'bead_spinning2.mp4';

% Case 3
% w = sqrt(2*g*k);
% r0 = 0.8;
% title_text = '$\omega=\sqrt{2 g k} \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,$';
% video_name = 'bead_spinning3.mp4';

% Case 4
w = 1.07*sqrt(2*g*k);
r0 = 0.2;
title_text = '$\omega > \sqrt{2 g k} \,\,\,\,\,\,\,\,\,\,\,\,\,\,\,\,$';
video_name = 'bead_spinning4.mp4';

% Video
% Parameters
playback_speed = 0.1;           % Speed of playback
tf      = 2;                    % Final time                    [s]
fR      = 30/playback_speed;    % Frame rate                    [fps]
dt      = 1/fR;                 % Time resolution               [s]
time    = linspace(0,tf,tf*fR); % Time                          [s]

% Initial conditions
Z0 = [r0 0];

[TOUT,ZOUT] = ode45(@(t,z) bead_eom(t,z,k,w,g),time,Z0);

th = w*time; % Angular position parabolic wire [rad]

%% Results

figure
set(gcf,'Position',[50 50 1280 720]) % YouTube: 720p
% set(gcf,'Position',[50 50 854 480]) % YouTube: 480p
% set(gcf,'Position',[50 50 864 1080]) % Instagram

% Create and open video writer object
v = VideoWriter(video_name,'MPEG-4');
v.Quality = 100;
open(v);

for i=1:length(time)
    % Updating wire
    r_max = 1;
    r_wire = linspace(-r_max,r_max,length(TOUT));
    x_wire = r_wire.*cos(th(i));
    y_wire = r_wire.*sin(th(i));
    z_wire = k*r_wire.^2;

    % Updating bead
    r = ZOUT(:,1);
    x = r.*cos(th(i));
    y = r.*sin(th(i));
    z = k*r.^2;

    % Animation
    subplot(2,3,[1 2 4 5])
        cla
        hold on ; grid on ; box on ; axis equal
        set(gca,'XLim',[-r_max r_max],'YLim',[-r_max r_max],'ZLim',[0 r_max])
        set(gca,'CameraPosition',[9.1389  -11.0879    4.8058])
        plot3(0,0,0,'LineStyle','none'); % Dummy for legend
        plot3(x_wire,y_wire,z_wire,'k')
        plot3([0 0],[0 0],[0 1],'k:')
        plot3(x(i),y(i),z(i),'bo','MarkerFaceColor','b','MarkerSize',10)
        xlabel('x')
        ylabel('y')
        zlabel('z')
        title(strcat('Wire: z=kr^2 ; Angular velocity: \omega ; Time=',num2str(time(i),'%.3f'),' s (Playback speed=',num2str(playback_speed),')'))
        legend(title_text,'Location','SouthOutside','Interpreter','latex','FontSize',12)
    subplot(2,3,3)
        cla
        hold on ; grid on ; box on ; axis equal
        set(gca,'XLim',[-r_max r_max],'YLim',[0 r_max])
        plot(x_wire,z_wire,'k')
        plot([0 0],[0 1],'k:')
        plot(x(i),z(i),'bo','MarkerFaceColor','b','MarkerSize',10)
        xlabel('x')
        ylabel('z')
    subplot(2,3,6)
        cla
        hold on ; grid on ; box on ; axis equal
        set(gca,'XLim',[-r_max r_max],'YLim',[-r_max r_max])
        plot(x_wire,y_wire,'k')
        plot([0 0],[0 0],'k:')
        plot(x(i),y(i),'bo','MarkerFaceColor','b','MarkerSize',10)
        xlabel('x')
        ylabel('y')
    
    frame = getframe(gcf);
    writeVideo(v,frame);

end
    
close(v);

%% Auxiliary function

function dz = bead_eom(~,z,k,w,g)
    % States
    r   = z(1);
    dr  = z(2);
    % State equations
    dz(1,1) = dr;
    dz(2,1) = (r*w^2 - 2*g*k*r - 4*k^2*r*dr^2)/(1+4*k^2*r^2);
end