clear all;

r1=3.9; r2=3.5; r3=3.62; r4=3.75; r5=3.65; r6=3.72; r7=3.57; r8=3.68;
beta31=0.35; beta32=0.35; beta42=0.35; beta53=0.35; beta63=0.35; beta76=0.35; beta86=0.35;
maxL=1000;
X1=zeros(maxL,1); X2=zeros(maxL,1); X3=zeros(maxL,1); X4=zeros(maxL,1); X5=zeros(maxL,1); X6=zeros(maxL,1); X7=zeros(maxL,1); X8=zeros(maxL,1);
X1(1)=0.4; X2(1)=0.4; X3(1)=0.4; X4(1)=0.4; X5(1)=0.4; X6(1)=0.4; X7(1)=0.4; X8(1)=0.4;
for j=2:maxL
    X1(j)=X1(j-1)*(r1-r1*X1(j-1))+normrnd(0,0.005);
    X2(j)=X2(j-1)*(r2-r2*X2(j-1))+normrnd(0,0.005);
    X3(j)=X3(j-1)*(r3-r3*X3(j-1)-beta31*X1(j-1)-beta32*X2(j-1))+normrnd(0,0.005);
    X4(j)=X4(j-1)*(r4-r4*X4(j-1)-beta42*X2(j-1))+normrnd(0,0.005);
    X5(j)=X5(j-1)*(r5-r5*X5(j-1)-beta53*X3(j-1))+normrnd(0,0.005);
    X6(j)=X6(j-1)*(r6-r6*X6(j-1)-beta63*X3(j-1))+normrnd(0,0.005);
    X7(j)=X7(j-1)*(r7-r7*X7(j-1)-beta76*X6(j-1))+normrnd(0,0.005);
    X8(j)=X8(j-1)*(r8-r8*X8(j-1)-beta86*X6(j-1))+normrnd(0,0.005);
end

E=4; tau=1;
N=8; G=[X1 X2 X3 X4 X5 X6 X7 X8];

LL=zeros(E,maxL,N);
for i=1:N
    for p=1+(E-1)*tau:maxL
        for q=1:E
            LL(q,p,i)=G(p-(q-1)*tau,i);
        end
    end
end
MM=zeros(maxL,maxL,N);
for i=1:N
    for r=1+(E-1)*tau:maxL
        for s=r:maxL
            MM(r,s,i)=norm(LL(:,r,i)-LL(:,s,i));
        end
    end
    MM(:,:,i)=MM(:,:,i)+MM(:,:,i)';
end
GG=G(1+(E-1)*tau:maxL,:);
MM=MM(1+(E-1)*tau:maxL,1+(E-1)*tau:maxL,:);

%��Ԥ�����еĳ���
PL=950;
%��Ѱʱ�͵Ĵ�С
maxfdelay=10;
fdelay=0:1:maxfdelay;
%��Ԥ�����е�ָ��
cy=maxfdelay+1:maxfdelay+PL;
%Library�Ĵ�С
LB=PL;
%����ʱ����ڵĸ���
NB=0;

C=zeros(length(fdelay),N,N);
CX=zeros(PL,length(fdelay),N,N);
CY=zeros(PL,N,N);
PC=zeros(length(fdelay),N,N,N);
PCX=zeros(PL,length(fdelay),N,N,N);
PCY=zeros(PL,N,N,N);
PPC=zeros(N,N);
PV=zeros(N,N);


%%%%% GiԤ��Gj %%%%%
for i=1:N
    for j=1:N
        if j==i
            continue;
        end
        %��Ԥ������
        CY(:,i,j)=GG(cy,j);
        sh=floor(rand(1,1)*(maxL-(E-1)*tau-maxfdelay-(maxfdelay+LB)));
        for w=1:length(fdelay)
            %Library��ָ��
            mx=maxfdelay+1+sh:maxfdelay+LB+sh;
            for r=1:PL
                %����Ԥ��ĵ���ԭ�����е�ָ��
                px=maxfdelay+r+fdelay(w);
                %Library���˵�ľ�������
                MX=MM(mx,px,i);
                %��Ѱ����ҷ�ʱ���ڽ���Library�㣬����ԭ�����е�ָ�����IX��
                IX=zeros(E+1,1);
                [~,ind]=sort(MX,'ascend');
                for t=1:LB
                    if MX(ind(t))~=0
                        break;
                    end
                end
                tt=0;
                fd=0;
                while tt<E+1
                    if abs(ind(t+fd)+maxfdelay+sh-px)<=NB
                        fd=fd+1;
                    else
                        IX(tt+1)=ind(t+fd)+maxfdelay+sh;
                        tt=tt+1;
                        fd=fd+1;
                    end
                end
                %����Ȩ��
                U=zeros(E+1,1);
                sumU=0;
                for b=1:E+1
                    U(b)=exp(-MX(IX(b)-maxfdelay-sh)/MX(IX(1)-maxfdelay-sh));
                    sumU=sumU+U(b);
                end
                %����Ԥ���ֵ
                sumY=0;
                for b=1:E+1
                    sumY=sumY+(U(b)/sumU)*GG(IX(b)-fdelay(w),j);
                end
                CX(r,w,i,j)=sumY;
            end
            CR=corrcoef(CX(:,w,i,j),CY(:,i,j));
            C(w,i,j)=CR(1,2);
        end
    end
end

%%%%% PGj_GiԤ��G_k %%%%%
for i=1:N
    for j=1:N
        if i==j
            continue;
        end
        [mv,mid]=max(C(:,i,j));
        P=CX(:,mid,i,j);
        PP=[zeros((E-1)*tau+maxfdelay,1);P;zeros(length(GG(:,1))-maxfdelay-PL,1)];
        LLP=zeros(E,maxL);
        for p=1+(E-1)*tau:maxL
            for q=1:E
                LLP(q,p)=PP(p-(q-1)*tau);
            end
        end
        MMP=zeros(maxL,maxL);
        for r=1+(E-1)*tau:maxL
            for s=r:maxL
                MMP(r,s)=norm(LLP(:,r)-LLP(:,s));
            end
        end
        MMP=MMP+MMP';
        PP=PP(1+(E-1)*tau:maxL);
        MMP=MMP(1+(E-1)*tau:maxL,1+(E-1)*tau:maxL);
        for k=1:N
            if k==i || k==j
                continue;
            end
            %��Ԥ������
            PCY(:,k,i,j)=GG(cy,k);
            sh=floor(rand(1,1)*(maxL-(E-1)*tau-maxfdelay-(maxfdelay+LB)));
            for w=1:length(fdelay)
                %Library��ָ��
                mx=maxfdelay+1+sh:maxfdelay+LB+sh;
                for r=1:PL
                    %����Ԥ��ĵ���ԭ�����е�ָ��
                    px=maxfdelay+r+fdelay(w);
                    %Library���˵�ľ�������
                    MX=MMP(mx,px);
                    %��Ѱ����ҷ�ʱ���ڽ���Library�㣬����ԭ�����е�ָ�����IX��
                    IX=zeros(E+1,1);
                    [~,ind]=sort(MX,'ascend');
                    for t=1:LB
                        if MX(ind(t))~=0
                            break;
                        end
                    end
                    tt=0;
                    fd=0;
                    while tt<E+1
                        if abs(ind(t+fd)+maxfdelay+sh-px)<=NB
                            fd=fd+1;
                        else
                            IX(tt+1)=ind(t+fd)+maxfdelay+sh;
                            tt=tt+1;
                            fd=fd+1;
                        end
                    end
                    %����Ȩ��
                    U=zeros(E+1,1);
                    sumU=0;
                    for b=1:E+1
                        U(b)=exp(-MX(IX(b)-maxfdelay-sh)/MX(IX(1)-maxfdelay-sh));
                        sumU=sumU+U(b);
                    end
                    %����Ԥ���ֵ
                    sumY=0;
                    for b=1:E+1
                        sumY=sumY+(U(b)/sumU)*GG(IX(b)-fdelay(w),k);
                    end
                    PCX(r,w,k,i,j)=sumY;
                end
                CR=corrcoef(PCX(:,w,k,i,j),PCY(:,k,i,j));
                PC(w,k,i,j)=CR(1,2);
            end
        end
    end
end

for i=1:N
    for j=1:N
        if j==i
            continue;
        end
        PA=[];
        for k=1:N
            if k==i || k==j
                continue;
            end
            [mv,mid]=max(PC(:,j,i,k));
            PPA=PCX(:,mid,j,i,k);
            PA=[PA PPA];
        end
        [mv,mid]=max(C(:,i,j));
        [PPC(i,j),PV(i,j)]=partialcorr(CX(:,mid,i,j),CY(:,i,j),PA);
    end
end


save net;