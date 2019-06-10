function systemIdent(t,vec,ref)
    
    % steady state error
    ess = abs(ref - mean(vec(end-100:end)));
    disp(['steady state error = ', num2str(ess)])
    
    % rise time
    t_rise_vec = t((vec>=ref*0.1) & (vec<=ref*0.9));
    t_rise = t_rise_vec(end) - t_rise_vec(1);
    disp(['rise time = ', num2str(t_rise)])
    
    % peak time
    over_reference = t(vec>ref);
    
    if numel(over_reference)>0
        peak = over_reference(1);
        peak_str = num2str(peak);
    else
        peak_str = 'no overshoot';
    end
    disp(['peak time = ', peak_str])
    
    % percent overshoot
    ovs = max(vec) - ref;
    percent_ovs = 100 * (max(vec) - ref) / ref;
    disp(['overshoot = ', num2str(ovs)])
    disp(['percent overshoot = ', num2str(percent_ovs)])
    
    % settling time
    ts_band = 0.05;
    ts_upper = (1 + ts_band)*ref;
    ts_lower = (1 - ts_band)*ref;
    
    if (ess <= ts_upper - ts_lower)
        ts_vec = find((vec < ts_lower) | (vec > ts_upper));
        ts = t(ts_vec(end));
    else
        ts = 999;
    end
    disp(['settling time = ', num2str(ts)])
end