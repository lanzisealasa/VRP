function [route] = go_to_stores(adj_mat,route,stores)

latest_status = current_status(route);%Find Where shoppers are
record_str=[];
for i=1:size(latest_status,1)
    idx=find(adj_mat(:,1)==latest_status(i,2) & ismember(adj_mat(:,2),stores));
    [v,x]=min(adj_mat(idx,4));
    record_str=[record_str;latest_status(i,1)...
        latest_status(i,2) adj_mat(idx(x),2) adj_mat(idx(x),4)+latest_status(i,3)];
end 

%*** restart the routes:
clear route;
route= struct;
for i=1:10
    route(i).shop=record_str(i,1);
    route(i).nodes=record_str(i,3);
    route(i).time=record_str(i,4)+5*60;
    route(i).due=0;
    route(i).item=0;
    route(i).start=latest_status(i,3);
    %route(i).diff=0;
end

    
%     route(i).nodes=[route(i).nodes,unvisited_nodes(i,1)];
%     route(i).time=[route(i).time,...
%         route(i).time(end)+find_length(adj_mat,s_id(i),unvisited_nodes(i,1))];
%     %route(i).time=[route(i).time,find_length(adj_mat,s_id(i),unvisited_nodes(i,1))];  
%     link_time=find_length(adj_mat,s_id(i),unvisited_nodes(i,1));
%     route(i).diff=[route(i).diff,abs(unvisited_nodes(i,2)-link_time)]; 

    
    





