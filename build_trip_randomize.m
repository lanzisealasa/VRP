function [route unvisited_nodes trips_complete] = ...
    build_trip_randomize(adj_mat,route,unvisited_nodes)

latest_status = current_status(route);%Find Latest Status of Shoppers
%eliminate the unavailable shoppers:
id=find(latest_status(:,4)==0);
latest_status(id,:)=[];
trips_complete = 0; %flag variable to indicate the end of the current round of assaignments
sign_diff=[];
if(~isempty(latest_status))  %if any shopper available:
    %AdjMat Index of dist/time of the most urgent node to current shoppers:
    if(size(unvisited_nodes,1)>=3)
        u_rdm = randi([1 3],1,1); %Pick from first 10 available nodes.
    else
        u_rdm = 1;
    end
    indx=[];
    for c=1:size(latest_status,1)
        indx=[indx;find((adj_mat(:,2) == unvisited_nodes(u_rdm,1)...
        & (adj_mat(:,1)==latest_status(c,2))))];
    end

    
    %Calculate the best shopper to meet the time-window requirement:
    potential_time_diff = abs((latest_status(:,3)+adj_mat(indx,4)+unvisited_nodes(u_rdm,3)*60)-unvisited_nodes(u_rdm,2));
    sign_diff=[sign_diff;adj_mat(indx,4)+latest_status(:,3)+unvisited_nodes(u_rdm,3)*60-unvisited_nodes(u_rdm,2)];

    %pots -->    [shppers , Location , when can arrive at node , travel time]
    potentials = [latest_status(:,1:2) potential_time_diff adj_mat(indx,4)];
    [values, order] = sort(potentials(:,3));
    pot = potentials(order,:);
    %s_rdm = randi([1 size(pot,1)],1,1);
    s_rdm=1;
    k=pot(s_rdm,1);  %shopper ID
    %tm=pot(1,4); %Travle time from the current location to the unvisited node
    tm=find_length(adj_mat,pot(s_rdm,2),unvisited_nodes(u_rdm,1));%+unvisited_nodes(1,3)*60;
    
    %update the routes:    
    route(k).nodes=[route(k).nodes,unvisited_nodes(u_rdm,1)];
    route(k).time=[route(k).time,route(k).time(end)+tm];
    route(k).due=[route(k).due,unvisited_nodes(u_rdm,2)];
    route(k).item=[route(k).item,unvisited_nodes(u_rdm,3)];
    %route(k).diff=[route(k).diff,abs(pot(1,3))];
    
    %**** Update Unvisited Nodes:
    unvisited_nodes(u_rdm,:)=[];
else 
  trips_complete = 1;
end
 
return
