USE PartShipmentDB
GO
SET DATEFORMAT DMY

--1. Hiển thị thông tin (maNCC, tenNCC, thanhpho) của tất cả nhà cung cấp.
SELECT maNCC, tenNCC, thanhpho
FROM Nhacungcap
--2. Hiển thị thông tin của tất cả các phụ tùng.
SELECT * FROM Phutung
--3. Hiển thị thông tin các nhà cung cấp ở thành phố London.
SELECT * FROM Nhacungcap
WHERE thanhpho = 'London'
--4. Hiển thị mã phụ tùng, tên và màu sắc của tất cả các phụ tùng ở thành phố Paris.
SELECT maPT, tenPT, mausac
FROM Phutung
where thanhpho = 'Paris'
--5. Hiển thị mã phụ tùng, tên, khối lượng của những phụ tùng có khối lượng lớn hơn 15.
SELECT maPT, tenPT, khoiluong
FROM Phutung
where khoiluong > 15
--6. Tìm những phụ tùng (maPT, tenPt, mausac) có khối lượng lớn hơn 15, không phải màu đỏ (red). 
SELECT maPT, tenPT, mausac
FROM Phutung
WHERE khoiluong > 15 AND mausac NOT IN ('Red')
--7. Tìm những phụ tùng (maPT, tenPt, mausac) có khối lượng lớn hơn 15, màu sắc khác màu đỏ (red) và xanh (green).
SELECT maPT, tenPT, mausac
FROM Phutung
WHERE khoiluong > 15 AND mausac NOT IN ('Red', 'Green')
--8. Hiển thị những phụ tùng (maPT, tenPT, khối lượng) có khối lượng lớn hơn 15 và nhỏ hơn 20, sắp xếp theo tên phụ tùng.
SELECT maPT, tenPT, khoiluong
FROM Phutung
WHERE khoiluong > 15 AND khoiluong < 20
ORDER BY tenPT
--9. Hiển thị những phụ tùng được vận chuyển bởi nhà cung cấp có mã số S1. Không hiển thị kết quả trùng. (sử dụng phép kết).
SELECT Phutung.maPT, Phutung.tenPT, Phutung.mausac, Phutung.khoiluong, Phutung.thanhpho
FROM Phutung
JOIN Vanchuyen ON Phutung.maPT = Vanchuyen.maPT
JOIN Nhacungcap ON Vanchuyen.maNCC = Nhacungcap.maNCC
WHERE Vanchuyen.maNCC = 'S1'
--10. Hiển thị những nhà cung cấp vận chuyển phụ tùng có mã là P1 (sử dụng phép kết).

--11. Hiển thị thông tin nhà cung cấp ở thành phố London và có vận chuyển  phụ tùng của thành phố London. Không hiển thị kết quả trùng. (Sử dụng phép kết)
--12. Lặp lại câu 9 nhưng sử dụng toán tử IN.
--13. Lặp lại câu 10 nhưng sử dụng toán tử IN
--14. Lặp lại câu 9 nhưng sử dụng toán tử EXISTS
--15. Lặp lại câu 10 nhưng sử dụng toán tử EXISTS
--16. Lặp lại câu 11 nhưng sử dụng truy vấn con. Sử dụng toán tử IN.
--17. Lặp lại câu 11 nhưng dùng truy vấn con. Sử dụng toán tử EXISTS. 
--18. Tìm nhà cung cấp chưa vận chuyển bất kỳ phụ tùng nào. Sử dụng NOT IN.
--19. Tìm nhà cung cấp chưa vận chuyển bất kỳ phụ tùng nào. Sử dụng NOT EXISTS.
--20. Tìm nhà cung cấp chưa vận chuyển bất kỳ phụ tùng nào. Sử dụng outer JOIN (Phép kết ngoài)
--21. Có tất cả bao nhiêu nhà cung cấp?
SELECT COUNT(maNCC)
FROM Nhacungcap
--22. Có tất cả bao nhiêu nhà cung cấp ở London?
SELECT COUNT(maNCC)
FROM Nhacungcap
WHERE thanhpho = 'London'
--23. Hiển thị trị giá cao nhất, thấp nhất của trangthai của các nhà cung cấp.
SELECT MAX(trangthai) AS MAX, MIN(trangthai) AS MIN 
FROM Nhacungcap
--24. Hiển thị giá trị cao nhất, thấp nhất của trangthai trong table nhacungcap ở thành phố London.
SELECT MAX(trangthai) AS MAX, MIN(trangthai) AS MIN 
FROM Nhacungcap
WHERE thanhpho = 'London'
--25. Mỗi nhà cung cấp vận chuyển bao nhiêu phụ tùng? Chỉ hiển thị mã nhà cung cấp, tổng số phụ tùng đã vận chuyển.
SELECT maPT, SUM(soluong) AS tong
FROM Vanchuyen
GROUP BY maPT
--26. Mỗi nhà cung cấp vận chuyển bao nhiêu phụ tùng? Hiển thị mã nhà cung cấp, tên, thành phố của nhà cung cấp và tổng số phụ tùng đã vận chuyển

--27. Nhà cung cấp nào đã vận chuyển tổng cộng nhiều hơn 500 phụ tùng? Chỉ hiển thị mã nhà cung cấp
--28. Nhà cung cấp nào đã vận chuyển nhiều hơn 300 phụ tùng màu đỏ (red). Chỉ hiển thị mã nhà cung cấp.
--29. Nhà cung cấp nào đã vận chuyển nhiều hơn 300 phụ tùng màu đỏ (red). Hiển thị mã nhà cung cấp, tên, thành phố và số lượng phụ tùng màu đỏ đã vận chuyển.
--30. Có bao nhiêu nhà cung cấp ở mỗi thành phố.
--31. Nhà cung cấp nào đã vận chuyển nhiều phụ tùng nhất. Hiển thị tên nhà cung cấp và số lượng phụ tùng đã vận chuyển.
--32. Thành phố nào có cả nhà cung cấp và phụ tùng.
--33. Viết câu lệnh SQL để insert nhà cung cấp mới: S6, Duncan, 30, Paris.
INSERT INTO Nhacungcap VALUES ('S6', 'Duncan', 30, 'Paris')
--34. Viết câu lệnh SQL để thay đổi thanh phố S6 (ở câu 33) thành Sydney.
UPDATE Nhacungcap SET thanhpho = 'Sydney'
WHERE maNCC = 'S6'
--35. Viết câu lệnh SQL tăng trangthai của nhà cung cấp ở London lên thêm 10.
--36. Viết câu lệnh SQL xoá nhà cung cấp S6

SELECT * FROM Nhacungcap
SELECT * FROM Phutung
SELECT * FROM Vanchuyen