clearvars;
%Nx=Ny=512;
load('C:\Users\Lanhr\Desktop\sensor_data.mat');

speed_sound=1500; %[m/s]
fs=1/(time_array(2)-time_array(1));     %[Hz]
sensor_radius=4.5e-3;  %[m]
min_dist=speed_sound./fs; %[m]
ROI=2*sensor_radius; %[m]
ROI_points = (ROI./min_dist) +1; % all of we reconstructed point in a axis
points_step=ceil(ROI_points./Nx);
size = round(ROI_points./points_step);
image=zeros(size,size);
coordinate=zeros(size,size,2);
%xygrid=[-sensor_radius:points_step*min_dist:sensor_radius-points_step*min_dist];
xygrid=linspace(-sensor_radius,sensor_radius,size);
[coordinate(:,:,2),coordinate(:,:,1)]=meshgrid(xygrid);  %2-x,1-y  same with cart_sensor_mask
for i=1:1:num_sensor_points
    sensor_coordinate=ones(size,size,2);
    sensor_coordinate(:,:,1)=sensor_coordinate(:,:,1).*cart_sensor_mask(1,i); %y axis of sensor
    sensor_coordinate(:,:,2)=sensor_coordinate(:,:,2).*cart_sensor_mask(2,i); %x axis of sensor
    delay_dis=sqrt(((coordinate(:,:,1)-sensor_coordinate(:,:,1)).^2)+((coordinate(:,:,2)-sensor_coordinate(:,:,2)).^2));
    delay_num=round(delay_dis./speed_sound.*fs);
    delay_num=delay_num+1;
    for j =1:1:size
    image(j,:)=image(j,:)+sensor_data(i,delay_num(j,:));
    end
end
image=abs(hilbert(image));
image=image./(max(max(image)));
%image_interp=interp2(image,2);
figure;
imagesc((xygrid) * 1e3,(xygrid) * 1e3,image,[-0.8,1]);
%colormap('hot');
colormap(getColorMap);
ylabel('x-position [mm]');
xlabel('y-position [mm]');
axis image;




