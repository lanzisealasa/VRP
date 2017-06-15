function tm=find_time(r,adj_mat)
%Auxilary function for route improve
tm=[];
for i=1:size(r,1)
    t=find_length(adj_mat,r(i,1),r(i,2));
    tm=[tm,t];
end
return 