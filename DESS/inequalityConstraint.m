function [ci,ci_grad] = inequalityConstraint(x)
%   inequalityConstraint: (examples/ex1)
%       Encodes a simple 2-variable inequality constraint and its gradient.  
%       
%       GRANSO's convention is that the inequality constraints must be less
%       than or equal to zero to be satisfied.  For equality constraints,
%       GRANSO's convention is that they must be equal to zero.
%
%       GRANSO requires that gradients are column vectors.  For example, if
%       there was a second inequality constraint, its gradient would be
%       stored in the 2nd column of ci_grad.
%
%   USAGE:
%       [ci,ci_grad] = inequalityConstraint(x);
% 
%   INPUT:
%       x           optimization variables
%                   real-valued column vector, 2 by 1 
%   
%   OUTPUT:
%       ci          values of the inequality constraints at x.
%                   real-valued column vector, 2 by 1, where the jth entry 
%                   is the value of jth constraint
%                 
%       ci_grad     gradient of the inequality constraint at x.
%                   real-valued matrix, 2 by 2, where the jth column is the
%                   gradient of the jth constraint
% 
%
%   For comments/bug reports, please visit the GRANSO GitLab webpage:
%   https://gitlab.com/timmitchell/GRANSO
%
%   examples/ex1/inequalityConstraint.m introduced in GRANSO Version 1.5.
%
% =========================================================================
% |  GRANSO: GRadient-based Algorithm for Non-Smooth Optimization         |
% |  Copyright (C) 2016 Tim Mitchell                                      |
% |                                                                       |
% |  This file is part of GRANSO.                                         |
% |                                                                       |
% |  GRANSO is free software: you can redistribute it and/or modify       |
% |  it under the terms of the GNU Affero General Public License as       |
% |  published by the Free Software Foundation, either version 3 of       |
% |  the License, or (at your option) any later version.                  |
% |                                                                       |
% |  GRANSO is distributed in the hope that it will be useful,            |
% |  but WITHOUT ANY WARRANTY; without even the implied warranty of       |
% |  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        |
% |  GNU Affero General Public License for more details.                  |
% |                                                                       |
% |  You should have received a copy of the GNU Affero General Public     |
% |  License along with this program.  If not, see                        |
% |  <http://www.gnu.org/licenses/agpl.html>.                             |
% =========================================================================

    % INEQUALITY CONSTRAINTS
    [~,ci,~] = cec20_func(x, 3);
    
    % GRADIENTS OF THE TWO INEQUALITY CONSTRAINTS
       x1 = x(1); x2 = x(2); x3 = x(3); x4 = x(4); x5 = x(5); x6 = x(6); x7 = x(7);
    B = [                              (0.0059553571*x6^2) - (0.1175625*x6) - 1,                                                                      0,                0.88392857,                                                                                        0,                                   0,                        (0.0059553571*2*x1*x6) - (0.1175625*x1),                                           0;
          (0.1303533*x6) - (0.0066033*x6^2) + 1.1088,                                                                      0,                                               -1,                                                                                        0,                                   0, (0.1303533*x1) - (0.0066033*2*x1*x6),                                           0;
                                                                                              0,                                                                      0,                                                0,                                                        -56.596669,       172.39878,               (6.66173269*2*x6) - 191.20592,                                           0;
                                                                                              0,                                                                      0,                                                0,                                                                               0.32175,                                  -1,                                                        1.08702 - (0.03762*2*x6),                                           0;
                                                                                              0, 2462.3121 - (25.125634*x4), (0.006198*x4*x7) - x4, (0.006198*x3*x7) - x3 - (25.125634*x2),                                   0,                                                                                    0, (0.006198*x3*x4);
                                                                                              0,                                                       5000*x4 - 489510,     (161.18996*x4) - x4*x7,                                   5000*x2 + (161.18996*x3) - x3*x7,                                   0,                                                                                    0,                                      -x3*x4;
                                                                                              0,                                                                      0,                                                0,                                                                                        0,                                  -1,                                                                                    0,                                      33/100;
                                                                                              0,                                                                      0,                                                0,                                                                                        0, 0.022556,                                                                                    0,       -0.007595;
                                                                                        -0.0005,                                                                      0,                                        0.00061,                                                                                        0,                                   0,                                                                                    0,                                           0;
                                                              0.819672,                                                                      0,                                               -1,                                                                                        0,                                   0,                                                                                    0,                                           0;
                                                                                              0,                                                         24500 - 250*x4,                                              -x4,                                                                            - 250*x2 - x3,                                   0,                                                                                    0,                                           0;
                                                                                              0,                           (1020.4082*x4) - 100000,           (1.2244898*x4),             (1020.4082*x2) + (1.2244898*x3),                                   0,                                                                                    0,                                           0;
                                                                               (6.25*x6) + 6.25,                                                                      0,                                            -7.625,                                                                                        0,                                   0,                                                                            (6.25*x1),                                           0;
                                                                                       - x6 - 1,                                                                      0,                                            1.22,                                                                                        0,                                   0,                                                                                  -x1,                                           0];
 
   C = -2*x(8:14);
   D = 2*x(15:21);
   E = 2*x(22:35);
   ci_grad = [ B  zeros(14,7) zeros(14,7) diag(E);
         eye(7) diag(C) zeros(7)   zeros(7,14);
         eye(7) zeros(7) diag(D)   zeros(7,14)];
     
    
end