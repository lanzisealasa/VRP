function [day ,hour, minute, second] = sec2dhms(sec)
%SEC2HMS  Convert seconds to hours, minutes and seconds.
%
%   [DAT , HOUR, MINUTE, SECOND] = SEC2DHMS(SEC) converts the number of seconds in
%   SEC into days , hours, minutes and seconds.
   day    = fix(sec/86400);     % get number of days
   sec    = sec - 86400*day;
   hour   = fix(sec/3600);      % get number of hours
   sec    = sec - 3600*hour;    % remove the hours
   minute = fix(sec/60);        % get number of minutes
   sec    = sec - 60*minute;    % remove the minutes
   second = sec;
   
return