%% First we need to set up the term-document matrix
% we use titles of papers instead of entire documents for simplicity
d1 = ["assessing" "environmental" "diversity"];
d2 = ["planetary", "exploration"];
d3 = ["lsd" "drugs" "doses" "and" "biodistribution"];
d4 = ["tasmanian", "devil", "field", "study", "on", "devil", "facial", "tumour", "disease"];
d5 = ["basal", "cell", "carcinoma", "review"];
d6 = ["frequency", "of", "acid", "rain", "on", "arugula", "population", "growth", "on", "aphids"];
d7 = ["a", "review", "of", "pembrolizumab", "a", "treatment", "for", "esophagael", "cancer"];
d8 = ["a", "review", "of", "idursulfase", "for", "hunter", "syndrome"];
d9 = ["the", "first", "scientific", "classification", "of", "a", "dinosaur"];
d10 = ["review", "of", "current", "online", "and", "in-person", "mathematical", "education", "practices", "from", "undergraduate", "students", "perspectives"];
d11 = ["the", "effects", "of", "moderated", "red", "wine", "consumption", "on", "our", "gut", "microbiome"];
d12 = ["sustainable", "communities", "to", "mitigate", "climate", "change"];
d13 = ["planetary", "formation", "using", "our", "solar", "system", "as", "a", "case", "study"];
d = [d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13]';
terms = unique(d);
terms_sort = sort(terms, 'ascend') %these our the terms present in our documents, in alphabetical order
bag = bagOfWords(terms_sort)
%pseudo code
% for loop: cycle through titles an add 1 to matrix for each term (create
term_doc = zeros(length(terms), 12);
for i = 1:length(terms)
    for j = 1:length(d1)
        if terms_sort(i) == d1(j)
            term_doc(i,1) = term_doc(i,1) + 1;
        end
    end
    for j = 1:length(d2)
        if terms_sort(i) == d2(j)
            term_doc(i,2) = term_doc(i,2) + 1;
        end
    end
    for j = 1:length(d3)
        if terms_sort(i) == d3(j)
            term_doc(i,3) = term_doc(i,3) + 1;
        end
    end
    for j = 1:length(d4)
        if terms_sort(i) == d4(j)
            term_doc(i,4) = term_doc(i,4) + 1;
        end
    end
end
term_doc
% term-doc matrix)
% perform svd on term-doc matrix
[U, S, V] = svd(term_doc);
% find low rank (code already exists)

% compare two docs to find similarities (dot product)
% enter query vector and compute dot products (for loop) 