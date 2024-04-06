% mdl = my_spafdr(y, u, fs, f)
% A simplifed function for MATLAB `spafdr` used for algorithm demonstration
% ASSUME: SISO system, meaning that y and u are scalar input (recorded as column vectors)
%    y --- [column vector] system output
%    u --- [column vector] system input
%   fs --- [Hz]sampling frequency
%   fr --- [Hz, column vector] frequency bins where to get system response

% XiaoCY 2024-04-06

%%
function mdl = my_spafdr(y, u, fs, fr)
    % y and u must be the same length, but I don't check here
    nfft = length(y);

    % calculate frequecy spectrum
    Y = fft(y);
    U = fft(u);
    f = (0:nfft-1)'/nfft*fs;

    % calculate frequency resolution
    fres = [diff(fr); fr(end)-fr(end-1)];
    fmin = fs/nfft;
    fres(fres < fmin) = fmin;                       % requested frequency resolution must not be less than the valid resolution

    % calculate cross-correlation and auto-correlation in frequency domain
    K = length(fr);
    [Ryu, Ruu] = deal(zeros(K,1));
    for k = 1:K
        % get index of raw spectrum data within requested resolution
        idx = abs(f - fr(k)) < fres(k);
        
        % set weighting function
        weight = cos((f(idx)-fr(k))/fr(k)*pi/2);
        % weight = weight / sum(weight);            % not necessary here, we will divide this common factor

        % calculate weight-averaged correlation
        Ryu(k) = (Y(idx).*conj(U(idx))).'*weight;
        Ruu(k) = (U(idx).*conj(U(idx))).'*weight;
    end

    % get response in frequency domain and convert to frd model
    resp = Ryu./Ruu;
    mdl = idfrd(resp, 2*pi*fr, 1/fs);
end