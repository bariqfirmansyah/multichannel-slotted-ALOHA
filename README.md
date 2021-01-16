# multichannel-slotted-ALOHA
read here for the better writing: https://hackmd.io/@bariqsufif/multichannelslotted
## Background
::: spoiler Click to view the background knowledge of **Single-Channel Slotted ALOHA**, you can skip this if you already understand
---
https://hackmd.io/@bariqsufif/slotted
:::
___
![](https://i.imgur.com/8xxtqfS.png)
*Fig.1 Multichannel Slotted ALOHA system model*

The system consists of a finite population of $M$ users sharing $C$ parallel channels with equal probability $1\over C$. Users can transmit to or receive from any of $C$ channels **according** to the **slotted ALOHA protocol**. 

The time axis is slotted into segments of equal length seconds corresponding to the transmission time of a packet. All users are synchronized and all packet transmissions over the chosen channel are started only at the beginning of a time slot. If two or more packets are simultaneously transmitted over the same channel at the same slot, a collision of the packets occurs. 

It is assumed that the user will know about his success or collision immediately after the transmission. The users whose transmissions are unsuccessful retransmit their packets in future time slots.

An expression for $S$ in terms of $G$ is required. This will be derived for an **infinite** population and a **finite** population of stations.
#### Infinite population case
The throughput per channel of multichannel slotted ALOHA is the following
$$S_c={G\over C}e^{-G\over C}$$
Compare it with single-channel slotted ALOHA, which throughput is $S={G}e^{-G}$. The offered load in single-channel slotted ALOHA is $G$, whereas the offered load per channel in multichannel slotted ALOHA is $G\over C$, this is due to the packet rate in each channel is $1\over C$ times the packet rate of all channels combined.

As there are C channels, the total throughput of Multichannel Slotted ALOHA is C times throughput of its individual channel
$$S=CS_c=Ge^{-G\over C}$$
if $C=1$, the equation above becomes $S=Ge^{-G}$, the throughput equation of single channel slotted ALOHA

Collision will occur if two or more packets are simultaneously transmitted over the same channel at the same slot.

The probability that no packet is transmitted over a channel is $$Pr[no\ packet\ transmitted\ in\ channel\ c]=e^{-G/C}$$
The probability that only one packet is transmitted over a channel is $S_c$. Therefore the collision probability is
$$Pr[>1\ packet\ transmitted\ in\ channel\ c]=1-Pr[no\ packet\ transmitted\ in\ channel\ c]-S_c$$
$$=1-e^{-G/C}-{G\over C}e^{-G\over C}$$

#### Finite population case
Similarly, for  finite-station case, the throughput per channel is the following
$$S_c = {G\over C}(1 − {G\over MC})^{M−1}$$
As there are C channels, the total throughput of Multichannel Slotted ALOHA is C times throughput of its individual channel
$$S=CS_c = G(1 − {G\over MC})^{M−1}$$
Similarly, for finite-station case, the collision probability is the following
$$Pr[>1\ packet\ transmitted\ in\ channel\ c]=1-Pr[no\ packet\ transmitted\ in\ channel\ c]-S_c$$
$$=1-(1 − {G\over MC})^{M}-{G\over C}(1 − {G\over MC})^{M−1}$$

## System Model
#### Scenario 1: Infinite-Station
| I/P Parameters    | Value |  
| ----------------- | ------|
|$C$: # of Channels       | $5, 10$  | 
|$M$: # of STAs       | $M\to\infty$  | 
|$T$: # of access cycles| $10^6$  |
|$\lambda$: packet rate| $[0:0.2:18]$  |

#### Variable Data structure
| Variable | Meaning  | Data Type| range   |
| -------- | -------- | -------- |-------- |
| $R$               | random number generated from poisson distribution with mean $\lambda$, represents the number of packets being sent in that timeslot | Integer   | $0$~$\infty$                                     |
| $r$               | packet ID. After R packets is generated during specific timeslot, each packet has packet ID                                         | Integer   | $1$~$R$                                  |
| $c$               | channel ID  | Integer   | $1$~$C$ |
| $R_c$               |The number of packets being sent in channel c  | Vector of Integer, $vector \ size=(1, C)$  | $1$~$R$ in each element (channel)|
| $t$               | Access Cycle (Timeslot) ID  | Integer   | $1$~$T$   |
| $success\_pckt$   | the number of successful transmission | Integer   | $0$ ~ $\infty$ |
| $collision\_pckt$ | the number of failed transmission                                                                                                   | Integer   | $0$ ~ $\infty$ |

#### Output Data structure
| O/P | Meaning  | Data Type| range   |
| -------- | -------- | -------- |-------- |
| $throughput$ | $success\_pckt\over T$ for each $\lambda$| Vector of Float | $vector\ size=(1, length(\lambda)$, each element has range $0$~$1$ |
| $collision\_prob$ | $collision\_pckt\over T$ for each $\lambda$| Vector of Float | $vector\ size=(1, length(\lambda)$, each element has range $0$~$1$ |

#### Flow Chart
```flow
st=>start: Start
e=>end: End
op0=>operation: C=5
op=>operation: lambda=0
op1=>operation: success_pckt=0, 
collision_pckt=0
op2=>operation: t=1
op3=>operation: Generate random number from
poisson distribution with 
mean=lambda, assign to R
op3_1=>operation: r=1
op3_12=>operation: Rc(1)=0, 
Rc(2)=0, 
..., 
Rc(C)=0
op3_2=>operation: send packet r into 
one of C channels, 
choose channel c randomly
op3_21=>operation: increment Rc(C)
op3_3=>operation: increment r
op3_4=>operation: c=1
op3_5=>operation: Collision detected, 
increment collision_pckt
op4=>operation: packet successfully 
transmitted, 
increment success_pckt
op4_1=>operation: increment c
op5=>operation: increment t
op6=>operation: calculate throughput 
and collision_prob
for this lambda
op7=>operation: increment 
lambda 
by 0.2
op8=>operation: plot Y:throughput, 
X:lambda and plot
Y: collision prob,
X:lambda
op9=>operation: set C=10
cond0=>condition: is R>0?
cond0_1=>condition: is r=R?
cond=>condition: is Rc(c)=1?
cond_1=>condition: is c=C?
cond1=>condition: is Rc(c)>1?
cond2=>condition: is t=T?
cond3=>condition: is lambda=18?
cond4=>condition: is C=10?

st->op0->op->op1->op2->op3->cond0
cond0(yes)->op3_1->op3_12->op3_2->op3_21->cond0_1
cond0(no)->cond2
cond0_1(no)->op3_3->op3_2
cond0_1(yes)->op3_4->cond
cond(yes)->op4->cond_1
cond(no)->cond1
cond_1(no)->op4_1->cond

cond1(yes)->op3_5->cond_1
cond1(no)->cond_1
cond_1(yes)->cond2
cond2(yes)->op6->cond3
cond2(no)->op5->op3
cond3(no)->op7->op1
cond3(yes)->op8->cond4
cond4(no)->op9->op
cond4(yes)->e
```
#### Scenario 2: Finite-Station
| I/P Parameters    | Value |  
| ----------------- | ------|
|$C$: # of Channels       | $5, 10$  |
|$M$: # of STAs       | $10, 50$  | 
|$T$: # of access cycles| $10^5$  |
|$\lambda$: packet rate| $[0:0.2:15]$  |

#### Variable Data structure
| Variable | Meaning  | Data Type| range   |
| -------- | -------- | -------- |-------- |
|    $G_i$     | probability of station $i$ attempting transmission  | Float  | $0$~$1$    |
|    $P_r$     | Random number generated from uniform distribution  | Float  | $0$~$1$   |
|    $m$     | Station ID  | Integer  | $1$~$M$    |
| $c$               | channel ID  | Integer   | $1$~$C$ |
| $R_c$               |The number of packets being sent in channel c  | Vector of Integer, $vector \ size=(1, C)$  | $1$~$M$ in each element (channel)|
| $t$               | Access Cycle (Timeslot) ID  | Integer   | $1$~$T$   |
|$success\_pckt$ | the number of successful transmission | Integer  |$0$ ~ $\infty$ |
|$collision\_pckt$ | the number of failed transmission | Integer  |$0$ ~ $\infty$ |

#### Output Data structure
| O/P | Meaning  | Data Type| range   |
| -------- | -------- | -------- |-------- |
| $throughput$ | $success\_pckt\over T$ for each $\lambda$| Vector of Float | $vector\ size=(1, length(\lambda))$, each element has range $0$~$1$ |
| $collision\_prob$ | $collision\_pckt\over T$ for each $\lambda$| Vector of Float | $vector\ size=(1, length(\lambda))$, each element has range $0$~$1$ |
#### Timing Diagram
![](https://i.imgur.com/l16YbRw.png)
*Fig.2 Multichannel Slotted ALOHA timing diagram*
- There are $C$ channels and $M$ Stations
- The successful transmission happens when there is only one station transmitting the packet over the same channel
- The input from each station is modelled as a sequence of *independent Bernoulli Trials*. During each timeslot, the probability that station $i$ transmits packet in channel $c$ is $G_i={G\over MC}$
- There is no backoff time, the collided packet will be retransmitted again in the future timeslot over a random channel $c$, based on probability calculation of each station and *bernoulli trial*. (this is called $thinking\ state$)
#### Flow Chart
```flow
st=>start: Start
e=>end: End
op=>operation: lambda=0
op0=>operation: C=5
op1=>operation: success_pckt=0, 
collision_pckt=0
op2=>operation: t=1
op2_1=>operation: Rc(1)=0, 
Rc(2)=0, 
..., 
Rc(C)=0
op3=>operation: m=1
op4=>operation: Generate random 
number, 
assign to Pr
op5=>operation: STA m is transmitting 
packet in channel c
op5_1=>operation: choose one of C
channels randomly,
namely channel c
op5_2=>operation: increment Rc(c)
op6=>operation: STA is not 
transmitting
packet
op6_1=>operation: c=1
op7=>operation: increment pcktThisSlot
op8=>operation: increment
m
op9=>operation: Collision 
detected, 
increment 
collision_pckt
op10=>operation: packet successfully 
transmitted, 
increment success_pckt
op10_1=>operation: increment c
op11=>operation: increment t
op12=>operation: calculate throughput 
and collision_prob
for this lambda
op13=>operation: plot Y:throughput, 
X:lambda
op14=>operation: increment 
lambda 
by 0.2
op15=>operation: set c=10
cond=>condition: is
Pr<Gi?
cond2=>condition: is
m=M?
cond3=>condition: is Rc(c)=1?
cond4=>condition: is Rc(c)>1?
cond4_1=>condition: is c=C?
cond5=>condition: is
t=T?
cond6=>condition: is
lambda=15?
cond7=>condition: is c=10?

st->op0->op->op1->op2->op2_1->op3->op4->cond
cond(yes)->op5_1->op5->op5_2->cond2
cond(no)->op6->cond2
cond2(no)->op8->op4
cond2(yes)->op6_1->cond3
cond3(yes)->op10->cond4_1
cond3(no)->cond4
cond4(yes)->op9->cond4_1
cond4(no)->cond4_1
cond4_1(yes)->cond5
cond4_1(no)->op10_1->cond3
cond5(no)->op11->op2_1
cond5(yes)->op12->cond6
cond6(yes)->op13->cond7
cond6(no)->op14->op1
cond7(yes)->e
cond7(no)->op15->op
```
## Numerical Results
#### Scenario 1: Infinite-Station
![](https://i.imgur.com/Clf8lTa.png)
*Fig 3. Throughput of Infinite-Station Multichannel Slotted ALOHA*

![](https://i.imgur.com/ve3MLke.png)
*Fig 4. Collision Probability of Multichannel Slotted ALOHA*

Figures 3, and 4 illustrated simulation results and the analytical result of the throughput and the collision probability respectively. The maximum throughput of system with 10 channels is two times the maximum throughput of system with 5 channels. The maximum throughput of system with 10 channels occurs when $G=10$, and The maximum throughput of system with 10 channels occurs when $G=5$.

From figure 4 we know that the more the number of channels is, the less likely collision will occur
#### Scenario 2: Finite-Station
![](https://i.imgur.com/6lOpd5Y.png)
*Fig 5. Throughput of Multichannel Slotted ALOHA with 10 Stations*
![](https://i.imgur.com/mNYMYxs.png)
*Fig 6. Throughput of Multichannel Slotted ALOHA with 50 Stations*

Figure 5 and figure 6 tells us that lower number of stations will make the maximum throughput higher, but it will decay to zero faster.
Figures 5 and 6 illustrated simulation results and the analytical result of the throughput. The maximum throughput of system with 10 channels is two times the maximum throughput of system with 5 channels. The maximum throughput of system with 10 channels occurs when $G=10$, and The maximum throughput of system with 10 channels occurs when $G=5$.

![](https://i.imgur.com/8kiSZux.png)
*Fig 7. Collision Probability of Multichannel Slotted ALOHA with 10 Stations*

![](https://i.imgur.com/GOkPvtw.png)
*Fig 8. Collision Probability of Multichannel Slotted ALOHA with 50 Stations*

Similar to figure 4, from figures 7 and 8 we know that the more the number of channels is, the less likely collision will occur. 

From figure 7 and 8 we know that lower number of stations will make the collision probability approaches 1 faster.
