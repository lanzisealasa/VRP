function [route unvisited_nodes visited_nodes] = intialize_routes(adj_mat,nodes)
route=struct;
stores=[49,51,52,53,54];
s_id=[49,49,51,51,52,52,53,53,54,54];
[values, order] = sort(nodes(:,2));
sorted_nodes = nodes(order,:);
unvisited_nodes=sorted_nodes(sorted_nodes(:,1)>100,:);
visited_nodes=[];
%start='2014-03-13 15:15:00'
%initiate trips/routes
for i=1:10
    route(i).shop=i;
    route(i).nodes=s_id(i);
    route(i).time=0;
    route(i).due=0;
    route(i).item = 0;
    route(i).start=-15*60;
    %route(i).diff=0;
    
    route(i).nodes=[route(i).nodes,unvisited_nodes(i,1)];
    base_shp_time = 5*60;
    route(i).time=[route(i).time,route(i).time(end)+...
        find_length(adj_mat,s_id(i),unvisited_nodes(i,1))+base_shp_time]; 
    link_time=find_length(adj_mat,s_id(i),unvisited_nodes(i,1));
    route(i).due=[route(i).due,unvisited_nodes(i,2)];
    route(i).item=[route(i).item,unvisited_nodes(i,3)];
    %route(i).diff=[route(i).diff,abs(unvisited_nodes(i,2)-link_time)]; 
    unvisited_nodes(i,:)=[];
end
return

%============
% s = struct;
% for i=1:10
%     s(i).shopper_id=i;
%     s(i).trip_id =[];
%     s(i).trip = {};
%     s(i).store_id = s_id(i) ;
% end

% visited_nodes=[];
% unvisited_nodes=[];