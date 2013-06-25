%%%test randi
rng shuffle;
f=.25;
num=500000;
bin1=0:1:50;
bin2=0:1:200;
%bin1=bin2;
len=50;
height=200;

%generate cell
u(len, height)=0;
calc2 = abs(round(spherocylinder(len/2, height/2, len/2, height/2, 0, steps)));

calc2(calc2==0)=1;
calc2=calc2';

for calc =calc2
    u(calc(1),calc(2))=1;
end
u=imfill(u,'holes');

figure(2);imagesc(u);axis equal;

%get random points
  for n=1:num
      x=randi([1 (len-1)]);
      y=randi([1 (height-1)]);
      while u(x,y)==0
          x=randi([1 (len-1)]);
          y=randi([1 (height-1)]);
      end
      xy=[x,y];
      if n==1
        datals=xy;
      else
        datals=[datals;xy];
      end
  end
 
%graph random points
expect=[];
figure(2);
[f2,x2]=hist(datals(:,1),bin1);
bar(x2,f2/trapz(x2,f2))
hold on;
datals(:,1)=sort(datals(:,1));
expect(1:num)=0;
for w=1:num
    expect(w)=(sum(u(datals(w,1),:)/sum(sum(u))));
end
expect=expect';
expect=[datals(:,1) expect];
plot(expect(:,1),expect(:,2),'color','red')
hold off;
title('Distribution of a Large Number of Randomly Chosen X-values',... 
  'FontWeight','bold')
xlabel('X (nm)')
ylabel('Probability')
saveas(gcf, 'testRandiX.fig')






expect=[];
figure(3);
[f3,x3]=hist(datals(:,2),bin2);
bar(x3,f3/trapz(x3,f3))
hold on;
datals(:,2)=sort(datals(:,2));
expect(1:num,1)=0;
for w=1:num
    expect(w)=(sum(u(:,datals(w,2))/sum(sum(u))));
end
expect=[datals(:,2) expect];
plot(expect(:,1),expect(:,2),'color','red')
hold off;
title('Distribution of a Large Number of Randomly Chosen Y-values',... 
  'FontWeight','bold')
xlabel('Y (nm)')
ylabel('Probability')
saveas(gcf, 'testRandiY.fig')


datals=[];

for e=1:num
    x=randi([1 (len-1)]);
    y=randi([1 (height-1)]);
    xy=[x,y];
    if e==1
        datals=xy;
    else
        datals=[datals;xy];
    end
end


%graph random points
expect=[];
figure(6);
[f2,x2]=hist(datals(:,1),bin1);
bar(x2,f2/trapz(x2,f2))
hold on;
datals(:,1)=sort(datals(:,1));
expect(1:num)=0;
for w=1:num
    expect(w)=(.020);
end
expect=expect';
expect=[datals(:,1) expect];
plot(expect(:,1),expect(:,2),'color','red')
hold off;
title('Distribution of a Large Number of Randomly Chosen X-values',... 
  'FontWeight','bold')
xlabel('X (nm)')
ylabel('Probability')
saveas(gcf, 'testRandiX.fig')






expect=[];
figure(7);
[f3,x3]=hist(datals(:,2),bin2);
bar(x3,f3/trapz(x3,f3))
hold on;
datals(:,2)=sort(datals(:,2));
expect(1:num,1)=0;
for w=1:num
    expect(w)=(.005);
end
expect=[datals(:,2) expect];
plot(expect(:,1),expect(:,2),'color','red')
hold off;
title('Distribution of a Large Number of Randomly Chosen Y-values',... 
  'FontWeight','bold')
xlabel('Y (nm)')
ylabel('Probability')
saveas(gcf, 'testRandiY.fig')

