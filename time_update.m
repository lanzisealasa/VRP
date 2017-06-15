function route=time_update(route,nodes)
%Add the shopping times for items to the 
for i=1:length(route)
    nd=route(i).nodes(2:end);
    [v,loc]=ismember(nodes(:,1),nd);
    shp_time=sum(60*nodes(find(loc),3));
    route(i).time(2:end) = route(i).time(2:end) + shp_time;
end
return
    
    
    
    

% t=trips{1};
% nd=t{1}.nodes(2:end);
% [v,loc]=ismember(nodes(:,1),nd);
% s=sum(60*nodes(find(loc),3));
% t{1}.time(2:end)+s;