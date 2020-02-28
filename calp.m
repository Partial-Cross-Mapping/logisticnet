load net;

with=[];
without=[];
for i=1:N
    for j=1:N
        if j==i
            continue;
        end
        if ((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
            with=[with abs(PPC(i,j))];
        else
            without=[without abs(PPC(i,j))];
        end
    end
end

a=randperm(56);
h1=plot(with,a(1:length(with)),'^','markersize',12);
hold on;
h2=plot(without,a(length(with)+1:56),'o','markersize',12);
xlabel('PCM index \rho_D');
legend('With direct causality','Without direct causality');
set(gca,'FontSize',18);
set(gca,'YTick',[]);
axis([min([with,without])-0.05 max([with,without])+0.05 0 58]);
sd=kmeans([with without]',2);


with=[];
without=[];
for i=1:N
    for j=1:N
        if j==i
            continue;
        end
        if ((j==1 && i==3)||(j==2 && i==3)||(j==2 && i==4)||(j==3 && i==5)||(j==3 && i==6)||(j==6 && i==7)||(j==6 && i==8))
            with=[with abs(max(C(:,i,j)))];
        else
            without=[without abs(max(C(:,i,j)))];
        end
    end
end

figure;
a=randperm(56);
h1=plot(with,a(1:length(with)),'^','markersize',12);
hold on;
h2=plot(without,a(length(with)+1:56),'o','markersize',12);
xlabel('MCM index \rho_C');
legend('With direct causality','Without direct causality');
set(gca,'FontSize',18);
set(gca,'YTick',[]);
axis([min([with,without])-0.05 max([with,without])+0.05 0 58]);
sc=kmeans([with without]',2);