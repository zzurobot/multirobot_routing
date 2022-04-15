function [xy,nsalesmen,R,optroute,optbreak,n,dmat,Time,result,pop_size,num_iter] = DataGet( Question )
pop_size = 120; %种群数量
num_iter =200; %迭代次数
if Question == 1
    xy = [4 1;4 3;3 2;3 3;1 2;5 2];
    nsalesmen = 2; %机械臂数量
    R=0.65;        %2*R :安全距离
    optroute=[5 3 4 1 2 6];
    optbreak=3;
    n=length(xy);
    a = meshgrid(1:n);
    dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
    for i=1:n
        dmat(i,i)=1;
    end
    Time=round(dmat);
    load('Result1.mat')
    result = Result;
    
elseif Question == 2
    xy =  [2,7;3,7;4,7;5,7;6,7;4,6;4,5;4,4;4,3;4,2;1,5;7,5];
    nsalesmen = 2; %机械臂数量
    R=0.65;        %2*R :安全距离
    optroute=[11 8 10 9 7 1 4 5 6 2 3 12];
    optbreak=6;
    n=length(xy);
    a = meshgrid(1:n);
    dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
    for i=1:n
        dmat(i,i)=1;
    end
    for i=1:n
        for j=1:n
            if dmat(i,j)>=1&&dmat(i,j)<1000
                dmat(i,j)=dmat(i,j)/(1.4142*1.4);
            end
        end
    end %离散归一化，均为单位时间窗的整数倍
    Time=round(dmat);
    load('Result2.mat')
    result = Result;
%     for i = 1:n
%         for j = 1:n
%             if i~=j
%                 result{i,j} = [ceil(sum(result{i,j})/5) - 20
%                     ceil(sum(result{i,j})/5) + 10
%                     ceil(sum(result{i,j})/5) + 5
%                     ceil(sum(result{i,j})/5) + 8
%                     ceil(sum(result{i,j})/5) - 3];
%             end
%         end
%     end
%     for i = 1:n
%         for j = 1:n
%             if i~=j
%                 result{i,j} = ceil(result{i,j}/2.90);
%             end
%         end
%     end
    
elseif Question == 3
    xy=[
        4.3874    7.5127
        3.8156    2.5510
        7.6552    5.0596
        7.9520    6.9908
        1.8687    8.9090
        4.8976    9.5929
        4.4559    5.4722
        6.4631    1.3862
        7.0936    1.4929
        7.5469    2.5751
        1          5
        10         5
        ]; % round R=0.9;
    nsalesmen = 2; %机械臂数量
    R=0.9;        %2*R :安全距离
    optroute=[11	7	5	6	1	4	3	2	8	9	10	12];
    optbreak=5;
    n=length(xy);
    a = meshgrid(1:n);
    dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
    for i=1:n
        dmat(i,i)=1;
    end
    Time=round(dmat);
    load('Result3.mat')
    result = Result;
    result(:,11:20)=[];
    result(11:20,:)=[];
elseif Question == 4
    xy=[
        4.3874    7.5127
        3.8156    2.5510
        7.6552    5.0596
        7.9520    6.9908
        1.8687    8.9090
        4.8976    9.5929
        4.4559    5.4722
        6.4631    1.3862
        7.0936    1.4929
        7.5469    2.5751
        2.7603    8.4072
        6.7970    2.5428
        6.5510    8.1428
        1.6261    2.4352
        1.1900    9.2926
        4.9836    3.4998
        9.5974    1.9660
        3.4039    2.5108
        5.8527    6.1604
        2.2381    4.7329
        1          5
        10         5
        ]; % round R=0.9;
    nsalesmen = 2; %机械臂数量
    R=0.9;        %2*R :安全距离
    optroute=[21	20	14	7	11	6	1	5	15	3	4	13	19	16	18	2	8	9	12	10	17	22];
    optbreak=9;
    n=length(xy);
    a = meshgrid(1:n);
    dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
    for i=1:n
        dmat(i,i)=1;
    end
    Time=round(dmat);
    load('Result3.mat')
    result = Result;
elseif Question == 5
    xy=[5.3348,0.3535;2.4722,8.3991;
        6.5411,9.0246;3.2053,3.8359;
        2.9517,3.5696;1.9498,8.5107;
        8.8136,5.3167;3.8467,1.3860;
        8.2018,9.0261;5.4366,7.6832;
        4.6766,2.9301;7.0225,5.8083;
        4.8799,5.9226;4.9748,9.8266;
        7.3052,3.9087;7.6894,7.7067;
        8.5120,6.5980;3.4262,2.7086;
        0.1681,5.0686;4.6768,7.4770;
        0           3
        0           8
        10          3
        10          8]; % ceil  R=0.9;
    nsalesmen = 4; %机械臂数量
    R=0.9;        %2*R :安全距离
    optroute=[21	19	13	4	5	22	6	14	3	10	20	2	23	1	8	18	11	15	24	16	9	7	17	12];
    optbreak=[5 12 18];
    n=length(xy);
    a = meshgrid(1:n);
    dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
    for i=1:n
        dmat(i,i)=1;
    end
    Time=ceil(dmat);
    load('Result4.mat')
    result = Result;
    result(:,21:40)=[];
    result(21:40,:)=[];
elseif Question == 6
    xy=[5.3348,0.3535;2.4722,8.3991;
        6.5411,9.0246;3.2053,3.8359;
        2.9517,3.5696;1.9498,8.5107;
        8.8136,5.3167;3.8467,1.3860;
        8.2018,9.0261;5.4366,7.6832;
        4.6766,2.9301;7.0225,5.8083;
        4.8799,5.9226;4.9748,9.8266;
        7.3052,3.9087;7.6894,7.7067;
        8.5120,6.5980;3.4262,2.7086;
        0.1681,5.0686;4.6768,7.4770;
        8.2284,7.4515;7.6968,2.8623;
        7.5594,4.3483;7.0938,3.9578;
        1.4424,6.5176;3.1551,9.1063;
        9.2202,6.1466;3.0351,5.5635;
        3.9512,4.2672;2.5352,6.6222;
        0           3
        0           8
        10          3
        10          8]; % ceil  R=0.9;
    nsalesmen = 4; %机械臂数量
    R=0.9;        %2*R :安全距离
    optroute=[31 1 5 11 12 15 18 23 ...
        32  25 28 6 30 29 4 19 26 ...
        33  24 10 13 17 21 27 7 22 ...
        34 2 9 16 3 14 20 8
        ];
    optbreak=[8 17 26];
    n=length(xy);
    a = meshgrid(1:n);
    dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
    for i=1:n
        dmat(i,i)=1;
    end
    Time=ceil(dmat);
    load('Result4.mat')
    result = Result;
    result(:,31:40)=[];
    result(31:40,:)=[];
elseif Question == 7
    xy=[5.3348,0.3535;2.4722,8.3991;
        6.5411,9.0246;3.2053,3.8359;
        2.9517,3.5696;1.9498,8.5107;
        8.8136,5.3167;3.8467,1.3860;
        8.2018,9.0261;5.4366,7.6832;
        4.6766,2.9301;7.0225,5.8083;
        4.8799,5.9226;4.9748,9.8266;
        7.3052,3.9087;7.6894,7.7067;
        8.5120,6.5980;3.4262,2.7086;
        0.1681,5.0686;4.6768,7.4770;
        8.2284,7.4515;7.6968,2.8623;
        7.5594,4.3483;7.0938,3.9578;
        1.4424,6.5176;3.1551,9.1063;
        9.2202,6.1466;3.0351,5.5635;
        3.9512,4.2672;2.5352,6.6222;
        7.4084,3.6453;9.4882,2.4798;
        7.7711,5.3626;5.1761,5.1912;
        2.4129,2.4494;1.1677,5.0481;
        3.3493,8.6338;1.1069,2.3556;
        2.0752,8.2453;6.7484,1.8297
        0           3
        0           8
        10          3
        10          8]; % ceil  R=0.9;
    nsalesmen = 4; %机械臂数量
    R=0.9;        %2*R :安全距离
    optroute=[41	19	36	2	39	29	11	35	38	...
        44 9	3	10	20	16	21	17	12	33	7	27	...
        43 32	22	40	1	8	18	5	4	24	15	31	23	...
        42	6	14	26	37	13	34	28	30	25
        ];
    optbreak=[9 21 34];
    n=length(xy);
    a = meshgrid(1:n);
    dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
    for i=1:n
        dmat(i,i)=1;
    end
    Time=ceil(dmat);
    load('Result4.mat')
    result = Result;
end

end

