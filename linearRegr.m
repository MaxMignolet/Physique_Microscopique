classdef linearRegr
    properties
        data    %contains the experimental data
                %should be a 2 by n matrix
                %first line x
                %second line y
        a       %coeff of the slope of the line of regression
        b       %coeff of the y-intercept the line of regression
    end
    
    methods
        %compute the coeff of the line of regression
        %least squares methods
        %normal equation
        function obj = linearRegr(data)
            obj.data = data;
            A = zeros(2, 2);
            B = zeros(2, 1);
            for i=1:length(data)
                A(1, 1) = A(1, 1) + data(1, i) * data(1, i);
                A(1, 2) = A(1, 2) + data(1,i);
                B(1, 1) = B(1, 1) + data(1, i) * data(2, i);
                B(2, 1) = B(2, 1) + data(2, i);
            end
            A(2, 1) = A(1, 2);
            A(2, 2) = length(data);
            X = linsolve(A, B);
            obj.a = X(1);
            obj.b = X(2);
        end
        
        %compute the coeff alpha s.t. y = alpha * x is the best
        %approximation
        function alpha = affine(obj)
            alpha = sum(obj.data(2, :) .* obj.data(1, :)) / sum(obj.data(1, :).^2);
            % sum(y_i) / sum(x_i)
            return
        end
        
        %compute the y value of the line of regr for a given value of x
        function y = f(obj, x)
            y = obj.a*x + obj.b;
            return;
        end
        
        %compute the sum of the squares of the residuals
        %function S = ResidualsSq(obj)
            %to be done
        %end
        
        %compute the coefficient of determination R^2
        function coeff = Rsquared(obj)
            num = 0;
            den = 0;
            mean = 0;
            
            %compute the mean value of the estimated y
            for i=1:length(obj.data)
                xi = obj.data(1, i);
                mean = mean + obj.f(xi);
            end
            mean = mean / length(obj.data);
            
            for i=1:length(obj.data)
                xi = obj.data(1, i);
                num = num + (obj.data(2, i) - obj.f(xi)) * (obj.data(2, i) - obj.f(xi));
                den = den + (obj.data(2, i) - mean) * (obj.data(2, i) - mean);
            end
            coeff = 1 - num/den;
            return;
        end
        
        %plot the data with the line of regression
        function  plot(obj)
            figure;
            plot(obj.data(1, :), obj.data(2, :));
            x1 = obj.data(1, 1);
            x2 = obj.data(1, end);
            y1 = obj.a * x1 + obj.b;
            y2 = obj.a * x2 + obj.b;
            hold on
            plot([x1 x2], [y1 y2]);
            hold off
        end
        
        function  plotFig(obj, fig)
            axes1 = axes('Parent',fig);
            hold(axes1,'on');
            plot(obj.data(1, :), obj.data(2, :));
            x1 = obj.data(1, 1);
            x2 = obj.data(1, end);
            y1 = obj.a * x1 + obj.b;
            y2 = obj.a * x2 + obj.b;
            plot([x1 x2], [y1 y2]);
            hold(axes1,'off');
        end
        
        function [fig, ax] = scatteredPlot(obj, varargin)
            var fig;
            if nargin == 2
                fig = varargin{1};
            else
                fig = figure;
            end
            ax = axes('Parent',fig);
            hold(ax,'on');
            scatter(obj.data(1, :), obj.data(2, :));
            x1 = min(obj.data(1, :));
            x2 = max(obj.data(1, :));
            y1 = obj.a * x1 + obj.b;
            y2 = obj.a * x2 + obj.b;
            plot([x1 x2], [y1 y2]);
            hold(ax,'off');
        end
    end
end
