function str = int2xlcol(num)
raw = 'A':'Z';
str = raw(1+rem(num-1,26));
tmp = fix((num-1)/26);
while any(tmp)
    str = [raw(1+rem(tmp-1,26)),str]; %#ok<AGROW>
    tmp = fix((tmp-1)/26);
end
str = str;
end