function runtestClumpings()
clear all
close all
ip = 'C:/Users/sw5/ImgSim/2-D'; % make less specific later
addpath(ip);
tic
testClumping('s')
testClumping('sc')
testClumping('el')
toc
end