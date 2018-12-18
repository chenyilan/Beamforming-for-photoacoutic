function p0=beamform_das(data,fs,channel_width,n_channels,n_beams,sound_speed)
%% ===================================================================
% This employs the classic delay-and-sum method of beamforming entailing a
% single focus location defined by receive_focus [m].
% inputs:  
%    data: - RF data (transmission number, receive channel, time index)
%        fs: sampling rate [Hz]
%        channel_width: horizontal position width of receive channels 
%         [meters]
%        n_channels: the number of sensor channels [default: 128]
%        n_beams: the number of scanline [default: 256]
%        sound_speed: the speed of sound [default:1500 m/s ]
% outputs:  
%    image: beamformed data (default: 256 x 256)
% ABOUT:
%       author               - Hengrong Lan (shanghaitech university)
%       date                 - 2018.12.17
%       last update          - 2018.12.18
%% ===================================================================


im_depth=channel_width;
Nx=n_beams;
xd =linspace(-channel_width/2,channel_width/2,n_channels);


bd =linspace(-channel_width/2,channel_width/2,n_beams);
waveform_length = size(data,2);
image = zeros(Nx,n_beams);
x=linspace(0,im_depth,Nx);

for j = 1:1:n_beams

a10=(xd-bd(j));
[a11 a12]=meshgrid(a10,x);

a11=a11.^2;
a12=a12.^2;
delay = sqrt(a11 + a12)./sound_speed;   %y=x,指的是成像的深度与探头长度一致
delay_ind =round(delay.*fs);  
delay_ind = delay_ind+1;
delay_ind (delay_ind > waveform_length) =waveform_length;
scan_line = zeros(1,n_beams);

for i=1:1:n_channels
   scan_line=scan_line+data(i,delay_ind(:,i));
end
image(:,j)=scan_line;
end
image=abs(hilbert(image));
p0=image;
end