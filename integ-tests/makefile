default: test1
test1:
	nim c test1
	./test1 >| test1.result.txt
	diff test1.expect.txt test1.result.txt
