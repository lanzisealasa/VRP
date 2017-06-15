function [route]=neighborhodd_search(route,adj_mat,nodes)

dist=[];
for i=1:length(route)
    d=route(i).time-route(i).due;
    d=sum(d);
    dist=[dist,d];
end
pos_viol_idx=find(dist>0);
neg_viol_idx=find(dist<0);
pos_viol=[]; 
neg_viol=[];
pos_idx=[];
neg_idx=[];
%Neg and Pos due_t violations:
if(~isempty(pos_viol_idx))
    [pos_viol,pos_idx]=sort(dist(pos_viol_idx),'descend');
end
if(~isempty(neg_viol_idx))
    [neg_viol,neg_idx]=sort(dist(neg_viol_idx));
end 

%What routes should exchange nodes:
route_ex=[];
if(~isempty(pos_idx) && ~isempty(neg_idx)) 
    while(~isempty(pos_idx) && ~isempty(neg_idx)) 
        route_ex=[route_ex;pos_idx(1) neg_idx(1)];
        pos_idx(1) =[];
        neg_idx(1) =[];
    end
elseif(isempty(pos_idx) && ~isempty(neg_idx)) 
    while(~isempty(neg_idx)) 
        if(length(neg_idx)==1)
            break;
        else
            route_ex=[route_ex;neg_idx(1) neg_idx(end)];
            neg_idx(1)=[]; neg_idx(end)=[];
        end
    end
elseif(~isempty(pos_idx) && isempty(neg_idx))
    while(~isempty(pos_idx)) 
        if(length(pos_idx)==1)
            break;
        else
            route_ex=[route_ex;pos_idx(1) pos_idx(end)];
            pos_idx(1)=[]; pos_idx(end)=[];
        end
    end
end

rx=route_ex;
rx(find(rx(:,1)==rx(:,2)),:)=[];
for r=1:size(rx,1)
    %Nodes to be exchanged:
    nd_ex_idx=[];
    for i=2:length(route(rx(r,1)).nodes)
        y2=2:length(route(rx(r,2)).nodes);
        y1=repmat(i,[1 length(y2)]);
        x=[y1' y2'];
        nd_ex_idx=[nd_ex_idx;x];
    end
    tmprt1 = route(rx(r,1));
    tmprt2 = route(rx(r,2));
    
    c1=[tmprt1.nodes(1:end);
        tmprt1.time(1:end);
        tmprt1.due(1:end);
        tmprt1.item(1:end)]; 
    
    c2=[tmprt2.nodes(1:end);
        tmprt2.time(1:end);
        tmprt2.due(1:end);
        tmprt2.item(1:end)];
    
    [cd1 tt] = calculate_violation(route(rx(r,1)));
    [cd2 tt] = calculate_violation(route(rx(r,2)));
    clear tt;    
    curr_best = abs(cd1)+abs(cd2);
    for j=1:size(nd_ex_idx,1)
        %exchange columns(nodes/times/due_t/itmes) of two routes:
        tmp=c1(:,nd_ex_idx(j,1));
        c1(:,nd_ex_idx(j,1)) = c2(:,nd_ex_idx(j,2));
        c2(:,nd_ex_idx(j,2)) = tmp;
        p1=c1(1,:); %new path of the first route
        p2=c2(1,:); %new path of the second route
        r1=[p1(1:end-1)' p1(2:end)']; %adjmat for new route1
        r2=[p2(1:end-1)' p2(2:end)']; %adjmat for new route2
        tm1=find_time(r1,adj_mat);
        tm2=find_time(r2,adj_mat);
        shp_time1=300+sum(c1(4,:))*60;
        shp_time2=300+sum(c2(4,:))*60;
        tm1=tm1+shp_time1;
        tm1=[c1(2,1),tm1];
        stm1=cumsum(tm1);
        
        tm2=tm2+shp_time2; 
        tm2=[c2(2,1),tm2];
        stm2=cumsum(tm2);
        
        %First new route :
        tmprt1.nodes=c1(1,:); tmprt1.time=stm1;
        tmprt1.due=c1(3,:);   tmprt1.item=c1(4,:);
        %Second new route :
        tmprt2.nodes=c2(1,:); tmprt2.time=stm2;
        tmprt2.due=c2(3,:);   tmprt2.item=c2(4,:);
        [td1 tv1] = calculate_violation(tmprt1);
        [td2 tv2] = calculate_violation(tmprt2);
        tv=abs(td1)+abs(td2); 
        if(tv<curr_best)
            %Accept the route changes
            display('Accepted')
            route(rx(r,1))=tmprt1; 
            route(rx(r,2))=tmprt2;
            curr_best=tv;   %Set new best value for violation
        else
            continue
        end
    end
end
return

    


