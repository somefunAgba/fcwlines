classdef test_fcw < matlab.unittest.TestCase
    % test_fcw: Unit Test Suite.
    %   Failure means something is wrong with 
    %   creating the Model
    
    
    methods(TestClassSetup)
        function addToPath(testCase)
            
                        
            [this_filepath,this_filename,~]= ...
                fileparts(mfilename('fullpath')); %#ok<ASGLU>
            %rootpath = this_filepath;
            rootpath = strrep(this_filepath, [filesep 'tests'], '');
            addpath(genpath(rootpath));
            
            p = path;
            testCase.addTeardown(@path,p)
            
        end
    end
    
    methods(Test, TestTags = {'Unit'})
        % unit-test functions
        
        function testcolor(testCase)
            %testcolor
            %   colored text
            
            fprintf('\ncolored\n');
            status = fcwlines([0,0.7,0], 0);
            status = status * fcwlines([0.3,0.5,0.4], 0); 
            status = status * fcwlines([1,0.3,0.5], 0);
            status = status * fcwlines([0.5,0.3,0.8], 0);
            % check that: no exception occurs
            testCase.verifyNotEqual(status,0);            
        end
        
        function testbold(testCase)
            %testbold
            %   bold text
            
            fprintf('\nbold\n');
            status = fcwlines([0,0.7,0], 1);
            status = status * fcwlines([0.3,0.5,0.4], 1);
            status = status * fcwlines([1,0.3,0.5], 1);
            status = status * fcwlines([0.5,0.3,0.8], 1);
            % check that: no exception occurs
            testCase.verifyNotEqual(status,0);  
        end
    end
    
end

