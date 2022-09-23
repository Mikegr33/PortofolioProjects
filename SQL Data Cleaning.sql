/*
Cleaning Data in SQL Queries
*/


Select *
From [Portofolio Project ].dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SalesDateConverted, convert(date,SaleDate)
From [Portofolio Project ].dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = convert(date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SalesDateConverted Date;

uPDATE NashvilleHousing
SET SalesDateConverted = convert(date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Portofolio Project ].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portofolio Project ].dbo.NashvilleHousing a
JOIN [Portofolio Project ].dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portofolio Project ].dbo.NashvilleHousing a
JOIN [Portofolio Project ].dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null	
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Portofolio Project ].dbo.NashvilleHousing
--Where PropertyAddress is null

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 ) as Adress
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Adress
From [Portofolio Project ].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

uPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

uPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))


Select OwnerAddress
from [Portofolio Project ].dbo.NashvilleHousing

Select PARSENAME(replace(OwnerAddress, ',', '.') ,3)
, PARSENAME(replace(OwnerAddress, ',', '.') ,2)
, PARSENAME(replace(OwnerAddress, ',', '.') ,1)
from [Portofolio Project ].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

uPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

uPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

uPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.') ,1)


Select *
from [Portofolio Project ].dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [Portofolio Project ].dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from [Portofolio Project ].dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


-----------------------------------------------------------------------------------------------------------------------
 --Remove Duplicate

 WITH RowNumCTE AS (
 Select * ,
 row_number() over (
 partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order by
			      UniqueID
				  ) row_num


 from [Portofolio Project ].dbo.NashvilleHousing
-- order by ParcelID
)
SELECT *
--DELETE
FROM RowNumCTE
WHERE row_num> 1
--order by PropertyAddress









-----------------------------------------------------------------------------------------------------------------------


-- Delete Unused Columns

Select *
from [Portofolio Project ].dbo.NashvilleHousing

ALTER TABLE [Portofolio Project ].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portofolio Project ].dbo.NashvilleHousing
DROP COLUMN SaleDate

