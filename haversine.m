function [miles]=haversine(lat1,lon1,lat2,lon2)
% HAVERSINE_FORMULA.AWK - converted from AWK 
    dlat = radians(lat2-lat1);
    dlon = radians(lon2-lon1);
    lat1 = radians(lat1);
    lat2 = radians(lat2);
    a = (sin(dlat./2)).^2 + cos(lat1) .* cos(lat2) .* (sin(dlon./2)).^2;
    c = 2 .* asin(sqrt(a));
    miles = 3963 * c; 
end




