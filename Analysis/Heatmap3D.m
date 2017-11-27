%-------------3D Heatmap fo eye gaze (x,y,distance)------------------------
VPNum = '31';
savepath = 'C:/Users/vivia/Dropbox/Project Seahaven/Tracking/Heatmap3D/Results';
Condition = 'RandomGaze';
%--------------------------------------------------------------------------
data = fopen(['3DHeatmap' Condition '_VP' VPNum '.txt']);
data = textscan(data,'%s','delimiter', '\n');
data = data{1};
data = table2array(cell2table(data));
len = int64(length(data));
x = zeros(1,len);
y = zeros(1,len);
d = zeros(1,len);
for i = 1:double(len)
    if data{i}(2)~=char('-')
        x(i) = str2num(data{i}(2:9));
        y(i) = str2num(data{i}(11:19));
        d(i) = log(str2num(data{i}(21:end-1)));
    else
        x(i)=0;y(i)=0;d(i)=210;
    end
    %sort out point of no tracking
    if d(i)>=200 || d(i)==0 || x(i)>1 ||y(i) >1 ||x(i)==0||y(i)==0
        x(i)=200;y(i)=200;d(i)=200;
    end
end
d = d(d~=200);y = y(y~=200);x = x(x~=200);
c=zeros(size(x));
for i=1:length(x)
  j=1:length(x);
  j(i)=[];
  s = sort((x(j)-x(i)).^2+(y(j)-y(i)).^2+(d(j)/5-d(i)/5).^2);
  c(i)=sum(s<0.05);
end
%remember to cut off first values when eye tracker isn't initialized yet
%scatter3(d,x,y)
t = array2table([x;y;d;c].');
t.Properties.VariableNames = {'x' 'y' 'd' 'c'};
scatter3(d,x,y,2,c)%then save the plot by hand
xlabel('Close - Far'); ylabel('Left - Right'); zlabel('Up - Down');
save(fullfile(savepath,['Heatmap3D' Condition '_' VPNum]),'t');
saveas(gcf,fullfile(savepath,['Heatmap3D' Condition '_' VPNum '.jpeg']));