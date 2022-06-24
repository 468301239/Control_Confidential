%Fuzzy Controller Design
clear all;
close all;

a=newfis('fuzzf');

f1=0.010;
a=addvar(a,'input','e',[-f1*3,f1*3]);            %Parameter e
a=addmf(a,'input',1,'N','zmf',[-f1*3,0]);
a=addmf(a,'input',1,'Z','trimf',[-f1*2,0,f1*2]);
a=addmf(a,'input',1,'P','smf',[0,f1*3]);

f2=0.010;
a=addvar(a,'input','ec',[-f2*3,f2*3]);          %Parameter ec
a=addmf(a,'input',2,'N','zmf',[-f2*3,0]);
a=addmf(a,'input',2,'Z','trimf',[-f2*2,0,f2*2]);
a=addmf(a,'input',2,'P','smf',[0,f2*3]);

f3=100;
a=addvar(a,'output','u',[-f3*3,f3*3]);          %Parameter u
a=addmf(a,'output',1,'N','zmf',[-f3*3,0]);
a=addmf(a,'output',1,'Z','trimf',[-f3*2,0,f3*2]);
a=addmf(a,'output',1,'P','smf',[0,f3*3]);

rulelist=[1 1 1 1 1;         %Edit rule base
          1 2 1 1 1;
          1 3 2 1 1;
   
          2 1 2 1 1;
          2 2 2 1 1;
          2 3 2 1 1;
          
          3 1 2 1 1;
          3 2 3 1 1;
          3 3 3 1 1];
          
a=addrule(a,rulelist);
showrule(a)                        % Show fuzzy rule base

a1=setfis(a,'DefuzzMethod','mom');  % Defuzzy
writefis(a1,'fuzzf');               % save to fuzzy file "fuzz.fis" which can be
                                    % simulated with fuzzy tool
a2=readfis('fuzzf');

figure(1);
plotfis(a2);
figure(2);
plotmf(a,'input',1);
figure(3);
plotmf(a,'input',2);
figure(4);
plotmf(a,'output',1);