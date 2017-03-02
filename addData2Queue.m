function addData2Queue(src,event,data,events,cnt)

if mod(cnt,2) 
    queueOutputData(src,[data(1,:); events]');
else
    queueOutputData(src,[data(2,:); events]');
end
cnt = cnt + 1;
