clear all;

load net;
TH=0:0.01:1;
tpr=zeros(length(TH),2);
fpr=zeros(length(TH),2);
for t=1:length(TH)
    for i=1:N
        for j=1:N
            if j==i
                continue;
            end
            if abs(max(C(:,i,j)))>=TH(t) && ((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
                tpr(t,1)=tpr(t,1)+1;
            end
            if abs(max(C(:,i,j)))>=TH(t) && ~((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
                fpr(t,1)=fpr(t,1)+1;
            end
            if abs(PPC(i,j))>=TH(t) && ((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
                tpr(t,2)=tpr(t,2)+1;
            end
            if abs(PPC(i,j))>=TH(t) && ~((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
                fpr(t,2)=fpr(t,2)+1;
            end
        end
    end
end
acc=tpr+N*(N-1)-7-fpr;
tpr=tpr/7;
fpr=fpr/(N*(N-1)-7);
acc=acc/(N*(N-1));


figure;
plot(acc(:,1),'linewidth',2);
hold on;
plot(acc(:,2),'linewidth',2);
set(gca,'FontSize',15);
xlabel('Threshold');
ylabel('Accuracy');
legend('Mutual cross mapping','Partial cross mapping','location','southeast');
axis([1 81 0 1]);
set(gca,'XTick',[1,11,21,31,41,51,61,71,81]);
set(gca,'XTicklabel',{'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8'});
set(gca,'YTick',[0,0.2,0.4,0.6,0.8,1]);
set(gca,'YTicklabel',{'0%','20%','40%','60%','80%','100%'});

axes('position',[0.67,0.36,0.21,0.24]);
plot(acc(:,1),'linewidth',2);
hold on;
plot(acc(:,2),'linewidth',2);
set(gca,'FontSize',10);
axis([93 98 0.8 1]);
set(gca,'XTick',[93,95,97]);
set(gca,'XTicklabel',{'0.92','0.94','0.96'});
set(gca,'YTick',[0.8,0.9,1]);
set(gca,'YTicklabel',{'80%','90%','100%'});


TH=0:0.01:1;
tpr=zeros(length(TH),2);
fpr=zeros(length(TH),2);
for t=1:length(TH)
    for i=1:N
        for j=1:N
            if j==i
                continue;
            end
            if abs(max(C(:,i,j)))>=TH(t) && ((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
                tpr(t,1)=tpr(t,1)+1;
            end
            if abs(max(C(:,i,j)))>=TH(t) && ~((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
                fpr(t,1)=fpr(t,1)+1;
            end
            if abs(PPC(i,j))>=TH(t) && abs(PPC(i,j))/abs(max(C(:,i,j)))>=0.7 && ((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
                tpr(t,2)=tpr(t,2)+1;
            end
            if abs(PPC(i,j))>=TH(t) && abs(PPC(i,j))/abs(max(C(:,i,j)))>=0.7 && ~((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
                fpr(t,2)=fpr(t,2)+1;
            end
        end
    end
end
acc=tpr+N*(N-1)-7-fpr;
tpr=tpr/7;
fpr=fpr/(N*(N-1)-7);
acc=acc/(N*(N-1));


figure;
plot(acc(:,1),'linewidth',2);
hold on;
plot(acc(:,2),'linewidth',2);
set(gca,'FontSize',15);
xlabel('Threshold');
ylabel('Accuracy');
legend('Mutual cross mapping','Partial cross mapping','location','southeast');
axis([1 81 0 1]);
set(gca,'XTick',[1,11,21,31,41,51,61,71,81]);
set(gca,'XTicklabel',{'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8'});
set(gca,'YTick',[0,0.2,0.4,0.6,0.8,1]);
set(gca,'YTicklabel',{'0%','20%','40%','60%','80%','100%'});

axes('position',[0.67,0.36,0.21,0.24]);
plot(acc(:,1),'linewidth',2);
hold on;
plot(acc(:,2),'linewidth',2);
set(gca,'FontSize',10);
axis([93 98 0.8 1]);
set(gca,'XTick',[93,95,97]);
set(gca,'XTicklabel',{'0.92','0.94','0.96'});
set(gca,'YTick',[0.8,0.9,1]);
set(gca,'YTicklabel',{'80%','90%','100%'});