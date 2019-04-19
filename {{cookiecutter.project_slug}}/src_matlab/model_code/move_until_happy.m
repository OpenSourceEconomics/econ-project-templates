function [new_loc] = move_until_happy(loc, A, n, r, m)

% If not happy, then randomly choose new locations until happy or max_moves reached.
% Return new location, or old location if already happy.

    function [zero_one] = happy(loc, typ, A, n, r)
    % 1, if sufficient number of nearest neighbours are of the same type,
    % 0 otherwise.

    % Obtain row indeces of *n*-nearest neighbours in *A*
    N = KDTreeSearcher(A(:, 1:2), 'Distance', 'euclidean');
    idx = knnsearch(N, loc(1:2), 'K', n);

        % Check if agent is happy
        if sum(A(idx, 3) == typ) >= r;
            zero_one = 1; % happy
        else;
            zero_one = 0; % unhappy
        end
    end

% Get agent's type
this_type = loc(3);

    % Check if agent is happy
    if happy(loc, this_type, A, n, r) == 1;
        new_loc = loc;
    else
        for i = 1 : m;
            % Draw new location and pass agent's type
            new_loc = [rand(1, 2), this_type];
            if happy(new_loc, this_type, A, n, r) == 1;
                break; % Stop if agent becomes happy
            end
        end
    end
end