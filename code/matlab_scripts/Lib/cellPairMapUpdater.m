function cellPairMap = cellPairMapUpdater(cellPairMap,tempFactors)
%functionalize the cellPair map updating process
    cellPairs = nchoosek(tempFactors(2:end),2);
    %the function will order the pairs with elements consequentially
    for i = 1:size(cellPairs,1)
        cellPairMap(cellPairs(i,1),cellPairs(i,2)) = cellPairMap(cellPairs(i,1),cellPairs(i,2)) + 1;
    end
end