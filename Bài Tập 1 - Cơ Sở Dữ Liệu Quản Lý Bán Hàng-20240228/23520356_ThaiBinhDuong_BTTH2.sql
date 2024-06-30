USE QLBH_2020
GO

SET DATEFORMAT dmy

--PHẦN I--
--2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
ALTER TABLE SANPHAM ADD GHICHU varchar(20)
--3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG ADD LOAIKH tinyint
--4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM ALTER COLUMN GHICHU varchar(100)
--5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM DROP COLUMN GHICHU
--6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, …
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH varchar(30)
--7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
ALTER TABLE SANPHAM ADD CONSTRAiNT CHECK_DVT CHECK ((DVT = 'cay') or (DVT = 'hop') or (DVT = 'cai') or (DVT = 'quyen') or (DVT = 'chuc'))
--8. Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE SANPHAM ADD CONSTRAINT CHECK_GIABAN CHECK (GIA > 500)
--9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
ALTER TABLE CTHD ADD CONSTRAINT MUA_HANG CHECK (SL > 0)
--10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
ALTER TABLE KHACHHANG ADD CONSTRAINT CHECK_NGAY CHECK (NGDK > NGSINH)

--PHẦN II--
--2. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
SELECT* INTO SANPHAM1 FROM SANPHAM
SELECT* INTO KHACHHANG1 FROM KHACHHANG
--3. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
UPDATE SANPHAM1 SET GIA=GIA*1.05 WHERE NUOCSX = 'Thai Lan'
--4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1 SET GIA=GIA*0.95 WHERE NUOCSX = 'Trung Quoc' AND GIA < 10000
--5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước 
               --ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 
               --1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1)
UPDATE KHACHHANG1 SET LOAIKH = 'Vip' WHERE (NGDK < '1/1/2007' AND DOANHSO >= 10000000) OR (NGDK >= '1/1/2007' AND DOANHSO >= 2000000)

--PHẦN III--
--1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE NUOCSX = 'Trung Quoc'
--2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE DVT = 'cay' OR DVT='quyen'
--3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE MASP LIKE 'B_01'
--4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE NUOCSX = 'Trung Quoc' AND (30000 <= GIA OR GIA <= 40000)
--5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE (NUOCSX = 'Trung Quoc' OR NUOCSX = 'Thai Lan') AND (30000 <= GIA OR GIA <= 40000)
--6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA 
FROM HOADON 
WHERE NGHD IN ('01/01/2007', '02/01/2007')
--7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT SOHD, TRIGIA 
FROM HOADON 
WHERE NGHD >= '01/01/2007' AND NGHD <= '31/01/2007' 
ORDER BY NGHD ASC, TRIGIA DESC
--8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT KHACHHANG.MAKH, KHACHHANG.HOTEN 
FROM KHACHHANG JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH 
WHERE HOADON.NGHD = '01/01/2007'
--9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT SOHD, TRIGIA 
FROM HOADON JOIN NHANVIEN ON HOADON.MANV = NHANVIEN.MANV 
WHERE NHANVIEN.HOTEN = 'Nguyen Van B' AND HOADON.NGHD = '28/10/2006'
--10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
SELECT SANPHAM.MASP, SANPHAM.TENSP 
FROM SANPHAM JOIN CTHD ON CTHD.MASP = SANPHAM.MASP 
			 JOIN HOADON ON CTHD.SOHD = HOADON.SOHD 
			 JOIN KHACHHANG ON KHACHHANG.MAKH = HOADON.MAKH 
WHERE KHACHHANG.HOTEN = 'Nguyen Van A' AND (HOADON.NGHD >= '01/10/2006' AND HOADON.NGHD <= '31/10/2006') 
--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT DISTINCT SOHD 
FROM CTHD 
WHERE MASP IN ('BB01', 'BB02')
--12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT DISTINCT SOHD 
FROM CTHD 
WHERE MASP IN ('BB01', 'BB02') AND (SL >= 10 AND SL <= 20)
--13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
(SELECT SOHD 
FROM CTHD 
WHERE MASP ='BB01' AND (SL >= 10 AND SL <= 20))
INTERSECT
(SELECT SOHD 
FROM CTHD 
WHERE MASP ='BB02')
--14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'Trung Quoc'
UNION
SELECT SANPHAM.MASP, SANPHAM.TENSP 
FROM SANPHAM JOIN CTHD ON SANPHAM.MASP = CTHD.MASP 
			 JOIN HOADON ON CTHD.SOHD = HOADON.SOHD 
WHERE HOADON.NGHD = '01/01/2007'
--15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NOT EXISTS (
    SELECT 1
    FROM CTHD
    WHERE CTHD.MASP = SANPHAM.MASP
)
--16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NOT EXISTS (
    SELECT 1
    FROM CTHD
    JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
    WHERE CTHD.MASP = SANPHAM.MASP
    AND YEAR(HOADON.NGHD) = 2006
)
--17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
AND NOT EXISTS (
    SELECT 1
    FROM CTHD
    JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
    WHERE CTHD.MASP = SANPHAM.MASP
    AND YEAR(HOADON.NGHD) = 2006
)


SELECT * FROM SANPHAM
SELECT * FROM SANPHAM1
SELECT * FROM KHACHHANG
SELECT * FROM KHACHHANG1
SELECT * FROM HOADON
SELECT * FROM NHANVIEN
SELECT * FROM CTHD
