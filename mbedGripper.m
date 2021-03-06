classdef mbedGripper < matlab.mixin.SetGet
    %MBEDGRIPPER MATLAB class to interact with an mBed Gripper
    %
    % obj = mbedGripper(ComPort) creates an mbedGripper object that
    % establishes communcations on the given Com Port
    % 
    % mbedGripper Methods
    %   get     - queries properties from the mbed
    %   set     - sends commands to the mbed to send properties
    % mbedGripper Properties
    %   Angle           - the angle of the gripper in degrees considering 0
    %                     is closed and ~60 is open
    %   mbedSerial      - A Serial object for communication with the mbed
    %   kP              - the Proportional PID Tuning parameter
    %   kI              - the Integral PID Tuning parameter
    %   kD              - the Derivative PID Tuning parameter
    %   error           - how close the PID controller is to the setpoint
    %   Current         - The approximate amount of current going through
    %                     the motors
    %   input           - The PWM signal that is going into the H-Bridge
    %Example:
    %   grip = mbedGripper('COM6');
    %   grip.set('Angle', 50)
    % M. Rancic, M. Kutzer, 2016
    
    %----------------------------------------------------------------------
    %% General Properties
    %----------------------------------------------------------------------
    properties(SetAccess = 'public', GetAccess = 'public')
        Angle
        mbedSerial
        kP
        kI
        kD
        error
        Current
        input
    end
    
    %----------------------------------------------------------------------
    %% get and set methods
    %----------------------------------------------------------------------
    methods(Access = 'public')
        function obj = mbedGripper(ComPort)
            obj.mbedSerial = serial(ComPort);
            set(obj.mbedSerial, 'BaudRate', 9600);
            set(obj.mbedSerial, 'DataBits', 8);
            set(obj.mbedSerial, 'Parity', 'even');
            set(obj.mbedSerial, 'StopBits', 1);
            set(obj.mbedSerial, 'Terminator', 'LF');
            fopen(obj.mbedSerial);
            Calibrate(obj);
        end
        
        function delete(obj)
            delete(instrfindall);
        end
    end
    
    methods
        function Angle = get.Angle(obj)
            flushinput(obj.mbedSerial);
            flushoutput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '1,0,0\n', 'async');
            Angle = fscanf(obj.mbedSerial, '%f');
            %Angle = obj.Angle;
        end
        
        function set.Angle(obj, value)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '0,0,%f\n', value, 'async');
        end
        
        function kP = get.kP(obj)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '1,1,0', 'async');
            kP = fscanf(obj.mbedSerial, '%f');
        end
        
        function set.kP(obj, value)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            %obj.kP = value;
            fprintf(obj.mbedSerial, '0,1,%f\n', value, 'async');
        end
        
        function kI = get.kI(obj)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '1,2,0\n', 'async');
            kI = fscanf(obj.mbedSerial, '%f');
        end
        
        function set.kI(obj, value)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '0,2,%f\n', value, 'async');
        end
        
        function kD = get.kD(obj)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '1,3,0\n', 'async');
            kD = fscanf(obj.mbedSerial, '%f');
        end
        
        function set.kD(obj, value)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '0,3,%f\n', value, 'async');
        end
        
        function error = get.error(obj)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '1,4,0\n', 'async');
            error = fscanf(obj.mbedSerial, '%f');
        end
        
        function Current = get.Current(obj)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '1,5,0\n', 'async');
            Current = fscanf(obj.mbedSerial, '%f');
        end
        
        function input = get.input(obj)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '1,6,0\n', 'async');
            input = fscanf(obj.mbedSerial, '%f');
        end
    end
    
    %% Other Functions
    methods
        function Calibrate(obj)
            flushoutput(obj.mbedSerial);
            flushinput(obj.mbedSerial);
            fprintf(obj.mbedSerial, '0,4,0\n', 'async');
        end
    end
end

