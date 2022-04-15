clc;
clear;
close all;
global result Question
for Question =1
    [xy,nsalesmen,R,optroute,optbreak,n,dmat,Time,result,pop_size,num_iter] = DataGet( Question );
    x=xy(:,1);
    y=xy(:,2);
    C=length(xy);
    % plot(x,y,'ro')
    %% time-space model
    optroute1=optroute;
    optbreak1=optbreak;
    if nsalesmen == 4
        T=max([optbreak(1),optbreak(2)-optbreak(1),optbreak(3)-optbreak(2),n-max(optbreak)]);
    else
        T=max([optbreak(1) n-max(optbreak)])+2;
    end
    A = zeros(1,10);
    Energy = zeros(1,10);
    Makespan = zeros(1,10);
    Dist_history = zeros(num_iter,10);
    Ctime = zeros(1,10);
    for cc = 1
        tic
        [opt_rte,min_dist,dist_history,opt_Time] =tsp_gas_2(xy,dmat,Time,pop_size,num_iter,T,nsalesmen,R,optroute1,optbreak1);
        toc
        dt = toc;
        A(cc) = dt;
        %---------
        Time = opt_Time;
        [energy, makespan] = b_judge(optbreak,optroute,opt_rte,nsalesmen,T,Time,xy,dmat);
        Makespan(cc) = makespan;
        Energy(cc) = energy;
        Dist_history(:,cc) = dist_history;   %%  newly added
        %*-----------
        disp('The shortest distance')
        disp(min_dist);
        opt_route=[];
        for i=1:nsalesmen*T
            Time_Table(i)= Time(opt_rte(1,i),opt_rte(2,i));
            if opt_rte(1,i)~=opt_rte(2,i)
                Energy_Table(i)=result{opt_rte(1,i),opt_rte(2,i)}(1) * Time_Table(i) + (result{opt_rte(1,i),opt_rte(2,i)}(2)) ...
                    + (result{opt_rte(1,i),opt_rte(2,i)}(3) * (Time_Table(i))^-1) + ...
                    (result{opt_rte(1,i),opt_rte(2,i)}(4) *(Time_Table(i))^-2) + ...
                    (result{opt_rte(1,i),opt_rte(2,i)}(5) *(Time_Table(i))^-3);
            end
        end
        %         if nsalesmen==2
        %              c_time(1)=sum(Time_Table(1:optbreak));
        %              c_time(2)=sum(Time_Table(T+1:T+n-optbreak));
        %         end
        %     makespan=max(c_time)
        %  energy=sum(Energy_Table)
    end
%      plot(mean(Dist_history,2))
%     set(gca,'YLim',[18.05 18.1])
end