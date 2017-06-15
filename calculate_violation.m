function [tot_delay viol] = calculate_violation(route)
tot_delay=0;
viol=[];
for i=1:length(route)
    v=route(i).time(2:end) - route(i).due(2:end);
    viol=[viol;sum(abs(v))];
    tot_delay=tot_delay+sum(abs(v));
end

return 