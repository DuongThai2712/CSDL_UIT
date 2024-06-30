USE QLBH_2020
GO

SET DATEFORMAT dmy

--18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT CTHD.SOHD
FROM CTHD
JOIN SANPHAM ON SANPHAM.MASP = CTHD.MASP
WHERE SANPHAM.NUOCSX = 'Singapore'
--19. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT DISTINCT CTHD.SOHD
FROM CTHD
JOIN SANPHAM ON SANPHAM.MASP = CTHD.MASP
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD 
WHERE SANPHAM.NUOCSX = 'Singapore' AND YEAR (HOADON.NGHD) = 2006
--20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(DISTINCT CTHD.SOHD) AS KO_PHAI_KHACH_HANG_THANH_VIEN
FROM CTHD
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD 
WHERE HOADON.MAKH IS NULL
--21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT CTHD.MASP) AS SO_SP_BAN_RA
FROM CTHD
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE YEAR(HOADON.NGHD) = 2006
--22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MAX(TRIGIA) AS MAXGIAHD, MIN(TRIGIA) AS MINGIAHD
FROM HOADON
--23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AS TBGIAHD
FROM HOADON
WHERE YEAR(NGHD) = 2006
--24. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2006
--25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT MAX(TRIGIA) AS MAXGIAHD2006
FROM HOADON
WHERE YEAR(NGHD) = 2006
--26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT KHACHHANG.HOTEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
WHERE HOADON.TRIGIA = (
    SELECT MAX(TRIGIA)
    FROM HOADON
    WHERE YEAR(NGHD) = 2006
)
--27. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC
--28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
)
--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
)
--30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất)
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
	WHERE NUOCSX = 'Trung Quoc'
)
--31. In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).
SELECT TOP 3 *
FROM KHACHHANG
ORDER BY DOANHSO DESC
--32. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(MASP) AS TONGSOSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
--33. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(DISTINCT MASP) AS TONGSOSP
FROM SANPHAM
GROUP BY NUOCSX
--34. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) AS MAXGIA, MIN(GIA) AS MINGIA, AVG(GIA) AS AVGGIA
FROM SANPHAM
GROUP BY NUOCSX
--35. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD AS NGAY, SUM(TRIGIA) AS DOANHTHUMOINGAY
FROM HOADON
GROUP BY NGHD
ORDER BY NGHD
--36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT SANPHAM.MASP, SANPHAM.TENSP, SUM(CTHD.SL) AS TONGSL
FROM CTHD
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP
WHERE YEAR(HOADON.NGHD) = 2006 AND MONTH(HOADON.NGHD) = 10
GROUP BY SANPHAM.MASP, SANPHAM.TENSP
--37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
GROUP BY MONTH(NGHD)
--38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD
FROM CTHD
GROUP BY SOHD
HAVING COUNT(DISTINCT MASP) >= 4
--39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT HOADON.SOHD
FROM CTHD
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP
WHERE SANPHAM.NUOCSX = 'Viet Nam'
GROUP BY HOADON.SOHD
HAVING COUNT(DISTINCT SANPHAM.MASP) >= 3
--40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT TOP 1 KHACHHANG.MAKH, KHACHHANG.HOTEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
GROUP BY KHACHHANG.MAKH, KHACHHANG.HOTEN
ORDER BY COUNT(HOADON.SOHD) DESC

SELECT * FROM SANPHAM
SELECT * FROM KHACHHANG
SELECT * FROM HOADON
SELECT * FROM NHANVIEN
SELECT * FROM CTHD
