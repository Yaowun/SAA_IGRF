clc;clear;close;

path_gif = './fig/SAA_from_IGRF_data.gif';
years = 1900:5:2020;
lat_range = [-90, 90];
lon_range = [-180, 179];

latitude = -90:1:90;
longitude = -180:1:179;
lat_l_idx = sum((latitude <= lat_range(1)) == 1);
lon_l_idx = sum((longitude <= lon_range(1)) == 1);
lat_r_idx = sum((latitude <= lat_range(2)) == 1);
lon_r_idx = sum((longitude <= lon_range(2)) == 1);

load coastlines
fig = figure('position', [0,0,800, 400]);
for year = years
    load(append('./data/B_total_', num2str(year,'%4d')), 'B_total')
    
    % plot magnetic field intensity
    pcolor(longitude(lon_l_idx:lon_r_idx), latitude(lat_l_idx:lat_r_idx), B_total(lat_l_idx:lat_r_idx, lon_l_idx:lon_r_idx))
    c = colorbar;
    if year == years(1)
        clim = caxis;
    end
    caxis(clim)
    c.Label.String = 'Total Intensity (nT)';
    shading interp
    colormap jet
    hold on
    
    % plot SAA range
    % SAA definition: Earth's magnetic field at less than 32,000 nT at sea level
    [row, col] = find(B_total < 32000);
    SAA = [col - 181, row - 90];
    plot(SAA(1:length(SAA),1), SAA(1:length(SAA),2), '.', 'color', [0, 0, .3, .5])
    
    % plot coastline
    plot(coastlon, coastlat, 'k')
    hold on
    
    title(append('Global Geomagnetic Intensity (altitude = 0 km), year = ', num2str(year,'%4d')))
    xlabel('Longitude')
    ylabel('Latitude')
    axis tight equal
    axis([lon_range(1) lon_range(2) lat_range(1) lat_range(2)])
    
    % make figure into GIF file
    drawnow
    frame = getframe(fig); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im, 256);
    if year == 1900
        imwrite(imind, cm, path_gif, 'gif', 'Loopcount', inf); 
    else
        imwrite(imind, cm, path_gif, 'gif', 'WriteMode', 'append');
    end
end