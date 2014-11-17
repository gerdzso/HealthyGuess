function genData(kajaszam, csopszam, userszam, kajapar_vhossz, requestszam)
    kajak = [randi(csopszam, kajaszam, 1) rand(kajaszam, 1)];
    kajanevek = [];
    for i = 1:kajaszam
        kajanevek = [kajanevek; sprintf('e_csop%d_cal%f', kajak(i, 1), kajak(i, 2))];
    end

    % Create etelpar-vectors (matrix)
    X = rand(kajaszam ^ 2, kajapar_vhossz);

    % Create user-parameters
    Theta = rand(userszam, kajapar_vhossz);

    request_list = [randi(kajaszam, requestszam, 1) randi(userszam, requestszam, 1)];

    save 'kajalista' kajak kajanevek X Theta request_list requestszam kajaszam userszam;
end
