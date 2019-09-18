% color_plot(x, y, condition, color)
% Colors the background according to the given condition.
% Condition must be built with the x and y arguments only.
% example 1: color_plot(x, y, y>0.7, 'm')
% example 2: color_plot(x, y, y>=0 & y<=0.7, [0.5 0.5 0.5])

function color_plot(x, y, condition, color)
    y_min = min(y); h = max(y)-min(y);

    color_x = ones(size(x))*119;
    color_x(condition) = 'y';

    change_idx = [1, find(abs(diff(color_x))>0)+1, numel(x)];
    change_clr = color_x(change_idx);
    change_x = x(change_idx);

    for i=1:numel(change_idx)-1
        if change_clr(i) ~= 119
            rectangle('Position',[change_x(i), y_min, change_x(i+1)-change_x(i), h],'FaceColor', color, 'LineStyle', 'none'); hold on;
        end
    end
end