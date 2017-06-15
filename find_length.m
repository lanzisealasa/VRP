function link = find_length(adj_mat,head,tail)
%Searches graph to find the time between head and tail nodes:
link = adj_mat(adj_mat(:,1)==head & adj_mat(:,2)==tail,4);
return