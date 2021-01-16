% Infinite User Multichannel slotted ALOHA -- Modeled using poissong random
% generator
% Bariq Firmansyah, 2020

clear all;close all; clc;

i=1;
for channel=[5,10]
T = 1e5; % simulation time
load_scale = 0.2; % step size
G = 0:load_scale:18; % this is the offered load
requests = zeros(T+1, channel, length(G)); % create 3D matrix with size = [simulation time, channel, offered load)
slotted_ALOHA_success = zeros(1,length(G));
slotted_ALOHA_collision = zeros(1,length(G));

for g = 1:length(G) % iterate at each offered load
    request_at_instant_G = poissrnd(G(g),T+1,1); % the number of requests at an instant offered load at all time
    for t=1:T+1 % iterate at each time
        % in this part, we'll assign all requests at each instant time into
        % a random channel
        for n=1:request_at_instant_G(t) % iterate at the requests
            selected_channel=randi(channel);
            requests(t, selected_channel,g)=1+requests(t, selected_channel, g);
        end
    end
end
for g = 1:length(G)
    for t = 1:T       
        for c=1:channel
            if requests(t,c, g) == 1
                slotted_ALOHA_success(g) = slotted_ALOHA_success(g) + 1;
            end
             if requests(t,c, g) > 1
                slotted_ALOHA_collision(g) = slotted_ALOHA_collision(g) + 1;
            end
        end
    end
end
S_slotted_ALOHA(i,:) = slotted_ALOHA_success / T;
Col_slotted_ALOHA(i,:) = slotted_ALOHA_collision / T;
i=i+1
end
%% calculate
%% plot
% multichannel slotted
figure(1)
plot(G,S_slotted_ALOHA(1,:), '-x')
title('Average Throughput of Multichannel Slotted ALOHA')
xlabel('G (Offered load)')
ylabel('Average Throughput')
hold on;
S=G.*exp(-G/5);
plot(G,S);
hold on;
plot(G,S_slotted_ALOHA(2,:), '-d')
hold on;
S=G.*exp(-G/10);
plot(G,S);
legend('simulation N=5', 'analytical N=5', 'simulation N=10', 'analytical N=10');
grid on

figure(2)
plot(G,Col_slotted_ALOHA(1,:)/5, '-s')
title('Collision Probability of Multichannel Slotted ALOHA')
xlabel('G (Offered load)')
ylabel('Collision Probability')
hold on;
S=1-exp(-G/5)-(G/5).*exp(-G/5);
plot(G,S);
hold on;
plot(G,Col_slotted_ALOHA(2,:)/10, '-*')
hold on;
S=1-exp(-G/10)-(G/10).*exp(-G/10);
plot(G,S);
legend('simulation N=5', 'analytical N=5', 'simulation N=10', 'analytical N=10');
grid on
