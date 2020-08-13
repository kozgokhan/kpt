connectivity=get_param(gcb,'PortConnectivity');
subsysName = get_param(connectivity.SrcBlock,'Name');
portNum = connectivity.SrcPort;

% subsysPorts=get_param(connectivity.SrcBlock,'PortHandles')
% subsysOutport = subsysPorts.Outport
% get_param(subsysOutport,'Name')

outports = find_system([gcs,'/',subsysName],'BlockType','Outport');

newName=get_param(outports(portNum + 1),'Name');
set_param(gcb,'Name',newName{1});