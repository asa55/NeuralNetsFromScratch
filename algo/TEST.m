function test = TEST(training)
%TEST takes training indexes and returns unique test indexes

test = setdiff(([1:55*62]),training);

end

