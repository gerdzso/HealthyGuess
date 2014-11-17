function getValid(siz)
    load 'kajalista'
    RanksValid = zeros(0, 3);
    requestlistValid = [randi(kajaszam, siz, 1) randi(kajaszam, siz, 1) randi(userszam, siz, 1)];
    for i = 1:siz
        req = requestlistValid(i, :);
        rnk = getResponse(kajak(req(1), :), kajak(req(2), :));
        RanksValid = [RanksValid; (req(1) - 1) * kajaszam + req(2) req(3) rnk];
    end
    save 'validset' RanksValid;
end

function [rnk] = getResponse(kaja1, kaja2)
    csopid = kaja1(1) == kaja2(1);
    rnk = ceil((rand * (1 - csopid) * 0.3 + csopid * (rand * 0.3 + 0.7)) * (1 - kaja2(2)) * 5.0);
end
