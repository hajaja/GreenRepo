function period = funSetFrequency(option)
switch option
    case 'hourly'
        period = 1;
    case '2-hourly'
        period = 2;
    case '4-hourly'
        period = 4;
    case 'daily'
        period = 24;
    case 'weekly'
        period = 24*7;
    case 'monthly'
        period = 24*30;
    case 'annually'
        period = 24*365;
    otherwise
        disp('Error: in funSetFrequency, incorrect option = %s', option);
end