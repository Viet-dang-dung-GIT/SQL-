﻿use master
GO
if exists ( select name from master.sys.databases where name = 'MySQL_DATA' ) 
	BEGIN 
		DROP DATABASE MySQL_DATA 
		CREATE DATABASE MySQL_DATA
		ON 
	(NAME = MySQL_DATA , FILENAME = "E:\SQL\MySQL_DATA.mdf" , 
		SIZE = 3MB , Filegrowth = 10% ) 
	END 

ELSE
CREATE DATABASE MySQL_DATA

ON 
	(NAME = MySQL_DATA , FILENAME = "E:\SQL\MySQL_DATA.mdf" , 
		SIZE = 3MB , Filegrowth = 10% ) 
GO
	-- tạo bảng và thuộc tính
	USE MySQL_DATA
	go
	CREATE TABLE KhachHang (
	 MaKH char(4) not null , 
	 HoTen varchar (40) , 
	 DiaChi varchar (50) , 
	 SDT varchar(20) ,
	 NgaySinh date ,
	 NgayDK date , 
	 DoanhSo money  
)
CREATE TABLE NhanVien (
	MaNV CHAR(4) NOT NULL , 
	HoTen varchar(40) , 
	NgayVL date , 
	SDT varchar(20) 
	)
CREATE TABLE SanPham ( 
	MaSP char(4) not null ,
	TenSP varchar(40) , 
	DVT varchar(20) ,
	NuocSX varchar(40) , 
	Gia money
	)
CREATE TABLE HoaDon (
	SoHD int not null ,
	NgayHD date ,
	MaKH char(4) ,
	MaNV char(4),
	TriGia money 
)
CREATE TABLE CTHD (
	SoHD int not null ,
	MaSP char(4)  not null , 
	SL int
)
-- sửa bảng
ALTER TABLE KhachHang 
	ADD
	constraint pk_KhachHang primary key (MaKH) , 
	LoaiKH tinyint 
/* truncate table xóa toàn bộ dữ liệu trong bảng
-- Drop table gỡ bảng khỏi database
-- insert into  table_name ( thuộc tính )
values ( N'' unicode ) 
*/
-- sửa bảng thêm khóa chính và khóa phụ
ALTER TABLE NhanVien 
	ADD 
	CONSTRAINT pk_NhanVien primary key (MaNV) 
ALTER TABLE SanPham
	ADD 
	CONSTRAINT PK_SanPham primary key (MaSP) , 
	 GhiChu varchar(20) 
	
ALTER TABLE HoaDon 
	ADD 
	Constraint pk_HoaDon primary key (SoHD) , 
	constraint fk_HoaDon_MaKH foreign key (MaKH) 
	references KhachHang(MaKH)  ,
	constraint fk_HoaDon_MaNV foreign key (MaNV) 
	references NhanVien(MaNV) 

ALTER TABLE CTHD 
	ADD 
	CONSTRAINT pk_CTHD primary key (SoHD,MaSP) ,
	CONSTRAINT fk_CTHD_MaSP foreign key (MaSP) 
	references SanPham(MaSP)
ALTER TABLE SanPham 
	 ALTER COLUMN GhiChu varchar(100) 
ALTER TABLE SanPham 
	 DROP COLUMN GhiChu
ALTER TABLE CTHD 
	ADD 
	CONSTRAINT fk_CTHD_SoHD foreign key (SoHD) 
	REFERENCES HoaDon(SoHD) 
	--6
-- kiểm tra điều kiện của bảng
ALTER TABLE SanPham 
	ADD
	CONSTRAINT chk_SanPham CHECK ( Gia >= 500 )
	--2
ALTER TABLE CTHD 
	ADD
	CONSTRAINT chk_CTHD CHECK (SL >=1 ) 
--3
ALTER TABLE KhachHang 
	ADD
	CONSTRAINT chk_KhachHang CHECK ( NgayDK > NgaySinh ) 
--7
-- cập nhật bảng
update SanPham
set Gia = Gia * 1.05 
where NuocSX = 'Thai Lan' 
--8
update SanPham 
set Gia = Gia * 0.95 
where NuocSX = 'Trung Quoc' and ( Gia < 10000 ) 
--Truy van du lieu select 
-- * lấy tất cả cột
-- select MaHH as [Mã Hàng Hóa] đặt tên tiếng việt
-- select * from SanPham
-- tích decast 
 select * from SanPham  , CTHD 
 Where SanPham.MaSP = CTHD.MaSP and NuocSX = 'Trung Quoc' 
 insert into SanPham ( MaSP , TenSP , DVT ,NuocSX ,  Gia  ) 
 values
		( 'BC01' , 'But chi' , 'cay' , 'Singapore' , 3000 ) , 
		( 'BC02' , 'But chi' , 'cay' , 'Singapore' , 5000 ) , 
		( 'BC03' , 'But chi' , 'cay' , 'Viet Nam' , 3500 ) , 
		( 'BC04' , 'But chi' , 'hop' , 'Viet Nam' , 30000 ) , 
		( 'BB01' , 'But bi' , 'cay' , 'Viet Nam' , 5000 ) , 
		( 'BB02' , 'But bi' , 'cay' , 'Trung Quoc' , 7000 ) , 
		( 'BB03' , 'But bi' , 'hop' , 'Thai Lan' , 100000 ) , 
		( 'TV01' , 'Tap 100 giay mong' , 'quyen' , 'Trung Quoc' , 2500 ) , 
		( 'TV02' , 'Tap 200 giay mong ' , 'quyen' , 'Trung Quoc' , 4500 ) , 
		( 'TV03' , 'Tap 100 giay tot' , 'quyen' , 'Viet Nam' , 3000 ) , 
		( 'TV04' , 'Tap 200 giay tot' , 'quyen' , 'Viet Nam' , 5500 ) ,
		( 'TV05' , 'Tap 100 trang' , 'chuc' , 'Viet Nam' , 23000 ) ,
		( 'TV06' , 'Tap 200 trang' , 'chuc' , 'Viet Nam' , 53000 ) ,
		( 'TV07' , 'Tap 100 giay ' , 'quyen' , 'Viet Nam' , 34000 ) ,
		( 'ST01' , 'So tay 500 trang' , 'quyen' , 'Trung Quoc' , 40000 ) ,
		( 'ST02' , 'So tay loai 1 ' , 'quyen' , 'Viet Nam' , 55000 ) ,
		( 'ST03' , 'So tay loai 2 ' , 'quyen' , 'Viet Nam' , 51000 ) ,
		( 'ST04' , 'So tay ' , 'quyen' , 'Thai Lan' , 55000 ) ,
		( 'ST05' , 'So tay mong' , 'quyen' , 'Thai Lan' , 20000 ) ,
		( 'ST06' , 'phan viet bang' , 'hop' , 'Viet Nam' , 5000 ) ,
		( 'ST07' , 'phan khong bui ' , 'hop' , 'Viet Nam' ,7000 ) ,
		( 'ST08' , 'bong bang' , 'cai' , 'Viet Nam' , 1000 ) ,
		( 'ST09' , 'but long' , 'cay' , 'Viet Nam' , 5000 ) ,
		( 'ST10' , 'but long' , 'cay' , 'Trung Quoc' , 7000 )
insert into KhachHang (MaKH , HoTen , DiaChi , SDT , NgaySinh , DoanhSo , NgayDK ) 
values 
		( 'KH01' , 'Nguyen Van A' , '731 Tran Hung Dao , Q5 , TPHCM' , '08823451' , '19601022' , 13060000 , '20060722' )  ,
		( 'KH02' , 'Tran Ngoc Han' , '23/5 Nguyen Trai , Q5 , TPHCM' , '0908256478' , '19740403' , 280000 , '20060730' )  ,
		( 'KH03' , 'Tran Ngoc Linh ' , '45 Nguyen Canh Chan , Q1 , TPHCM' , '0938776266' , '19800612' , 3860000 , '20060805' )  ,
		( 'KH04' , 'Tran Minh Long' , '50/34 Le Dai Hanh , Q10 , TPHCM' , '0917325476' , '19650309' , 250000 , '20061002' )  ,
		( 'KH05' , 'Le Minh Nhat' , '34 Truong Dinh , Q3 , TPHCM' , '08246108' , '19500310' , 21000 , '20061028' )  ,
		( 'KH06' , 'Le Hoai Thuong' , '277 Nguyen Van Cu , Q5 , TPHCM' , '08631738' , '19811221' , 915000 , '20061124' )  ,
		( 'KH07' , 'Nguyen Van Tam' , '32/3 Tran Binh Trong , Q5 , TPHCM' , '0916783565' , '19710406' , 12500 , '20061201' )  ,
		( 'KH08' , 'Phan Thi Thanh' , ' 45/2 An Duong Vuong, Q5 , TPHCM' , '0938435765' , '19710110' , 365000 , '20061213' )  ,
		( 'KH09' , 'Le Ha Vinh' , '873 Le Hong Phong , Q5 , TPHCM' , '08654763' , '19790903' , 70000 , '20070114' )  ,
		( 'KH10' , 'Ha Duy Lap' , '34/34B Nguyen Trai , Q1 , TPHCM' , '08768904' , '19830502' , 67500 , '20070116' ) 
insert into NhanVien ( MaNV , HoTen ,	SDT , NgayVL ) 
values 
		( 'NV01' , 'Nguyen Nhu Nhut' , '0927345678' , '20060413') , 
		( 'NV02' , 'Le Thi Phi Yen' , '0987567390' , '20060421') , 
		( 'NV03' , 'Nguyen Van B' , '0997047382' , '20060427') , 
		( 'NV04' , 'Ngo Thanh Tuan' , '09137588498' , '20060624') , 
		( 'NV05' , 'Nguyen Thi Truc Thanh' , '0918590387' , '20060720') 

insert into HoaDon ( SoHD , NgayHD , MaKH , MaNV , TriGia ) 
values 
		( 1001 , '20060723' ,  'KH01' ,'NV01' , 320000 ) , 
		( 1002 , '20060812' ,  'KH01' ,'NV02' , 840000 ) , 
		( 1003 , '20060823' ,  'KH02' ,'NV01' , 100000 ) , 
		( 1004 , '20060901' ,  'KH02' ,'NV01' , 180000 ) , 
		( 1005 , '20061020' ,  'KH01' ,'NV02' , 3800000 ) , 
		( 1006 , '20061016' ,  'KH01' ,'NV03' , 2430000 ) , 
		( 1007 , '20061028' ,  'KH03' ,'NV03' , 510000 ) , 
		( 1008 , '20061028' ,  'KH01' ,'NV03' , 440000 ) , 
		( 1009 , '20061028' ,  'KH03' ,'NV04' , 200000 ) , 
		( 1010 , '20061101' ,  'KH01' ,'NV01' , 5200000 ) , 
		( 1011 , '20061104' ,  'KH04' ,'NV03' , 250000 ) , 
		( 1012 , '20061130' ,  'KH05' ,'NV03' , 21000 ) , 
		( 1013 , '20061212' ,  'KH06' ,'NV01' , 5000 ) , 
		( 1014 , '20061231' ,  'KH03' ,'NV02' , 3150000 ) , 
		( 1015 , '20070101' ,  'KH06' ,'NV01' , 910000 ) , 
		( 1016 , '20070101' ,  'KH07' ,'NV02' , 12500 ) , 
		( 1017 , '20070102' ,  'KH08' ,'NV03' , 35000 ) , 
		( 1018 , '20070113' ,  'KH08' ,'NV03' , 330000 ) , 
		( 1019 , '20070113' ,  'KH01' ,'NV03' , 30000 ) , 
		( 1020 , '20070114' ,  'KH09' ,'NV04' , 70000 ) , 
		( 1021 , '20070116' ,  'KH10' ,'NV03' , 67500 ) , 
		( 1022 , '20070116' ,  NULL, 'NV03' , 7000 ) , 
		( 1023 , '20070117' ,  NULL,'NV01' , 330000 ) 
insert into CTHD ( SoHD , MaSP , SL ) 
values 
		( 1001 , 'TV02' , 10 ) , 
		( 1001 , 'ST01' , 5 ) , 
		( 1001 , 'BC01' , 5 ) , 
		( 1001 , 'BC02' , 10 ) , 
		( 1001 , 'ST06' , 10 ) , 
		( 1002 , 'BC04' , 20 ) , 
		( 1002 , 'BB01' , 20 ) , 
		( 1002 , 'BB02' , 20 ) , 
		( 1003 , 'BB03' , 10 ) , 
		( 1004 , 'TV01' , 20 ) , 
		( 1004 , 'TV02' , 10 ) , 
		( 1004 , 'TV03' , 10 ) , 
		( 1004 , 'TV04' , 10 ) , 
		( 1005 , 'TV05' , 50 ) , 
		( 1005 , 'TV06' , 50 ) , 
		( 1006 , 'TV07' , 20 )  

-- 3 - 3 - 2023 
-- truy vấn dữ liệu

-- In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất
select MaSP , TenSP 
from SanPham 
	where NuocSX in ('Trung Quoc')

--In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”
select MaSP , TenSP
from SanPham 
	where DVT in ('cay', 'quyen')
--In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
select MaSP , TenSP 
from SanPham 
	where MaSP like ('B%01')
--In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
select MaSP , TenSP , NuocSX
from SanPham 
	where NuocSX in ('Trung Quoc','Thai Lan') and Gia between  30000 and 40000 
--In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
select SoHD 
from HoaDon
	where NgayHD between '20070101' and '20070102' 

--In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007
select SoHD 
from HoaDon 
	where	Month(NgayHD) = 1 
			and 
			Year(NgayHD) = 2007

--In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
select KhachHang.MaKH , Hoten
from KhachHang , HoaDon
	where	KhachHang.MaKH = HoaDon.MaKH 
			and
			NgayHD = '20070101'
--In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
select NhanVien.HoTen ,SoHD , TriGia 
from NhanVien , HoaDon 
	where	NhanVien.MaNV = HoaDon.MaNV 
			and 
			NhanVien.HoTen = 'Nguyen Van B'
			and
			NgayHD = '20061028'
--In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select SanPham.MaSP , TenSP 
from KhachHang , CTHD , HoaDon , SanPham  
	where	CTHD.MaSP = SanPham.MaSP
			and
			CTHD.SoHD = HoaDon.SoHD
			and
			KhachHang.MaKH = HoaDon.MaKH
			and
			KhachHang.HoTen = 'Nguyen Van A' 
			and
			Month(NgayHD) = 10 
			and 
			Year(NgayHD) = 2006 
-- Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
select   SoHD
from  CTHD 
	where MaSP IN ('BB01','BB02')
-- Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select   SoHD , SL
from  CTHD 
	where 
	   
	  MaSP = 'BB01' or MaSP = 'BB02'
	  and
	  SL between 10 and 20 
-- In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
select CTHD.MaSP , TenSP 
from SanPham , HoaDon , CTHD  
	where 
	  HoaDon.SoHD = CTHD.SoHD 
	  and
	  CTHD.MaSP = SanPham.MaSP
	  and
	  ( 
			NgayHD = '20070101' 
			or
			NuocSX = 'Trung Quoc'
	  )
-- in ra danh sách sản phẩm (MaSP , TenSP) không bán được
select MaSP , TenSP 
from SanPham 
	where  MaSP NOT IN 
	(
		select MaSP 
		from CTHD
	)
-- In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
select MaSP , TenSP 
from SanPham 
	where MaSP not in 
	( 
		select MaSP 
		from CTHD , HoaDon 
		where	HoaDon.SoHD = CTHD.SoHD 
				and 
				Year(NgayHD) = 2006 
	)
-- In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
select MaSP , TenSP 
from SanPham 
	where	Nuocsx = 'Trung Quoc' 
		and 
		MaSP not in		
	(
		select MaSP 
		from CTHD , HoaDon 
		where	HoaDon.SoHD = CTHD.SoHD 
				and 
				Year(NgayHD) = 2006
	)
	  
--select * from SanPham 
--where NuocSX IN ( 'VIETNAM' , 'HanQuoc' ) 
--select * from KhachHang
--where LoaiKH is null 
--select * from KhachHang 
--where DoanhSo between 20000 and 30000 
---- like so sánh mẫu ( giống như )  = không so sánh mẫu ( cụ thể )  
--select * from KhachHang
--where HoTen like 'Bui%' and SDT  like '_%.%_' 
-- INNER JOIN 
-- select * 
-- from ChiTietGiaoHang as ctgh
-- inner join PhieuGiaoHang as pgh 
--on ctgh.MaGiao = pgh.MaGiao 
-- inner join DonDatHang as ddh 
--on pgh.MaDat = ddh.MaDat

--insert into CTHD ( SoHD , MaSP , SL )
--values	
--		( 1001 , 'BU01' , 1000 ) , 
--		(1002 , 'NC00' , 20 ) , 
--		(1003 , 'TV21' ,7)  
--select * from ChiTietDatHang as ctdh 
-- left join HangHoa as hh 
--on ctdh.MaHH = hh.MaHH 
--where ctdh.MaHH is null