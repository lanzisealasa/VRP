function [adj_mat,nodes] = graph(delFile,strFile)
% delFile = 'C:\instacart\deliveries.csv';
% strFile='C:\instacart\stores.csv';
[delivery_id, due_at, latitude, longitude, items_count]=...
    textread(delFile,'%d%s%f%f%d','delimiter','\t','headerlines',1);
adj_mat=[];
% for i=1:length(latitude)-1
%     tail=delivery_id(i+1:end);
%     head=repmat(delivery_id(i),[size(tail,1),1]);
%     ad=[head tail];
%     lat2 = latitude(i+1:end);
%     lon2 = longitude(i+1:end);
%     lat1=repmat(latitude(i),[size(lon2,1),1]);
%     lon1=repmat(longitude(i),[size(lon2,1),1]);
%     [miles]=haversine(lat1,lon1,lat2,lon2);
%     seconds = 5*60*miles;
%     ad=[ad miles seconds];
%     adj_mat = [adj_mat;ad];
%     clear ad head tail lat1 lon1 lat2 lon2 miles seconds 
% end
% 
% adj2=adj_mat;
% tmp=adj2(:,1);
% adj2(:,1)=adj2(:,2);
% adj2(:,2)=tmp;
% adj_mat=[adj_mat;adj2];
% clear ad2 tmp

d_id=delivery_id;
lat=latitude;
lon=longitude;
for i=1:length(latitude)
    d_id(i)=[];
    tail=d_id;
    head=repmat(delivery_id(i),[size(tail,1),1]);
    ad=[head tail];
    lat(i)=[];
    lon(i)=[];
    lat2 = lat;
    lon2 = lon;
    lat1=repmat(latitude(i),[size(lon2,1),1]);
    lon1=repmat(longitude(i),[size(lon2,1),1]);
    [miles]=haversine(lat1,lon1,lat2,lon2);
    seconds = 5*60*miles;
    ad=[ad miles seconds];
    adj_mat = [adj_mat;ad];
    clear ad head tail lat1 lon1 lat2 lon2 miles seconds ;
    d_id=delivery_id;
    lat=latitude;
    lon=longitude;
    
end

%strFile='C:\instacart\stores.csv';
[store_id,str_latitude,str_longitude]=...
    textread(strFile,'%d%f%f','delimiter','\t','headerlines',1);

head = repmat(49,[size(store_id,1)-1,1]);
tail = store_id(2:end);
lat1 = repmat(str_latitude(1),[size(store_id,1)-1,1]);
lon1 = repmat(str_longitude(1),[size(store_id,1)-1,1]);
lat2 = str_latitude(2:end);
lon2 = str_longitude(2:end);
[miles]=haversine(lat1,lon1,lat2,lon2);
seconds = 5*60*miles;
ad=[head tail miles seconds];
ad2=[tail head miles seconds];
adj_mat=[adj_mat;ad;ad2];

%**** Stores & Deliveries *****
tmp1=[];tmp2=[];
for i=1:length(store_id)
    head=repmat(store_id(i),[size(latitude,1),1]);
    tail=delivery_id;
    lat1=repmat(str_latitude(i),[size(latitude,1),1]);
    lon1=repmat(str_longitude(i),[size(latitude,1),1]);
    lat2=latitude;
    lon2=longitude;
    [miles]=haversine(lat1,lon1,lat2,lon2);
    seconds = 5*60*miles;
    %ad=[head tail miles seconds];
    tmp1=[tmp1;head tail miles seconds];
    tmp2=[tmp2;tail head miles seconds];    
end
adj_mat=[adj_mat;tmp1;tmp2];  
clear tmp1 tmp2;

%******* NODES *******
nd=[delivery_id;store_id];
tm_str=repmat(inf,[5,1]);
[Ys, Ms, Ds, Hs, MNs, Ss]=datevec('2014-03-13 15:15:00');
[Y, M, D, H, MN, S] = datevec(due_at);
dt=[86400,3600,60,1]*[D, H, MN, S]';
st=[86400,3600,60,1]*[Ds, Hs, MNs, Ss]';
nd_times=reshape(dt-st,[length(dt-st),1]);
nd_times=[nd_times;tm_str];
itm=[items_count;tm_str];%items
nodes=[nd nd_times itm];
return
 






  


        
        