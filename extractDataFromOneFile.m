clc
clear all
close all
Path='/home/omar/PhD/Runs/dataExtraction/uncontroledChannel';
startTime=1;
endTime=167;
Step=5;
% load('DATA_38500_NZ19') %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
dt=0.005;
% ========== Main Grid Size =================
nx=128;
ny=129;
nz=128;
Lx=4*pi;
Ly=2;
Lz=4/3*pi;
dx=Lx/(nx-1);
dz=Lz/(nz-1);
y=load([Path,'/','yp.dat']);
dy=y(2)-y(1);
%#############################################
%############## Saving Box Size ##############
%50,74,1,34,33,48
% 50,74,1,34,47,80
nxB1=50;
nxB2=74;
nyB1=1;
nyB2=34;
nzB1=47;
nzB2=80;
nxBox=nxB2-nxB1+1;
nyBox=nyB2-nyB1+1;
nzBox=nzB2-nzB1+1;
%#############################################
%############## Measuring points ##############
xm1=[12];
ym1=[1];
zm1=[8:26];

xm2=[12];
ym2=[11];
zm2=[17];
%#############################################
%##############  Extract Data   ##############

k=0;
% test=0;
for time=startTime:endTime
    time
    Start=nxBox*nyBox*nzBox*(time-1)+1;
    ux=readBinaySub([Path,'/subSave/uxSubdomain'],nxBox,nyBox,nzBox,Start);
    uy=readBinaySub([Path,'/subSave/uySubdomain'],nxBox,nyBox,nzBox,Start);
    uz=readBinaySub([Path,'/subSave/uzSubdomain'],nxBox,nyBox,nzBox,Start);
    pp=readBinaySub([Path,'/subSave/ppSubdomain'],nxBox,nyBox,nzBox,Start);
    
    

    
    %%==========================================
%     UX1D=UX(Start:End);
%     ux=reshape(UX1D,nxBox,nyBox,nzBox);
    ux2D(:,:)=ux(5,:,:);
    contourf(ux2D)
    drawnow
    
    uxMeasure1(:)=ux(xm1,ym1+1,zm1);
    uzMeasure1(:)=uz(xm1,ym1+1,zm1);
    ppMeasure1(:)=pp(xm1,ym1,zm1);
    uxMeasure2(:)=ux(xm2,ym2,zm2);
    uyMeasure2(:)=uy(xm2,ym2,zm2);
    uzMeasure2(:)=uz(xm2,ym2,zm2);
    %%==========================================
    dudy=(uxMeasure1-0)/dy;
    dwdy=(uzMeasure1-0)/dy;
    dpdx(:)=(pp(xm1+1,ym1,zm1)-pp(xm1,ym1,zm1))/dx;
    dpdz(:)=(pp(xm1,ym1,zm1+1)-pp(xm1,ym1,zm1))/dz;
    %%==========================================
    if time>1;
        
        DdudyDt=(dudy-dudy_old)/dt;
        DdwdyDt=(dwdy-dwdy_old)/dt;
        DppDt=(ppMeasure1-ppMeasure1_old)/dt;
        DdpdxDt=(dpdx-dpdx_old)/dt;
        DdpdzDt=(dpdz-dpdz_old)/dt;
        inputData(time-1,:)=[dudy,dwdy,ppMeasure1,dpdx,dpdz,DdudyDt,DdwdyDt,DppDt,DdpdxDt,DdpdzDt];
        targetData(time-1,:)=[uxMeasure2, uyMeasure2, uzMeasure2];
    end
    
    ppMeasure1_old=ppMeasure1;
    dudy_old=dudy;
    dwdy_old=dwdy;
    dpdx_old=dpdx;
    dpdz_old=dpdz;
    
    
end

