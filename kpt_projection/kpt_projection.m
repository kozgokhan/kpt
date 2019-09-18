function kpt_projection(x, y, projecting_time)
    
    project_x = x(end):round(mean(diff(x))):projecting_time;
    if project_x(end)~=projecting_time
        project_x = [project_x, projecting_time];
    end
    
    slope = (y(end)-y(1))/(x(end)-x(1));
    b = y(end) - x(end)*slope;
    project_y = slope*project_x + b;
    
    plot([x(1), project_x(1)], [y(1), project_y(1)], '--');
    hold on
    plot(x, y, '-ob', 'LineWidth', 1);
    hold on
    plot(project_x, project_y, '-or', 'LineWidth', 1);
    hold on
    plot(x(end), y(end),'o','MarkerSize',7,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6])
    hold on
    plot(project_x(end),project_y(end),'o','MarkerSize',7,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6])
    grid on
    grid minor
end