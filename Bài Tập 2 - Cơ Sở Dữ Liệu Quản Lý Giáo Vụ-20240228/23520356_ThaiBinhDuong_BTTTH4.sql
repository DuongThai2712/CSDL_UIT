USE QUANLIGIAOVU_0208
GO
SET DATEFORMAT dmy

--I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language):
--1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN ADD GHICHU VARCHAR(40)
ALTER TABLE HOCVIEN ADD DIEMTB REAL(4,2)
ALTER TABLE HOCVIEN ALTER COLUMN DIEMTB NUMERIC(4,2)
ALTER TABLE HOCVIEN ADD XEPLOAI VARCHAR(15)
--2. Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”
ALTER TABLE HOCVIEN ADD CONSTRAINT CON_MAHV CHECK (MAHV LIKE 'K____')
--3. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE HOCVIEN ADD CHECK (GIOITINH IN ('Nam', 'Nu'))
ALTER TABLE HOCVIEN ADD CHECK (GIOITINH IN ('Nam', 'Nu'))
--4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI ADD CHECK (DIEM >=0 AND DIEM <=10)
ALTER TABLE KETQUATHI ALTER COLUMN DIEM NUMERIC(4,2)
--5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_KQ CHECK ((KQUA = 'Dat' AND Diem >=5) OR (KQUA = 'Khong Dat' AND Diem <5))
--6. Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI ADD CONSTRAINT MAX_LANTHI CHECK (LANTHI <=3 ) 
--7. Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY ADD CONSTRAINT CHK_HK CHECK (HOCKY IN (1,2,3))
--8. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHK_HV CHECK (HOCVI IN ('CN', 'KS', 'ThS', 'TS', 'PTS'))
--11. Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN ADD CONSTRAINT CHK_TUOI CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >=18)
--12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD CONSTRAINT CHK_GD CHECK (TUNGAY < DENNGAY)
--13. Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHK_TUOICUAGV CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >=22)
--14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC ADD CONSTRAINT CHK_TC CHECK (ABS(TCLT - TCTH) < 3)

--II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):
--1. Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN SET HESO = HESO + 0.2
WHERE MAGV IN (
			SELECT MAGV
			FROM GIAOVIEN
			JOIN KHOA ON MAGV = TRGKHOA
	        )
--2. Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
UPDATE HOCVIEN SET DIEMTB = (
				SELECT MAHV, AVG(DIEM) AS DIEMTB
				FROM (
					SELECT MAHV, MAMH, MAX(LANTHI) AS LANTHI, DIEM
					FROM KETQUATHI
					GROUP BY MAHV, MAMH, DIEM
				) AS DIEMTHI
				--WHERE DIEMTHI.MAHV = HOCVIEN.MAHV
				GROUP BY DIEMTHI.MAHV
				)

--3. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN SET GHICHU = 'Cam thi'
WHERE MAHV IN (
				SELECT MAHV
				FROM KETQUATHI
				WHERE (LANTHI = 3 AND DIEM <5)
			)
--4. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
	--o Nếu DIEMTB >= 9 thì XEPLOAI =”XS”
	--o Nếu 8 <= DIEMTB < 9 thì XEPLOAI = “G”
	--o Nếu 6.5 <= DIEMTB < 8 thì XEPLOAI = “K”
	--o Nếu 5 <= DIEMTB < 6.5 thì XEPLOAI = “TB”
	--o Nếu DIEMTB < 5 thì XEPLOAI = ”Y”
UPDATE HOCVIEN SET XEPLOAI = 
    CASE 
        WHEN DIEMTB >= 9 THEN 'XS'
        WHEN DIEMTB >= 8 AND DIEMTB < 9 THEN 'G'
        WHEN DIEMTB >= 6.5 AND DIEMTB < 8 THEN 'K'
        WHEN DIEMTB >= 5 AND DIEMTB < 6.5 THEN 'TB'
        ELSE 'Y'
    END

--III. Ngôn ngữ truy vấn dữ liệu:
--1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT MAHV, HO, TEN, NGSINH, MALOP
FROM HOCVIEN
WHERE MAHV IN (
			SELECT TRGLOP
			FROM LOP
			)
--2. In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT  HOCVIEN.MAHV, HO, TEN, KETQUATHI.LANTHI, KETQUATHI.DIEM
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE (KETQUATHI.MAMH = 'CTRR')
ORDER BY TEN, HO
--3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, TENMH
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
JOIN MONHOC ON KETQUATHI.MAMH = MONHOC.MAMH
WHERE (KETQUATHI.LANTHI = 1 AND KETQUATHI.KQUA = 'Dat')
--4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HOCVIEN.MAHV, HO, TEN
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE (KETQUATHI.MAMH = 'CTRR' AND KETQUATHI.LANTHI = 1 AND KETQUATHI.KQUA = 'Khong Dat')
--5. * Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT MAHV, HO, TEN
FROM HOCVIEN
WHERE MAHV LIKE 'K%' 
AND MAHV IN (
					SELECT MAHV
					FROM KETQUATHI
					WHERE (MAMH = 'CTRR' AND KQUA = 'Khong Dat' AND LANTHI = 3)
				)
--6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
SELECT TENMH
FROM MONHOC
WHERE MAMH IN (
				SELECT DISTINCT MAMH
				FROM GIANGDAY
				WHERE HOCKY = 1 
				AND NAM = 2006 
				AND MAGV IN (
								SELECT MAGV
								FROM GIAOVIEN
								WHERE HOTEN = 'Tran Tam Thanh'
							)
)
--7. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MONHOC.MAMH, TENMH
FROM MONHOC
JOIN GIANGDAY ON GIANGDAY.MAMH = MONHOC.MAMH
WHERE GIANGDAY.HOCKY = 1 
AND GIANGDAY.NAM = 2006 
AND GIANGDAY.MAGV IN (
							SELECT MAGVCN
							FROM LOP
							WHERE MALOP = 'K11'
						)
--8. Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT HO, TEN
FROM HOCVIEN
WHERE MAHV IN (
				SELECT TRGLOP
				FROM LOP
				WHERE MALOP IN (
									SELECT MALOP
									FROM GIANGDAY
									JOIN GIAOVIEN ON GIAOVIEN.MAGV = GIANGDAY.MAGV
									WHERE HOTEN = 'Nguyen To Lan'
									)
)
--9. In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (
				SELECT MAMH_TRUOC
				FROM DIEUKIEN
				WHERE MAMH IN (
										SELECT MAMH
										FROM MONHOC
										WHERE TENMH = 'Co So Du Lieu'
									)
)
--10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (
				SELECT MAMH
				FROM DIEUKIEN
				WHERE MAMH_TRUOC IN (
										SELECT MAMH
										FROM MONHOC
										WHERE TENMH = 'Cau Truc Roi Rac'
									)
)
--11. Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV IN (
				SELECT MAGV
				FROM GIANGDAY
				WHERE MALOP IN ('K11','K12') AND HOCKY = 1 AND NAM = 2006 AND MAMH = 'CTRR'
			)
--12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
SELECT MAHV, HO, TEN
FROM HOCVIEN
WHERE MAHV IN (
				SELECT MAHV
				FROM KETQUATHI
				WHERE MAMH = 'CSDL' AND LANTHI = 1 AND KQUA = 'Khong Dat')
AND MAHV NOT IN (
				SELECT MAHV
				FROM KETQUATHI
				WHERE MAMH = 'CSDL' AND LANTHI > 1)
--13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (
					SELECT MAGV
					FROM GIANGDAY)
--14. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAKHOA NOT IN (
						SELECT DISTINCT MAKHOA
						FROM MONHOC
						JOIN GIANGDAY ON MONHOC.MAMH = GIANGDAY.MAMH
)
--15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HO, TEN
FROM HOCVIEN
WHERE MALOP = 'K11'
AND MAHV IN ( 
				SELECT MAHV
				FROM KETQUATHI
				WHERE (LANTHI = 3 AND KQUA = 'Khong Dat')
				OR (MAMH = 'CTRR' AND LANTHI =2 AND DIEM = 5)
)
--16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.

--17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, DIEMTHI.DIEM
FROM HOCVIEN
JOIN (
					SELECT MAHV, MAX(LANTHI) AS LANTHI, DIEM
					FROM KETQUATHI
					WHERE MAMH = 'CSDL'
					GROUP BY MAHV, DIEM
			  ) AS DIEMTHI ON DIEMTHI.MAHV = HOCVIEN.MAHV
--18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, DIEMTHI.DIEMCAONHAT
FROM HOCVIEN
JOIN (
			SELECT MAHV, MAX(DIEM) AS DIEMCAONHAT
			FROM KETQUATHI
			WHERE MAMH IN (		
								SELECT MAMH
								FROM MONHOC
								WHERE TENMH = 'Co So Du Lieu'
						  )
			GROUP BY MAHV
) AS DIEMTHI ON DIEMTHI.MAHV = HOCVIEN.MAHV
--19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT TOP 1 MAKHOA, TENKHOA
FROM KHOA
ORDER BY NGTLAP ASC
--20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”
SELECT COUNT(HOCHAM)
FROM GIAOVIEN
WHERE HOCHAM = 'GS' OR HOCHAM = 'PGS'
--21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT KHOA.MAKHOA, 
       KHOA.TENKHOA, 
       COUNT(CASE WHEN GIAOVIEN.HOCVI = 'CN' THEN 1 ELSE NULL END) AS CN,
       COUNT(CASE WHEN GIAOVIEN.HOCVI = 'KS' THEN 1 ELSE NULL END) AS KS,
       COUNT(CASE WHEN GIAOVIEN.HOCVI = 'ThS' THEN 1 ELSE NULL END) AS ThS,
       COUNT(CASE WHEN GIAOVIEN.HOCVI = 'TS' THEN 1 ELSE NULL END) AS TS,
       COUNT(CASE WHEN GIAOVIEN.HOCVI = 'PTS' THEN 1 ELSE NULL END) AS PTS
FROM KHOA
LEFT JOIN GIAOVIEN ON KHOA.MAKHOA = GIAOVIEN.MAKHOA
GROUP BY KHOA.MAKHOA, KHOA.TENKHOA
--22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MONHOC.MAMH, THIDAT.DAT, THIKHONGDAT.KHONGDAT
FROM MONHOC
JOIN (
		SELECT MAMH, COUNT(KQUA) AS DAT
		FROM KETQUATHI
		WHERE KQUA = 'Dat'
		GROUP BY MAMH
) AS THIDAT ON MONHOC.MAMH = THIDAT.MAMH
JOIN (
		SELECT MAMH, COUNT(KQUA) AS KHONGDAT
		FROM KETQUATHI
		WHERE KQUA = 'Khong Dat'
		GROUP BY MAMH
) AS THIKHONGDAT ON MONHOC.MAMH = THIKHONGDAT.MAMH
--23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT DISTINCT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM GIAOVIEN
JOIN LOP ON GIAOVIEN.MAGV = LOP.MAGVCN 
JOIN GIANGDAY ON GIAOVIEN.MAGV = GIANGDAY.MAGV 
JOIN MONHOC ON GIANGDAY.MAMH = MONHOC.MAMH 
WHERE LOP.MALOP = GIANGDAY.MALOP 
--24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT HO, TEN
FROM HOCVIEN
WHERE MAHV IN (
				SELECT TRGLOP
				FROM LOP
				WHERE SISO = (
								SELECT MAX(SISO)
								FROM LOP
								)
)


SELECT * FROM HOCVIEN
SELECT * FROM LOP
SELECT * FROM KHOA
SELECT * FROM DIEUKIEN
SELECT * FROM MONHOC
SELECT * FROM GIAOVIEN
SELECT * FROM GIANGDAY
SELECT * FROM KETQUATHI
