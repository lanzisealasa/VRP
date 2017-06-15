

delFile = '.\files\deliveries.csv';
strFile='.\files\stores.csv';
filename='.\files\results5.csv';
%filename2='.\files\results2.csv';

[adj_mat,nodes] = graph(delFile,strFile);
trips={};
[route unvisited_nodes visited_nodes] = intialize_routes(adj_mat,nodes);
cs = current_status(route);%Latest locations and time of shoppers
stores=[49,51,52,53,54];
df=[];   
iter=1; 
cnt=0;
tic
[route unvisited_nodes visited_nodes] = intialize_routes(adj_mat,nodes);
while(~isempty(unvisited_nodes))
    %[route unvisited_nodes trips_complete sign_diff] = build_trip(adj_mat,route,unvisited_nodes);
    [route unvisited_nodes trips_complete] = build_trip_randomize(adj_mat,route,unvisited_nodes);
    %df=[df;sign_diff];
    if(trips_complete==1)
        route=time_update(route,nodes); %*** Add shopping time
        route = route_improvement_HC(route,adj_mat); %*** Local Improvements
        [route]=neighborhodd_search(route,adj_mat,nodes);
        tt=1; 
        for t=cnt+1:length(route)+cnt
            trips{t}={route(tt)};
            tt=tt+1;
        end 
        cnt=t;
        [route] = go_to_stores(adj_mat,route,stores);
    end
end
toc

%sd=[];
%alld=[];
%for i=1:length(trips)
%    s=trips{i}{1}.time(2:end) - trips{i}{1}.due(2:end);
%    alld=[alld s];
%    sd=[sd;sum(abs(s))];
%end
%sum(abs(sd))/3600
%salld=abs(alld);
%length(salld(salld<30*60))/301

%**** Time Conversion *****
[Ys, Ms, Ds, Hs, MNs, Ss]=datevec('2014-03-13 15:15:00');
for i=1:length(trips)
    %*** Arrival****
    [day ,hour, minute, second] = sec2dhms(trips{i}{1}.time);
    Yr=repmat(Ys,[1,length(day)]);
    Mn=repmat(Ms,[1,length(day)]);
    day=day+Ds;
    hour=hour+Hs;
    minute=minute+MNs;
    arrive=datestr(datenum(Yr, Mn, day, hour, minute, second),'yyyy-mm-dd HH:MM:SS');
    trips{i}{1}.arrive = arrive;
    %*** Due ***
    [day ,hour, minute, second] = sec2dhms(trips{i}{1}.due);
    Yr=repmat(Ys,[1,length(day)]);
    Mn=repmat(Ms,[1,length(day)]);
    day=day+Ds;
    hour=hour+Hs;
    minute=minute+MNs;
    date=datestr(datenum(Yr, Mn, day, hour, minute, second),'yyyy-mm-dd HH:MM:SS');
    trips{i}{1}.ddate = date;
    %***** Trip Start *****
    [day ,hour, minute, second] = sec2dhms(trips{i}{1}.start);
    day=day+Ds;
    hour=hour+Hs;
    minute=minute+MNs;
    start=datestr(datenum(Ys, Ms, day, hour, minute, second),'yyyy-mm-dd HH:MM:SS');
    trips{i}{1}.begin = start;
end
  


fid =fopen(filename,'w');

fprintf(fid,'delivery_id,trip_id,shopper_id,trip_started_at,trip_ended_at,store_id,delivered_at\n');
fprintf(fid2,'delivery_id,trip_id,shopper_id,trip_started_at,trip_ended_at,store_id,delivered_at\n');
for i=1:length(trips)
    for j=1:length(trips{i}{1}.nodes)
        if(trips{i}{1}.nodes(j)<100)
            continue
        end
        str=[num2str(trips{i}{1}.nodes(j)),',',num2str(i),',',num2str(trips{i}{1}.shop),',',num2str(trips{i}{1}.begin),',',...
            num2str(trips{i}{1}.arrive(end,:)),',',num2str(trips{i}{1}.nodes(1)),',',num2str(trips{i}{1}.arrive(j,:))];
        %str2=[num2str(trips{i}{1}.nodes(j)),',',num2str(i),',',num2str(trips{i}{1}.shop),',',num2str(trips{i}{1}.begin),',',...
        %    num2str(trips{i}{1}.arrive(end,:)),',',num2str(trips{i}{1}.nodes(1)),',',num2str(trips{i}{1}.arrive(j,:)),',',...
        %    num2str(trips{i}{1}.ddate(j,:))];
        fprintf(fid,'%s\n',str);
        fprintf(fid2,'%s\n',str2);
    end
end

        
status = fclose(fid);

