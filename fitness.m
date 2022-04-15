function [ total_dist,total_dist_cell ] = fitness(pop_size,pop,nsalesmen,T,xy,iter,R,route,Ptime,dmat )
%FITNESS 此处显示有关此函数的摘要
%能耗公式 energy = (d^-1 * T) + (1) + (d * T^-1) + (d^2 * T^-2) + (d^3 * T^-3) 
global result Question
C=0.5;
if Question <=5
    reftime = round(dmat);
else
    reftime = ceil(dmat);
end
total_dist = zeros(1,pop_size);
total_dist_cell = cell(1,pop_size);
% count=1;
parfor pp = 1:pop_size
    p = (pp-1)*2+1;
    Time = Ptime{ceil(pp)};
    d=zeros(nsalesmen,1);
    energy = 0;
    if nsalesmen == 2
        rng=[[1 T+1];[T 2*T]]';
    else
        rng=[[1 T+1 2*T+1 3*T+1];[T 2*T 3*T 4*T]]';
    end
    for s=1:nsalesmen
        for k =rng(s,1):rng(s,2)
            if length(intersect(pop(p,1+(s-1)*T:k),route{s}))==length(route{s}) ...
                    && pop(p,k) == (2-s)*(length(xy)-1)+abs(1-s)*length(xy) && pop(p+1,k) == (2-s)*(length(xy)-1)+abs(1-s)*length(xy)
                d(s,1) = d(s,1) + 0;
                break
            else
                if Time(pop(p,k),pop(p+1,k))<reftime(pop(p,k),pop(p+1,k))
                    Time(pop(p,k),pop(p+1,k)) = reftime(pop(p,k),pop(p+1,k));
                end
                d(s,1) = d(s,1) + Time(pop(p,k),pop(p+1,k));
                
                if pop(p,k) ~= pop(p+1,k)
                    energy = energy + (result{pop(p,k),pop(p+1,k)}(1) * Time(pop(p,k),pop(p+1,k))) ...
                        + (result{pop(p,k),pop(p+1,k)}(2)) ...
                        + (result{pop(p,k),pop(p+1,k)}(3) * (Time(pop(p,k),pop(p+1,k)))^-1) + ...
                        (result{pop(p,k),pop(p+1,k)}(4) *(Time(pop(p,k),pop(p+1,k)))^-2) + ...
                        (result{pop(p,k),pop(p+1,k)}(5) *(Time(pop(p,k),pop(p+1,k)))^-3);
                end
            end
        end
    end
    Maxdist= max(d);
    flag = 0;
%     if Maxdist>Tmax
%         flag = 1;
%     end
    Xkt=zeros(nsalesmen,Maxdist+1);
    Ykt=zeros(nsalesmen,Maxdist+1);
    ctime1=1;
    ctime2=1;
    Xkt(1,1)=xy(pop(p,1),1);
    Ykt(1,1)=xy(pop(p,1),2);
    Xkt(2,1)=xy(pop(p,1+T),1);
    Ykt(2,1)=xy(pop(p,1+T),2);
    for i=1:T
        dis1=Time(pop(p,i),pop(p+1,i));
        disx1=(xy(pop(p+1,i),1)-xy(pop(p,i),1))/dis1;
        disy1=(xy(pop(p+1,i),2)-xy(pop(p,i),2))/dis1;
        for j=ctime1:(ctime1+dis1-1)
            Xkt(1,j+1)=Xkt(1,j)+disx1;
            Ykt(1,j+1)=Ykt(1,j)+disy1;
        end
        ctime1=ctime1+dis1;
        dis2=Time(pop(p,i+T),pop(p+1,i+T));
        disx2=(xy(pop(p+1,i+T),1)-xy(pop(p,i+T),1))/dis2;
        disy2=(xy(pop(p+1,i+T),2)-xy(pop(p,i+T),2))/dis2;
        for j=ctime2:(ctime2+dis2-1)
            Xkt(2,j+1)=Xkt(2,j)+disx2;
            Ykt(2,j+1)=Ykt(2,j)+disy2;
        end
        ctime2=ctime2+dis2;
    end
    cctime1=ctime1;
    for i=cctime1:Maxdist
        Xkt(1,i+1)=Xkt(1,ctime1);
        Ykt(1,i+1)=Ykt(1,ctime1);
    end
    cctime2=ctime2;
    for i=cctime2:Maxdist
        Xkt(2,i+1)=Xkt(2,ctime2);
        Ykt(2,i+1)=Ykt(2,ctime2);
    end
    Robotdists=zeros(1,Maxdist+1);
    for i=1:Maxdist+1
        Robotdists(i)=sqrt((Xkt(1,i)-Xkt(2,i))^2+(Ykt(1,i)-Ykt(2,i))^2);
    end
    Robotdist=min(Robotdists);
    penty = 0;
    if Robotdist<=2*R
        penty=penty+100*(C*iter)^2*(2*R-Robotdist)^2;
    end
    obj1 = Maxdist;
    obj2 = energy;
    total_dist_cell{pp}= d;
%     PD = 1;
%     if PD == 1
        total_dist(pp) =obj1 + 0.00001*obj2 + penty; %+ 1000*(obj1~=18);%;+ flag*10^5; %
%     else
%         total_dist(count) =obj1 + penty;%; + flag*10^5;
%     end
%     count=count+1;
end
end

