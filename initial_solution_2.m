function route=initial_solution_2(N,T,optroute,optbreak)
poproute=optroute;  %% 所有节点的集合
popbreak=optbreak;
poptime=zeros(2,(2*T));
node=1; %初始节点位置
%% 
route1 = poproute(1:popbreak);  %% 机器人1需要访问的节点
route2 = poproute(popbreak+1:end); %% 机器人2需要访问的节点
%%
poptime(1,node)=poproute(1);   %%机器人1开始
order1=randperm(popbreak);    %% 随机生成 机器人1需要访问分配节点的顺序
for i=popbreak(1)+1:T
    order1=[order1,unidrnd(popbreak)];   %% 填满第一个机器人剩下的节点
end
%%
poptime(1,T+node)=poproute(N); %% 机器人2开始
order2=randperm(N-popbreak);   %% 随机生成 机器人1需要访问分配节点的顺序
for i=N-popbreak+1:T
    order2=[order2,unidrnd(N-popbreak)];
end

%%
order2=order2+popbreak;   %%生成实际的机器人2小访问分配节点
order1
a1=find(order1==1);
a1
order1(1,[a1(1) T])=order1(1,[T a1(1)]);
order1
a2=find(order2==N);
order2(1,[a2(1) T])=order2(1,[T a2(1)]);

%%
poptime(2,1)=poproute(order1(1));% 生成第一个机械臂所有的路径段
poptime(1,2)=poptime(2,1);% 生成第一个机械臂所有的路径段

poptime
poptime(2,T+1)=poproute(order2(1));% 生成第二个机械臂所有的路径段
poptime(1,T+2)=poptime(2,T+1);
    
for node= 2:T
    if length(intersect(poptime(1,1:node),route1)) == length(route1)
        poptime(2,node)=poproute(1);% 生成第一个机械臂所有的路径段
        poptime(1,node+1)=poproute(1);% 生成第一个机械臂所有的路径段
    else
        poptime(2,node)=poproute(order1(node));% 生成第一个机械臂所有的路径段
        poptime(1,node+1)=poptime(2,node);% 生成第一个机械臂所有的路径段
    end
     poptime
    if length(intersect(poptime(1,T+1:T+node),route2)) == length(route2)
        poptime(2,T+node)=poproute(N);% 生成第二个机械臂所有的路径段
        poptime(1,T+node+1)=poproute(N);
    else
        poptime(2,T+node)=poproute(order2(node));% 生成第二个机械臂所有的路径段
        poptime(1,T+node+1)=poptime(2,T+node);
    end 
    if node+1==T
        poptime(2,node+1)=poproute(1);
        poptime(2,T+node+1)=poproute(N);
        break;
    end
end
%% 修正程序
     route=poptime;
end


