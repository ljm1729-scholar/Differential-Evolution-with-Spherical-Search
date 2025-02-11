function opts = gransoOptionsAdvanced(varargin)
%   gransoOptionsAdvanced:
%       Process user options struct for granso.m.  If user_opts is [] or
%       not provided, returned opts will be GRANSO's default parameters.
%       Standard or advanced options may be set.
%
%       Type:
%       >> help gransoOptions
%       to see documentation for the standard user options.
%   
%   USAGE:
%       opts = gransoOptionsAdvanced(n);
%       opts = gransoOptionsAdvanced(n,user_opts);
%
%   INPUT:
%       n           Number of variables being optimized.
%
%       user_opts   Struct of settable algorithm parameters.  No fields are 
%                   required, irrelevant fields are ignored, and user_opts 
%                   may be given as [].
%
%   OUTPUT:
%       opts        Struct of all tunable user parameters for GRANSO.
%                   If a field is provided in user_opts, then the user's 
%                   value is checked to whether or not it is a valid value, 
%                   and if so, it is set in opts.  Otherwise, an error is 
%                   thrown.  If a field is not provided in user_opts, opts
%                   will contain the field with GRANSO's default value. 
%
%   ADVANCED PARAMETERS
%
%   SEARCH DIRECTION STRATEGIES
%   If a step cannot be taken with the current search direction (e.g.
%   computed an invalid search direction or the line search failed on a
%   valid search direction), GRANSO may attempt up to four optional 
%   fallback strategies to try to continue making progress from the current
%   iterate.  The strategies are as follows and are attempted in order:
%       
%       0. BFGS-SQP steering 
%          - default for constrained problems
%          - irrelevant for unconstrained problems
%       1. BFGS-SQP steering with BFGS's inverse Hessian approximation
%          replaced by the identity. If strategy #0 failed because quadprog
%          failed on the QPs, this "steepest descent" version of the 
%          steering QPs may be easier to solve.
%          - irrelevant for unconstrained problems
%       2. Standard BFGS update on penalty/objective function, no steering
%          - default for unconstrained problems
%       3. Steepest descent on penalty/objective function, no steering
%       4. Randomly generated search direction 
% 
%   .min_fallback_level             [integer in {0,...,4} | {0}]
%       Min number of strategy to be employed
%       NOTE: fallback levels 0 and 1 are only relevant for constrained
%       problems.  
% 
%   .max_fallback_level             [integer in {0,...,4} | {3}]
%       Max number of strategy to be employed (>= min_fallback_level)
%       NOTE: fallback levels 0 and 1 are only relevant for constrained
%       problems.  
%
%   .max_random_attempts            [integer > 0 | {5}]
%       If max_fallback_level is 4, this is the number of randomly
%       generated directions to attempt if all previous strategies fail on 
%       any single iteration
%
%   STEERING PARAMETERS (only relevant for constrained problems)
%   .steering_l1_model              [logical | {true}]
%       Determines whether or not the one norm (the standard choice) or the
%       infinity norm is used for the total violation measure in steering, 
%       which in turn affects the predicted violation reduction.  
%       
%   .steering_ineq_margin           [real >= 0 | {1e-6}] 
%       Sets the margin of feasibility for problems that only have 
%       inequality constraints.  For such problems, steering can be 
%       adaptively enabled instead of applied at every iteration.  When 
%       the inequality constraints are all at least steering_ineq_margin 
%       away from being active, steering will be disabled.  Setting
%       steering_ineq_margin to zero means that steering will only be 
%       applied when one or more inequality constraints are active ( >= 0)  
%       while setting steering_ineq_margin to inf means that steering will
%       be applied on every iteration.
%       NOTE: this parameter has no effect if equality constraints are 
%       present and steering will always be enabled every iteration.
%
%   .steering_maxit                 [integer > 0 | {10}]
%       If the default steering direction is not predicted to adequately
%       promote progress towards feasibility, steering_maxit is the max
%       number of times to iteratively lower the penalty parameter and
%       recompute a hopefully better search direction which does adequately
%       promote progress towards feasibility.  Setting this to higher
%       values may more aggressively lower the penalty parameter per 
%       GRANSO iteration.
%       
%   .steering_c_viol                [real in (0,1) | {0.1}]
%       Determines the fraction of predicted violation reduction for a 
%       search direction to be considered as adequately promoting progress
%       towards feasibility.  If a search direction's predicted violation 
%       reduction does not meet this target, the penalty parameter will be 
%       lowered and a new search direction will be computed.  Setting this 
%       to higher values may more aggressively lower the penalty parameter 
%       per GRANSO iteration.
%
%   .steering_c_mu                  [real in (0,1) | {0.9}] 
%       When steering lowers the penalty parameter in order to compute a 
%       a search direction which promotes progress towards feasibility, it 
%       does by progessively lowering the penalty parameter by factors of 
%       steering_c_mu.  For any given GRANSO iteration, the penalty
%       parameter can be shrunk up to a factor of steering_c_mu to the 
%       power of steering_maxit.  Setting this to lower values may more 
%       aggressively lower the penalty parameter per GRANSO iteration.
%
%   QP PARAMETERS
%   .regularize_threshold           [real >= 1 | {inf}]
%       Ill-conditioning of the BFGS inverse Hessian approximations H may 
%       cause quadprog to have difficulty in solving either the steering or 
%       termination QPs.  The BFGS inverse Hessian approximations H can be 
%       optionally regularized by limiting their condition numbers to 
%       regularize_threshold.  Note that this regularization is only 
%       applied to the H matrices appearing in the QPs; the evolving BFGS 
%       inverse Hessian approximation itself is never regularized. 
%       NOTE: setting opts.regularize_threshold to inf disables any
%       regularization (and thus disables even computing the condition
%       number of H).
%
%   .regularize_max_eigenvalues     [logical | {false}]
%       If opts.regularize_threshold < inf, then GRANSO's default strategy
%       to regularize the BFGS inverse Hessian approximation H is done by 
%       raising the smallest magnitude eigenvalues such that the condition 
%       number of the regularized version of H never exceeds 
%       opts.regularize_threshold.  This default regularization should also 
%       help ensure that regularized version of H is numerically positive 
%       definite, since H may have tiny eigenvalues and in practice, these 
%       may have the wrong sign numerically (negative), particularly on 
%       nonsmooth problems.  Alternatively, by setting this option to true, 
%       GRANSO will instead apply regularization by lowering the largest 
%       eigenvalues of H but note that this mode does not attempt to 
%       maintain numerical positive definiteness.  Also, if an eigenvalue 
%       of H is exactly zero, this mode will instead resort to raising the 
%       smallest eigenvalues of H on that particular iteration of GRANSO.
%
%   .quadprog_opts                  [struct | {[]}]
%       Struct of options to pass to underlying QP quadprog solver, with 
%       one additional parameter for selectively suppressing warning
%       messages that the QP solver may produce: 
%       .suppress_warnings          [logical | {true}]
%
%   LINE SEARCH PARAMETERS
%   .wolfe1                         [real in (0,0.5] | {1e-4}]
%       First weak Wolfe line search parameter, ensuring sufficient 
%       decrease of the objective/penalty.  
% 
%   .wolfe2                         [real in [wolfe1,1) | {0.5}]
%       Second weak Wolfe line search parameter, ensuring algebraic 
%       increase in projected gradient.
%
%   .linesearch_nondescent_maxit    [integer >= 0 | {0}]
%       If the computed direction is not numerically a descent direction, 
%       the line search can still be optionally attempted to see if it gets
%       "lucky", using up to  linesearch_nondescent_maxit evaluations of 
%       the penalty/objective function (since there may be numerical issues 
%       in calculating whether it truly is a descent direction or not).
%
%   .linesearch_reattempts          [integer > 0 | {10}]
%       If the line search fails to bracket a minimizer, this may be an
%       indication that the objective function is unbounded below.  For
%       constrained problems, it may be that the objective is only unbouded 
%       below off the feasible set, in which case lower values of
%       the penalty parameter mu may be necessary for GRANSO to find the
%       feasible region.  For constrained problems, if the line search 
%       fails to bracket a minimizer, GRANSO will reattempt the line search 
%       with progressively lower values of mu, up to linesearch_reattempts 
%       times.  See opts.linesearch_c_mu, opts.linesearch_reattempts_x0, 
%       and opts.linesearch_c_mu_x0.
%       NOTE: this option is irrelevant for unconstrained problems.
%
%   .linesearch_reattempts_x0       [integer > 0 | {30}]
%       The same as linesearch_reattempts but applies only to the first
%       iteration, where it may beneficial to be more aggressive in
%       lowering the penalty parameter for line search reattempts.  
%       NOTE: this option is irrelevant for unconstrained problems.
%
%   .linesearch_c_mu                [real in (0,1) | 0.5]
%       If the line search fails to bracket a minimizer for a constrained 
%       problem, and linesearch_reattempts > 0, each line search reattempt
%       will try a progressively smaller penalty parameter, shrinking it by 
%       another factor of linesearch_c_mu on each reattempt.  See 
%       opts.linesearch_reattempts, opts.linesearch_reattempts_x0, and 
%       opts.linesearch_c_mu_x0.
%       NOTE: this option is irrelevant for unconstrained problems.
%
%   .linesearch_c_mu_x0             [real in (0,1) | 0.5]
%       The same as linesearch_c_mu but applies only to the first
%       iteration, where it may beneficial to be more aggressive in
%       lowering the penalty parameter for line search reattempts.
%       NOTE: this option is irrelevant for unconstrained problems.
% 
%   END OF ADVANCED PARAMETERS
% 
%   See also granso, gransoOptions, and makeHaltLogFunctions.
%
%
%   If you publish work that uses or refers to GRANSO, please cite the 
%   following paper: 
%
%   [1] Frank E. Curtis, Tim Mitchell, and Michael L. Overton 
%       A BFGS-SQP method for nonsmooth, nonconvex, constrained 
%       optimization and its evaluation using relative minimization 
%       profiles, Optimization Methods and Software, 32(1):148-181, 2017.
%       Available at https://dx.doi.org/10.1080/10556788.2016.1208749
%
%   For comments/bug reports, please visit the GRANSO GitLab webpage:
%   https://gitlab.com/timmitchell/GRANSO
%
%   GRANSO Version 1.6.4, 2016-2020, see AGPL license info below.
%   gransoOptionsAdvanced.m introduced in GRANSO Version 1.0.
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

    % This "advanced" version exists mostly just to break up the help
    % documentation so the user isn't overwhelmed with details on the more
    % advanced parameters which they may not immediately (or ever) need.
    
    % Just pass all the work to the standard gransoOptions function.
    opts = gransoOptions(varargin{:});
        
end