function kaja()
    % Create ranks - [kajaparidx, useridx, rank]
    Ranks = zeros(0, 3);
    load 'validset';
    load 'kajalista';
    for i = 1:requestszam
        req = request_list(i, :);
        ranklist = hypothesis(Theta, X, req(2));
        alterlist = ranklist((req(1) - 1) * kajaszam + 1:req(1) * kajaszam, :);
        [sortedValues,sortIndex] = sort(alterlist, 'descend');
        alteridx = sortIndex(randi(5));
        rnk = getResponse(kajak(req(1), :), kajak(alteridx, :));
        Ranks = [Ranks; (req(1) - 1) * kajaszam + alteridx req(2) rnk];
        printf('Learning (iter %d)...\n', i);
        fflush(stdout);
        [Theta, X] = learn(Theta, X, Ranks);
        fflush(stdout);
        printf('InSample: %f\n', err(Theta, X, Ranks, 0));
        printf('OutOfSample: %f\n', err(Theta, X, RanksValid, 0));
        fflush(stdout);
        
    end
end

function [rnk] = getResponse(kaja1, kaja2)
    csopid = kaja1(1) == kaja2(1);
    rnk = ceil((rand * (1 - csopid) * 0.3 + csopid * (rand * 0.3 + 0.7)) * (1 - kaja2(2)) * 5.0);
end

function [Theta, X] = learn(Theta, X, Ranks)
    %options = optimset('GradObj', 'on', 'MaxIter', 400);
    options = optimset('MaxIter', 10);
    %[Theta, X] = reconst(fminunc(@(vec)(learnErr(vec, Ranks, size(Theta), size(X))), flatten(Theta, X), options), size(Theta), size(X));
    [Theta, X] = reconst(fminsearch(@(vec)(learnErr(vec, Ranks, size(Theta), size(X))), flatten(Theta, X)), size(Theta), size(X));
end

function [e] = learnErr(vec, Ranks, tdim, xdim)
    [Theta, X] = reconst(vec, tdim, xdim);
    e = err(Theta, X, Ranks);
end

function [out] = hypothesis(Theta, X, user, kajapar)
    if nargin == 2
        out = X * Theta';
    elseif nargin == 3
        out = X * Theta(user, :)';
    else
        out = X(kajapar, :) * Theta(user, :)';
    end
end

function [out] = flatten(Theta, X)
    out = [Theta(:); X(:)];
end

function [Theta, X] = reconst(inp, Theta_dim, X_dim)
    Theta_len = prod(Theta_dim);
    
    Theta = reshape(inp(1:Theta_len), Theta_dim);
    X = reshape(inp(1 + Theta_len:end), X_dim);
end

function [out] = err(Theta, X, Ranks, lambda)
    if nargin < 4
        lambda = 1 / size(Ranks, 1);
    end
    
    out = 0;
    for i = 1:size(Ranks, 1)
        out += (hypothesis(Theta, X, Ranks(i, 2), Ranks(i, 1)) - Ranks(i, 3)) ^ 2;
    end
    
    if lambda
        out += lambda * sum((X .^ 2)(:));
        out += lambda * sum((Theta .^ 2)(:));
    end
    
    out /= 2;
end