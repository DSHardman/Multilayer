% Temperature oscillate: tetrapolar measurements simultaneously logged
% with teraterm

printer = serialport("COM7", 250000);
printer.configureTerminator(13);
pause(1);

printer.writeline('G92 Z10');
printer.writeline('M211 S0');
printer.writeline('M301 P1'); % PID parameter - attempt to stop overshoot

temps = [];
times = [];

tic
while toc < 300
    temp = gettemperature(printer)
    temps = [temps; temp];
    times = [times; datetime()];
    pause(2);
end

printer.writeline('M104 S30'); % Set target temp to 30
while toc < 600
    temp = gettemperature(printer)
    temps = [temps; temp];
    times = [times; datetime()];
    pause(2);
end

printer.writeline('M104 S40'); % Set target temp to 40
while toc < 900
    temp = gettemperature(printer)
    temps = [temps; temp];
    times = [times; datetime()];
    pause(2);
end

printer.writeline('M104 S50'); % Set target temp to 50
while toc < 1200
    temp = gettemperature(printer)
    temps = [temps; temp];
    times = [times; datetime()];
    pause(2);
end

printer.writeline('M104 S40'); % Set target temp to 40
while toc < 1500
    temp = gettemperature(printer)
    temps = [temps; temp];
    times = [times; datetime()];
    pause(2);
end

printer.writeline('M104 S30'); % Set target temp to 30
while toc < 1800
    temp = gettemperature(printer)
    temps = [temps; temp];
    times = [times; datetime()];
    pause(2);
end

printer.writeline('M104 S0'); % Cooldown
printer.writeline('M104 S30'); % Set target temp to 30
while toc < 2400
    temp = gettemperature(printer)
    temps = [temps; temp];
    times = [times; datetime()];
    pause(2);
end

save("Tests.mat", "temps", "times");

% Request & parse temperature data through Marlin
function temp = gettemperature(printer)
    try
        flush(printer);
        printer.writeline('M105');
        printer.configureTerminator("LF");
        temp = printer.readline();
        temp = char(temp);
        while (1)
            if temp(4) ~= 'T'
                temp = printer.readline();
                temp = char(temp);
            else
                printer.configureTerminator(13);
                temp = str2double(temp(6:10));
                break
            end
        end
    catch
        fprintf("Temperature Not Read\n");
        temp = 0;
    end
end