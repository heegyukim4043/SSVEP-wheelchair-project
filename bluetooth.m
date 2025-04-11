classdef bluetooth < handle & matlabshared.testmeas.CustomDisplay
%BLUETOOTH Connect to Bluetooth Classic device.
%
%   b = BLUETOOTH connects to the last connected Bluetooth Classic device 
%   at the last connected channel. This only works if a connection has been 
%   made before.
%
%   b = BLUETOOTH(identifier) connects to a Bluetooth Classic device with 
%   the specified identifier at default channel 1. The identifier can be 
%   the device name or address.
%
%   b = BLUETOOTH(identifier,channel) connects to a Bluetooth Classic 
%   device with the specified identifier at the specified channel. 
%
%   b = BLUETOOTH(identifier,channel,<NAME>,<VALUE>) connects to a Bluetooth 
%   Classic device and sets additional properties using one or more optional
%   name-value pair arguments. Bluetooth properties that can be set using 
%   name-value pairs arguments are ByteOrder and Timeout.
%
%   Identify the device name or address using bluetoothlist.
%
%   BLUETOOTH methods:
%   
%   read                - Read data from the device
%   readline            - Read ASCII-terminated string data from the device 
%   write               - Write data to the device
%   writeline           - Write ASCII-terminated string data to the device
%   configureCallback   - Set the Bytes Available callback properties
%   configureTerminator - Set the read and write terminator properties
%   flush               - Clear the input and/or output buffers of the device
%
%   BLUETOOTH properties:
%   
%   Name                    - Device name
%   Address                 - Device address
%   Channel                 - Device RFCOMM server channel for connection
%   NumBytesAvailable       - Number of bytes available to be read
%   NumBytesWritten         - Number of bytes written to device
%   ByteOrder               - Sequential order in which bytes are arranged into larger numerical values
%   Timeout                 - Waiting time to complete read and write operations
%   Terminator              - Read and write terminator for the ASCII-terminated string communication
%   BytesAvailableFcn       - Function handle to be called when a Bytes Available event occurs
%   BytesAvailableFcnCount  - Number of bytes in the input buffer that triggers a Bytes Available event
%                             (Only applicable for BytesAvailableFcnMode = "byte")
%   BytesAvailableFcnMode   - Condition for firing BytesAvailableFcn callback
%   ErrorOccurredFcn        - Function handle to be called when an error event occurs
%   UserData                - Application specific data
%   
%   
%   Examples: 
%       % Connect to a Bluetooth Classic device with name HC-06 at default channel 1
%       b = bluetooth("HC-06")
%   
%       % Connect to a Bluetooth Classic device with address A886DDA44062 at default channel 1
%       b = bluetooth("A886DDA44062")
%
%       % Connect to a Bluetooth Classic device with address A886DDA44062 at channel 3
%   	b = bluetooth("A886DDA44062",3)
%
%       % Connect to a Bluetooth Classic device with little-endian byte order and timeout of 10 seconds
%   	b = bluetooth("HC-06",3,"ByteOrder","little-endian","Timeout",10)
%
%       % Connect to last connected Bluetooth Classic device
%       b = bluetooth
%   See also bluetoothlist

% Copyright 2020 The MathWorks, Inc.
    
    properties(Dependent, GetAccess = public, SetAccess = private)
        Name
        Address
        Channel
        NumBytesAvailable
        NumBytesWritten
    end
    
    properties(Dependent, Access = public)
        Terminator
        BytesAvailableFcn
        BytesAvailableFcnCount
        BytesAvailableFcnMode
        ByteOrder
        Timeout
        ErrorOccurredFcn
    end
    
    properties(Access = public)
        UserData
    end

    properties(Access = ?matlab.bluetooth.test.TestAccessor)
        Impl
    end
    
    properties(Constant, Access = private)
        PropertyGroups = ["", "", "", ""]
        PropertyNames = {["Name", "Address", "Channel", "NumBytesAvailable", "NumBytesWritten"], ...
                         ["ByteOrder", "Timeout", "Terminator"], ...
                         ["BytesAvailableFcn", "BytesAvailableFcnCount", "BytesAvailableFcnMode"], ...
                         ["ErrorOccurredFcn", "UserData"]}
    end
    
    methods(Access = public)
        function obj = bluetooth(varargin)
            narginchk(0, 6);
            try
                matlab.bluetooth.internal.validatePlatform;
                obj.Impl = matlab.bluetooth.ChannelClient(obj, varargin{:});
                % Configure custom display settings
                obj.PropertyGroupList  = obj.PropertyNames;
                obj.PropertyGroupNames = obj.PropertyGroups;
                obj.ShowMainProperties        = true;
                obj.ShowAllPropertiesInFooter = true;
                obj.ShowAllMethodsInFooter    = false;
            catch e
                throwAsCaller(e);
            end
        end
    end
    
    %% Customer visible interfaces
    methods(Access = public)
        function data = read(obj, varargin)
            %READ Read data from the Bluetooth Classic device.
            %
            %   DATA = READ(OBJ,COUNT) reads the specified number of bytes 
            %   from the Bluetooth Classic device.
            %
            %   DATA = READ(OBJ,COUNT,PRECISION) reads the specified
            %   number of values with the specified precision from the 
            %   Bluetooth Classic device. Valid precisions are "char", 
            %   "string", "uint8", "int8", "uint16", "int16", "uint32", 
            %   "int32", "uint64", "int64", "single" and "double".
            %
            %   Note: For numeric PRECISION types DATA is represented as a 
            %   DOUBLE array in row format. For char and string PRECISION 
            %   types, DATA is represented as is.
            %
            % Example:
            %      % Read 5 bytes from device
            %      data = read(b,5);
            %
            %      % Read 5 uint32 data from device
            %      data = read(b,5,"uint32");
            %
            %      % Read 5 characters from device
            %      data = read(b,5,"char");
            %
            % See also write, readline, writeline
            try
                data = read(obj.Impl, varargin{:});
            catch e
                throwAsCaller(e);
            end
        end
        
        function write(obj, varargin)
            %WRITE Write data to the Bluetooth Classic device.
            %
            %   WRITE(OBJ,DATA) writes the given data to the Bluetooth 
            %   Classic device. All data values must be representable as 
            %   an uint8.
            %
            %   WRITE(OBJ,DATA,PRECISION) writes the given data of the
            %   specified precision to the Bluetooth Classic device. Valid
            %   precisions are "char", "string", "uint8", "int8", "uint16",
            %   "int16", "uint32", "int32", "uint64", "int64", "single" and
            %   "double".
            %
            % Example:
            %      % Write an array of 5 bytes to the device.
            %      write(b,1:5);
            %
            %      % Write an array of 5 uint16 numbers to the device.
            %      write(b,301:305,"uint16");
            %
            % See also read, readline, writeline
            try
                write(obj.Impl, varargin{:});
            catch e
                throwAsCaller(e);
            end
        end
        
        function data = readline(obj)
            %READLINE Read ASCII-terminated string data from the Bluetooth
            %Classic device
            %
            %   DATA = READLINE(OBJ) reads until the first occurrence of the
            %          terminator and returns the data back as a STRING. This
            %          function waits until the terminator is reached or a
            %          timeout occurs. The returned data does not include
            %          the terminator.
            %
            % Example:
            %      % Read a string value till a terminator is reached.
            %      data = readline(b);
            %
            % See also writeline, read, write
            try
                data = readline(obj.Impl);
            catch e
                throwAsCaller(e);
            end
        end
        
        function writeline(obj, varargin)
            %WRITELINE Write ASCII data followed by a terminator to the
            %Bluetooth Classic device
            %
            %   WRITELINE(OBJ,DATA) writes the ASCII data followed by a 
            %   terminator to the Bluetooth Classic device.
            %  
            %   Note: Use configureTerminator to set the terminator.
            %
            % Example:
            %      % Write string data and add a terminator to the end
            %      % before writing to the Bluetooth Classic device.
            %      writeline(b,"helloworld");
            %
            % See also readline, read, write
            try
                writeline(obj.Impl, varargin{:});
            catch e
                throwAsCaller(e);
            end
        end
        
        function configureCallback(obj, varargin)
            %CONFIGURECALLBACK Configure the bluetooth object to call a
            %callback function when certain condition is met.
            %
            % CONFIGURECALLBACK(OBJ,"terminator",CALLBACKFCN) - Configures
            % the bluetooth object to call CALLBACKFCN whenever a terminator 
            % is available to be read.
            %
            % CONFIGURECALLBACK(OBJ,"byte",COUNT,CALLBACKFCN) - Configures 
            % the bluetooth object to call CALLBACKFCN whenever COUNT number 
            % of bytes are available to be read.
            % 
            % CONFIGURECALLBACK(OBJ,"off") - Turns off all BytesAvailable
            % callbacks.
            %
            % Example:
            %      % Configure the bluetooth object to call "mycallback" 
            %      % when the terminator is received.
            %      configureCallback(b,"terminator",@mycallback)
            %
            %      % Configure the bluetooth object to call "mycallback"
            %      % when 50 bytes of data are available to be read.
            %      configureCallback(b,"byte",50,@mycallback)
            %
            %      % Turn off the callback
            %      configureCallback(b,"off")
            %
            % See also read, write, readline, writeline, configureTerminator, flush
            try
                configureCallback(obj.Impl, varargin{:});
            catch e
                throwAsCaller(e);
            end
        end

        function configureTerminator(obj, varargin)
            %CONFIGURETERMINATOR Set the Terminator property for ASCII 
            % terminated string communication.
            %
            % CONFIGURETERMINATOR(OBJ,TERMINATOR) - Sets both read and 
            % write Terminators to the specified terminator value. 
            %
            % CONFIGURETERMINATOR(OBJ,RTERMINATOR,WTERMINATOR) - Sets the 
            % read terminator to RTERMINATOR and the write terminator to
            % WTERMINATOR. Both values are stored as a cell array in the
            % Terminator property of the bluetooth object.
            %
            % Example:
            %      % Set both read and write terminators to "CR/LF"
            %      configureTerminator(b,"CR/LF")
            %
            %      % Set read terminator to "CR" and write terminator to
            %      % ASCII value of 10
            %      configureTerminator(b,"CR",10)
            %
            % See also readline, writeline
            try
                configureTerminator(obj.Impl, varargin{:});
            catch e
                throwAsCaller(e);
            end
        end
        
        function flush(obj, varargin)
            %FLUSH Flush the input buffer, output buffer, or both.
            %
            % FLUSH(OBJ) clears both the input and output buffers.
            %
            % FLUSH(OBJ,BUFFER) clears the specified buffer.
            %
            % Example:
            %      % Flush the input buffer
            %      flush(b,"input");
            %
            %      % Flush the output buffer
            %      flush(b,"output");
            %
            %      % Flush both the input and output buffers
            %      flush(b);
            %
            % See also read, write, readline, writeline, configureCallback
            try
                flush(obj.Impl, varargin{:});
            catch e
                throwAsCaller(e);
            end
        end
    end
    
    %% Getters and Setters
    methods
        %% Read-only properties
        function value = get.Name(obj)
            value = obj.Impl.Name;
        end
        
        function value = get.Address(obj)
            value = obj.Impl.Address;
        end
        
        function value = get.Channel(obj)
            value = obj.Impl.Channel;
        end
        
        function value = get.NumBytesAvailable(obj)
            value = getProperty(obj.Impl, "NumBytesAvailable");
        end
        
        function value = get.NumBytesWritten(obj)
            value = getProperty(obj.Impl, "NumBytesWritten");
        end
        
        %% Read-Write properties
        function set.Terminator(obj, value)
            try
                setProperty(obj.Impl, "Terminator", value);
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.Terminator(obj)
            value = getProperty(obj.Impl, "Terminator");
        end
        
        function set.BytesAvailableFcn(obj, value)
            try
                setProperty(obj.Impl, "BytesAvailableFcn", value);
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.BytesAvailableFcn(obj)
            value = getProperty(obj.Impl, "BytesAvailableFcn");
        end
        
        function set.BytesAvailableFcnCount(obj, value)
            try
                setProperty(obj.Impl, "BytesAvailableFcnCount", value);
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.BytesAvailableFcnCount(obj)
            value = getProperty(obj.Impl, "BytesAvailableFcnCount");
        end
        
        function set.BytesAvailableFcnMode(obj, value)
            try
                setProperty(obj.Impl, "BytesAvailableFcnMode", value);
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.BytesAvailableFcnMode(obj)
            value = getProperty(obj.Impl, "BytesAvailableFcnMode");
        end
        
        function value = get.ByteOrder(obj)
            value = getProperty(obj.Impl, "ByteOrder");
        end
        
        function set.ByteOrder(obj, value)
            try
                setProperty(obj.Impl, "ByteOrder", value);
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.Timeout(obj)
            value = getProperty(obj.Impl, "Timeout");
        end
        
        function set.Timeout(obj, value)
            try
                setTimeout(obj.Impl, value);
                setPluginTimeout(obj.Impl, value);
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ErrorOccurredFcn(obj)
            value = getProperty(obj.Impl, "ErrorOccurredFcn");
        end
        
        function set.ErrorOccurredFcn(obj, value)
            try
                setProperty(obj.Impl, "ErrorOccurredFcn", value);
            catch e
                throwAsCaller(e);
            end
        end
    end
end

