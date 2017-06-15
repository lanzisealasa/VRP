function route = route_improvement_HC(route,adj_mat)
[tot_delay viol] = calculate_violation(route); %original route before exchange!
% curr_best = tot_delay;
tmpviol=[];
for i=1:length(route)
    y=2:length(route(i).nodes);
    x=[y(1:end-1)' y(2:end)'];
    tmprt = route(i);
    %c=[tmprt.nodes(2:end);tmprt.time(2:end);tmprt.due(2:end);tmprt.item(2:end)];
    c=[tmprt.nodes(1:end);tmprt.time(1:end);...
       tmprt.due(1:end);tmprt.item(1:end)];
    curr_best = viol(i);
    for j=1:size(x,1)
        %exchange columns(nodes/times/due_t/itmes)
        tmp=c(:,x(j,1));
        c(:,x(j,1)) = c(:,x(j,2));
        c(:,x(j,2)) = tmp;
        p=c(1,:); %path
        r=[p(1:end-1)' p(2:end)'];
        tm=find_time(r,adj_mat);
        shp_time=300+sum(c(4,:))*60;
        tm=tm+shp_time;
        tm=[c(2,1),tm];
        stm=cumsum(tm);
        tmprt.nodes=c(1,:); tmprt.time=stm;
        tmprt.due=c(3,:);   tmprt.item=c(4,:);
        [td tv] = calculate_violation(tmprt);
        if(tv<curr_best)
            route(i)=tmprt;
        else
            continue
        end
    end
end
return
            
        
        
        
        
        
        
        
return;

        
        
    
    
        
        
        
        
        
        
    