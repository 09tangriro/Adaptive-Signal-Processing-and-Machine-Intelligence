function [coeff, quotient] = circularity(signals)


    cov = mean(diag(signals * signals')/1000);
    p_cov = mean(diag(signals * signals.')/1000);

    quotient = p_cov / cov;
    coeff = abs(quotient);
end