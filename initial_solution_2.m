function route=initial_solution_2(N,T,optroute,optbreak)
poproute=optroute;  %% ���нڵ�ļ���
popbreak=optbreak;
poptime=zeros(2,(2*T));
node=1; %��ʼ�ڵ�λ��
%% 
route1 = poproute(1:popbreak);  %% ������1��Ҫ���ʵĽڵ�
route2 = poproute(popbreak+1:end); %% ������2��Ҫ���ʵĽڵ�
%%
poptime(1,node)=poproute(1);   %%������1��ʼ
order1=randperm(popbreak);    %% ������� ������1��Ҫ���ʷ���ڵ��˳��
for i=popbreak(1)+1:T
    order1=[order1,unidrnd(popbreak)];   %% ������һ��������ʣ�µĽڵ�
end
%%
poptime(1,T+node)=poproute(N); %% ������2��ʼ
order2=randperm(N-popbreak);   %% ������� ������1��Ҫ���ʷ���ڵ��˳��
for i=N-popbreak+1:T
    order2=[order2,unidrnd(N-popbreak)];
end

%%
order2=order2+popbreak;   %%����ʵ�ʵĻ�����2С���ʷ���ڵ�
order1
a1=find(order1==1);
a1
order1(1,[a1(1) T])=order1(1,[T a1(1)]);
order1
a2=find(order2==N);
order2(1,[a2(1) T])=order2(1,[T a2(1)]);

%%
poptime(2,1)=poproute(order1(1));% ���ɵ�һ����е�����е�·����
poptime(1,2)=poptime(2,1);% ���ɵ�һ����е�����е�·����

poptime
poptime(2,T+1)=poproute(order2(1));% ���ɵڶ�����е�����е�·����
poptime(1,T+2)=poptime(2,T+1);
    
for node= 2:T
    if length(intersect(poptime(1,1:node),route1)) == length(route1)
        poptime(2,node)=poproute(1);% ���ɵ�һ����е�����е�·����
        poptime(1,node+1)=poproute(1);% ���ɵ�һ����е�����е�·����
    else
        poptime(2,node)=poproute(order1(node));% ���ɵ�һ����е�����е�·����
        poptime(1,node+1)=poptime(2,node);% ���ɵ�һ����е�����е�·����
    end
     poptime
    if length(intersect(poptime(1,T+1:T+node),route2)) == length(route2)
        poptime(2,T+node)=poproute(N);% ���ɵڶ�����е�����е�·����
        poptime(1,T+node+1)=poproute(N);
    else
        poptime(2,T+node)=poproute(order2(node));% ���ɵڶ�����е�����е�·����
        poptime(1,T+node+1)=poptime(2,T+node);
    end 
    if node+1==T
        poptime(2,node+1)=poproute(1);
        poptime(2,T+node+1)=poproute(N);
        break;
    end
end
%% ��������
     route=poptime;
end


