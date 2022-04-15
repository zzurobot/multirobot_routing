
function varargout = tsp_gas_2(xy,dmat,Time,pop_size,num_iter,T,nsalesmen,R,optroute,optbreak)
%% 算法参数
global Question
% global Tmax PD
[N,dims] = size(xy);
[nr,nc] = size(dmat);
if N ~= nr || N ~= nc
    error('Invalid XY or DMAT inputs!')
end
n = N;
% Sanity Checks
pop_size = 8*ceil(pop_size/8);
num_iter = max(1,round(real(num_iter(1))));

if nsalesmen==2
    route1 = optroute(1:optbreak);
    route2 = optroute(optbreak+1:end);
    route = {route1,route2};
    n1=length(route1);
    n2=length(route2);
else
    route1 = optroute(1:optbreak(1));
    route2 = optroute(optbreak(1)+1:optbreak(2));
    route3 = optroute(optbreak(2)+1:optbreak(3));
    route4 = optroute(optbreak(3)+1:end);
    route= {route1,route2,route3,route4};
    n1=length(route1);
    n2=length(route2);
    n3=length(route3);
    n4=length(route4);
end
%% 初始解
pop = zeros(2*pop_size,nsalesmen*T);
for k = 1:2:2*pop_size-1
    if nsalesmen == 2
        pop(k:k+1,:) = initial_solution_2(n,T,optroute,optbreak);
    else
        pop(k:k+1,:) = initial_solution_4(n,T,optroute,optbreak);
    end
end  %初始解 
%% Run the GA
global_min = Inf;
dist_history = zeros(1,num_iter);
tmp_pop = zeros(2*8,nsalesmen*T); %选四组解出来
tmp_time = cell(1,8);
new_pop = zeros(2*pop_size,nsalesmen*T);%新的一个种群
new_time = cell(1,pop_size);

% PD = 1; % 1 energy, 2 makespan
% if PD == 1
%     LS = 0.5;
% else
%     LS = 0;
% end
hWait=waitbar(0,'========迭代中=======');
PTime = cell(1,pop_size);
PTime{1} = Time;
for k = 2:pop_size
    for i = 1:N
        for j = 1:N
            if Question<=5
                Time(i,j) = round(dmat(i,j));
            else
                Time(i,j) = ceil(dmat(i,j));     
            end
        end
    end   
    PTime{k} = Time;
end
for iter = 1
%for iter = 1:num_iter 
    % Evaluate Each Population Member (Calculate Total Distance)
    [ total_dist,total_dist_cell ] = fitness(pop_size,pop,nsalesmen,T,xy,iter,R,route,PTime,dmat);
    % Find the Best Route in the Population
    [min_dist,index] = min(total_dist);
   
    if min_dist < global_min
        global_min = min_dist; %最小路径
        opt_rte = pop(2*index-1:2*index,:);%最小路径的行程
        opt_Time = PTime{index};
    end
     dist_history(iter) = global_min;
    % Genetic Algorithm Operators
    rand_pair = 1:pop_size; %1-popsize 的随机排列
    for p = 8:8:pop_size
        rend=[];
        for i=7:-1:0
            rend=[rend,2*rand_pair(p-i)-1:2*rand_pair(p-i)];
        end
        rtes = pop(rend,:); %随机选4组解
        rtime = cell(1,8);
        rtime{1} = PTime{p-7};rtime{2} = PTime{p-6};
        rtime{3} = PTime{p-5};rtime{4} = PTime{p-4};
        rtime{5} = PTime{p-3};rtime{6} = PTime{p-2};
        rtime{7} = PTime{p-1};rtime{8} = PTime{p-0};
        dists = total_dist(rand_pair(p-7:p)); %每组解的路径的距离
        dists_cell = total_dist_cell(rand_pair(p-7:p));
        [~,idx] = min(dists);
        best_of_4_rte = rtes(2*idx-1:2*idx,:);
        best_of_dists_cell = dists_cell{idx};
        best_time = rtime{idx};
        
        %-----------------modify-------------------------------------------
        tmp_time{1} = best_time;
        index = 1:8;
        index = setdiff(index,idx);
        for k = 1:7
            tmp_time{k+1}=rtime{index(k)};
        end
        %-----------------modify-------------------------------------------

%% 交叉 变异 
        
%          while 1
%              ins_pts = sort(ceil(n*rand(1,2)));
%              I = ins_pts(1);
%              J = ins_pts(2);
%              if I>1 && J<T
%                  break
%              end
%          end  %确保交换的过程起点和重点不会变化
%      [~,choose] = max(best_of_dists_cell);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        choose=randi(nsalesmen);
        if choose==1
            ins_pts = sort(ceil((n1-2)*rand(1,2))+1);
             I = ins_pts(1);
             J = ins_pts(2);
        end
         if choose==2
            ins_pts = sort(ceil((n2-2)*rand(1,2))+1);
             I = ins_pts(1);
             J = ins_pts(2);
         end
                  if choose==3
            ins_pts = sort(ceil((n3-2)*rand(1,2))+1);
             I = ins_pts(1);
             J = ins_pts(2);
                  end
                  if choose==4
            ins_pts = sort(ceil((n4-2)*rand(1,2))+1);
             I = ins_pts(1);
             J = ins_pts(2);
         end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Points = sort(randperm(N,2));
%         II = Points(1);
%         JJ = Points(2);
         cc = 1;
        for k = 1:2:2*8 % Mutate the Best to get Three New Routes
            
            tmp_pop(k:k+1,:) = best_of_4_rte;
%             tmp_time{cc} = best_time;
            switch k
                case 3 % Flip 翻转这两个点之间的序列
%                     choose = randi(nsalesmen);
                    tmp_pop(k:k+1,I+(choose-1)*T:J+(choose-1)*T) = ... 
                        fliplr(tmp_pop(k:k+1,I+(choose-1)*T:J+(choose-1)*T));
                case 5 % Swap 交换这两个点的位置
%                     choose = randi(nsalesmen);
                    tmp_pop(k:k+1,[I+(choose-1)*T J+(choose-1)*T]) = ...
                        tmp_pop(k:k+1,[J+(choose-1)*T I+(choose-1)*T]);
                case 7 % Slide
%                     choose = randi(nsalesmen);
                    tmp_pop(k:k+1,I+(choose-1)*T:J+(choose-1)*T) = ...
                        tmp_pop(k:k+1,[I+1+(choose-1)*T:J+(choose-1)*T I+(choose-1)*T]);
                case 9 % Flip 翻转这两个点之间的序列
                    
                    if Question<=5
                        Time = round(dmat) + randi([0 1],size(dmat));
                    else
                        Time = ceil(dmat)+ randi([0 1],size(dmat));
                    end
                    
                    tmp_time{cc} = Time;
                case 11 % Swap 和最优时间交换两行
%                     choose = randi(nsalesmen);
%                     tmp_pop(k:k+1,I+(choose-1)*T:J+(choose-1)*T) = ...
%                         fliplr(tmp_pop(k:k+1,I+(choose-1)*T:J+(choose-1)*T));
%                     tmp_time{cc}([II JJ],:) = best_time([II JJ],:);
                    Points = sort(randperm(N,2));
                    II = Points(1);
                    JJ = Points(2);
                    tmp_time{cc}([II JJ],:) = tmp_time{cc}([JJ II],:);
                case 13 % Slide 和最优时间交换II:JJ之间的内容
%                     choose = randi(nsalesmen);
%                     tmp_pop(k:k+1,[I+(choose-1)*T J+(choose-1)*T]) = ...
%                         tmp_pop(k:k+1,[J+(choose-1)*T I+(choose-1)*T]);
%                     tmp_time{cc}(II:JJ,:) = best_time(II:JJ,:);
                    Points = sort(randperm(N,2));
                    II = Points(1);
                    JJ = Points(2);
                    tmp_time{cc}(II:JJ,:) = tmp_time{cc}([II+1:JJ II],:);
                case 15 % 和最优时间交换II：end之间的内容
%                     choose = randi(nsalesmen);
%                     tmp_pop(k:k+1,I+(choose-1)*T:J+(choose-1)*T) = ...
%                         tmp_pop(k:k+1,[I+1+(choose-1)*T:J+(choose-1)*T I+(choose-1)*T]);
%                     tmp_time{cc}(1:II,:) = best_time(1:II,:);
%                     tmp_time{cc}(JJ:end,:) = best_time(JJ:end,:);
                       Points = sort(randperm(N,2));
                    II = Points(1);
                    JJ = Points(2);
                    tmp_time{cc}(II:JJ,:) = tmp_time{cc}(JJ:-1:II,:);
                otherwise % Do Nothing
            end
            cc = cc + 1;
        end
        if nsalesmen == 2
            omg=[[1 T+1];[T 2*T]]';
        else
            omg=[[1 T+1 2*T+1 3*T+1];[T 2*T 3*T 4*T]]';
        end
        for s=1:nsalesmen
            for k =omg(s,1):omg(s,2)-1
                for i=1:2:2*8
                tmp_pop(i,k+1)=tmp_pop(i+1,k);
                end
            end
        end
        new_pop(2*(p-7)-1:2*p,:) = tmp_pop;
        new_time{p-7}=tmp_time{1};new_time{p-6}=tmp_time{2};
        new_time{p-5}=tmp_time{3};new_time{p-4}=tmp_time{4};
        new_time{p-3}=tmp_time{5};new_time{p-2}=tmp_time{6};
        new_time{p-1}=tmp_time{7};new_time{p-0}=tmp_time{8};
    end
    pop = new_pop;
    PTime = new_time;
    waitbar(iter/num_iter,hWait)
   
end
close(hWait);
%% Return Outputs
if nargout
    varargout{1} = opt_rte;
    varargout{2} = global_min;
    varargout{3} = dist_history;
    varargout{4} = opt_Time;
end

end