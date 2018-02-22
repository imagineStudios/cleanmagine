classdef testCData < matlab.unittest.TestCase
   
   methods (Test)
            
      function testNativeCoordinates(testCase)
         % Data m x n x o ==> y X x X z
         hData = CData(1, zeros(3, 2, 4), 'Type', 'scalar');
         testCase.verifyEqual(hData.getCoverage_xyz(), [1 2; 1 3; 1 4]);
      end
      
      function testCorCoordinates(testCase)
         % Data m x n x o ==> -z X x X y
         hData = CData(1, zeros(4, 2, 3), 'Orientation', 'Cor', 'Origin', [20 0 10], 'Resolution', [3 1 2], 'Type', 'scalar');
         testCase.verifyEqual(hData.getCoverage_xyz(), [0 1; 10 14; 20 11]);
      end
      
      function testSagCoordinates(testCase)
         % Data m x n x o ==> -z X y X x
         hData = CData(1, zeros(4, 3, 2), 'Orientation', 'Sag', 'Origin', [20 10 0], 'Resolution', [3 2 1], 'Type', 'scalar');
         testCase.verifyEqual(hData.getCoverage_xyz(), [0 1; 10 14; 20 11]);
      end
      
      function testTraCoordinates(testCase)
         % Data m x n x o ==> y X x X z
         hData = CData(1, zeros(3, 2, 4), 'Orientation', 'Tra', 'Origin', [10 0 20], 'Resolution', [2 1 3], 'Type', 'scalar');
         testCase.verifyEqual(hData.getCoverage_xyz(), [0 1; 10 14; 20 29]);
      end
      
   end
   
end