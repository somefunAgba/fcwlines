function varargout = fcwlines(norm_rgb,bolden,format,varargin)
% FCWLINES Formatted Command Window (CW) Lines Frontend for fprintf.
% Description: available formats: colored and (or) bolden
% TODO: hyperlinks.
%
% Dependencies:
%       com.mathworks packages
%       (this has been selected by Mathworks for removal in the future.)

% Change log = (dd-mm-yyyy): details
%    10-04-2021: Version 1.0
%
% Copyright: Oluwasegun Somefun (oasomefun(at)futa.edu.ng)

% Credits:
%  CPRINTF by Yair M. Altman (altmany(at)gmail.com)

% Specs.
arguments
    norm_rgb (1,3) {mustBeNumeric} = [0 0 1]
    bolden  {mustBeNumeric} = 0
    format  {mustBeText} = 'Testing fcwlines...\nMultiLine Here.\nWindows and Problems,\nAll for OS.\nSave from bugs\nEasy to Understand,\nCorrect now and in the future!\n\n'
end
%
arguments(Repeating)
    varargin
end
%
% Ouput argument
minout=0;
maxout=1;
nargoutchk(minout,maxout)
if nargout == 1
    varargout = cell(nargout,1);
end
%
% require Java to run:
if ~usejava('desktop') && (ismcc || isdeployed)
    % stop silently
    % disp("can't continue!")
    return;
end


% cws = settings;
% cws = cws.matlab.colors.commandwindow;
% % set temporary color
% jcolor = int32(norm_rgb*255);
% cws.WarningColor.TemporaryValue = jcolor;
% warning('hack:col', str);
% cws.WarningColor.TemporaryValue = cws.WarningColor.FactoryValue;

% Command Window = CW

% convert from normalized values to numeric RGB
jcolor = int32(norm_rgb*255);
% transform to java awt Color object
newcolors = java.awt.Color(jcolor(1),jcolor(2),jcolor(3));
colorstyle = sprintf('[%d,%d,%d]',jcolor);
com.mathworks.services.Prefs.setColorPref(colorstyle,newcolors); %#ok<*JAPIMATHWORKS>

% Get the current CW position
cwDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
cwlastPos = cwDoc.getLength;

% Get a handle to the CW component
mde = com.mathworks.mde.desk.MLDesktop.getInstance;
cw = mde.getClient('Command Window');
xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);

% to do: separate format into separate text arrays based on newline break
% then pass to get its instance.

format = splitlines(compose(string(format)));
% remove empty string characters, if it exists at the end of the array
if format(end) == ""
    format(end) = [];
end

status = 0;
for sd = 1:numel(format)
    str = format(sd);
    % print string.
    if bolden == 1
        str = "<strong>" + str + "</strong>\n";
    else
        str = str + "\n";
    end
    
    countStr = fprintf(2,str,varargin{:}); %#ok<NASGU>
    
    % repaint line
    drawnow;
    xCmdWndView.repaint;
    
    % Get the Document Element(s) corresponding to the latest fprintf operation
    docElement = cwDoc.getParagraphElement(cwlastPos+1);
    startOff = docElement.getStartOffset;
    cwlastPos = cwDoc.getLength;
    id = 0;
    
    if startOff > cwlastPos
        error('something wrong!')
    end
    
    
    while startOff < cwlastPos
        % set the element style according to the current style
        formatDocElems(docElement,colorstyle);
        % get the current line position
        docElement = cwDoc.getParagraphElement(cwlastPos+1);
        % compare if the start-offset has reached the last pos
        startOff = docElement.getStartOffset;
        cwlastPos = cwDoc.getLength;
        
        % to possibly prevent extended long loop times.
        id = id + 1;
        if startOff >= cwlastPos
            status = 1;
        end
        
    end
    
    % repaint line
    drawnow;
    xCmdWndView.repaint;

end

% status
if nargout == 1
    varargout{1} = status;
end
%     
% --- setformatting
% Set a CW doc element to a particular color
    function formatDocElems(docElement,colorstyle)
        %global tokens % for debug only
        global oldStyles
        % Set the last Element token to the requested style:
        % Colors:
        tokens = docElement.getAttribute('SyntaxTokens');
        if isempty(tokens)
            return
        else
            try
                styles = tokens(2);
                n = numel(styles); % disp(n)
                oldStyles{end+1} = cell(styles);
                
                jStyle = java.lang.String(colorstyle);
                
                for idx = 1:n
                    styles(idx) = jStyle;
                end
                oldStyles{end} = [oldStyles{end} cell(styles)];
            catch ME
                throw(ME)
            end
        end
        
        return;
        
    end


end



