% Multichannel slotted ALOHA
% Bariq Firmansyah, 2020

clear all; close all; clc;
k=1;
for NumberofChannel=[5, 10]
    i=1;
    for NumberofUser=[10, 50]
        j=1;
        for lambda=[0:0.2:15]
            simulationTime=1e5;
            userStatus = zeros(1,NumberofUser);
            % 0: idle source
            % 1: active
            attemptUser = zeros(1, NumberofChannel);
            pcktTransmissionAttempts = 0;
            ackdPacketCount = 0;
            pcktCollisionCount = 0;
            currentSlot = 0;
            pr=lambda/NumberofUser;
            
            while currentSlot < simulationTime
                currentSlot = currentSlot + 1;
                transmissionAttemptsEachSlot = zeros(1, NumberofChannel);
                for user = 1:NumberofUser
                    if rand(1) <= pr
                        channelChoosen=randi(NumberofChannel,1);
                        transmissionAttemptsEachSlot(channelChoosen) = transmissionAttemptsEachSlot(channelChoosen)+1;
                        pcktTransmissionAttempts = pcktTransmissionAttempts+1;
                        attemptUser(channelChoosen) = user;
                    end                    
                end
                
                for channel=1:NumberofChannel
                    if transmissionAttemptsEachSlot(channel) == 1
                        ackdPacketCount = ackdPacketCount + 1;
                        userStatus(attemptUser(channel)) = 0;
                    elseif transmissionAttemptsEachSlot(channel)>1
                        pcktCollisionCount = pcktCollisionCount+1;
                    end
                end
            end
            
            trafficOffered(i,j,k) = pcktTransmissionAttempts / currentSlot;
            throughput(i,j,k) = ackdPacketCount / (currentSlot);
            pcktCollisionProb(i,j,k) = pcktCollisionCount / (currentSlot);
            j=j+1;
        end
        i=i+1
    end
    k=k+1
end

%% plot
figure(1)
plot(trafficOffered(1,:,1),throughput(1,:,1), '-x')
title('Average Throughput of Finite-Station Multichannel Slotted ALOHA')
xlabel('G (Offered Traffic)')
ylabel('Average Throughput')
hold on;
G=[0:0.2:15];
S=G.*(1-G/(10*5)).^(10-1);
plot(G,S);
hold on;
plot(trafficOffered(2,:,1),throughput(2,:,1), '-o')
hold on;
S=G.*(1-G/(50*5)).^(50-1);
plot(G,S);
hold on;
plot(trafficOffered(1,:,2),throughput(1,:,2), '-d')
hold on;
S=G.*(1-G/(10*10)).^(10-1);
plot(G,S);
hold on;
plot(trafficOffered(2,:,2),throughput(2,:,2), '-*')
hold on;
S=G.*(1-G/(50*10)).^(50-1);
plot(G,S);
legend('simulation, M=10 N=5', 'analytical, M=10 N=5','simulation, M=50 N=5', 'analytical, M=50 N=5', 'simulation, M=10 N=10', 'analytical, M=10 N=10', 'simulation, M=50 N=10', 'analytical, M=50 N=10');
grid on

figure(2)
plot(trafficOffered(1,:,1),pcktCollisionProb(1,:,1)/5, '-x')
title('Collision Probability of Finite-Station Slotted ALOHA')
xlabel('G (Offered Traffic)')
ylabel('Collision Prob')
hold on;
S=1-(1-G/(10*5)).^(10)-(G/5).*(1-G/(10*5)).^(10-1);
plot(G,S);
hold on;
plot(trafficOffered(2,:,1),pcktCollisionProb(2,:,1)/5, '-o')
hold on;
S=1-(1-G/(50*5)).^(50)-(G/5).*(1-G/(50*5)).^(50-1);
plot(G,S);
hold on;
plot(trafficOffered(1,:,2),pcktCollisionProb(1,:,2)/10, '-d')
hold on;
S=1-(1-G/(10*10)).^(10)-(G/10).*(1-G/(10*10)).^(10-1);
plot(G,S);
hold on;
plot(trafficOffered(2,:,2),pcktCollisionProb(2,:,2)/10, '-*')
hold on;
S=1-(1-G/(50*10)).^(50)-(G/10).*(1-G/(50*10)).^(50-1);
plot(G,S);
legend('simulation, M=10 N=5', 'analytical, M=10 N=5','simulation, M=50 N=5', 'analytical, M=50 N=5', 'simulation, M=10 N=10', 'analytical, M=10 N=10', 'simulation, M=50 N=10', 'analytical, M=50 N=10');
grid on
