function cs = current_status(route)
nd=[];
tm=[];
sp=[];
available=[];
for i=1:length(route)
    sp=[sp;route(i).shop];
    nd=[nd;route(i).nodes(end)];
    tm=[tm;route(i).time(end)];
    if(length(route(i).nodes)<4)
        chk=1;
        available=[available;chk];
    else
        chk=0;
        available=[available;chk];
    end
end
cs=[sp nd tm available];
return

