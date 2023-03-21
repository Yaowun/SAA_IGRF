clc;clear;

altitude = 0;
years = 1900:5:2020;

igrf_ver = 13;
latitude = -90:1:90;
longitude = -180:1:179;
lat_idx_adjust = sum((latitude <= 0) == 1);
lon_idx_adjust = sum((longitude <= 0) == 1);
B_total = zeros(length(latitude), length(longitude));
for year = years
    for lat = latitude
        for lon = longitude
            B = igrfmagm(altitude, lat, lon, year, igrf_ver);
            B(isnan(B)) = 0;
            B_total(lat + lat_idx_adjust,lon + lon_idx_adjust) = sqrt(B(1)^2 + B(2)^2 + B(3)^2);
        end
    end
    save(append('./data/B_total_', num2str(year,'%4d')), 'B_total')
    fprintf('"B_total_%4d" data saving completed.\n', year)
end