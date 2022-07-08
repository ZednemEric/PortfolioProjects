/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio Project ].[dbo].[NashvilleHousing]

  ----


Select*
From [Portfolio Project ].dbo.NashvilleHousing;

-- standardize date format

Select SaleDateConverted, convert (Date, SaleDate)
From [Portfolio Project ].dbo.NashvilleHousing;

Update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)

-- if it doesn't work properly

ALTER TABLE [Portfolio Project ].dbo.NashvilleHousing
Add SaleDateConverted Date;

Update [Portfolio Project ].dbo.NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

-- populate property address data

Select *
FROM [Portfolio Project ].dbo.NashvilleHousing
-- WHERE PropertyAddress is null
order by ParcelID 


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project ].dbo.NashvilleHousing a
JOIN [Portfolio Project ].dbo.NashvilleHousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM[Portfolio Project ].dbo.NashvilleHousing a
JOIN [Portfolio Project ].dbo.NashvilleHousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Breaking Out Address into Individual Columns (Address, city, State)

Select PropertyAddress
FROM [Portfolio Project ].dbo.NashvilleHousing
-- WHERE PropertyAddress is null
-- ordeer by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Portfolio Project ].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project ].dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Portfolio Project ].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE [Portfolio Project ].dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE [Portfolio Project ].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT*
From [Portfolio Project ].dbo.NashvilleHousing

-- splitting address without substring

Select OwnerAddress 
FROM [Portfolio Project ].dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM [Portfolio Project ].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project ].dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE [Portfolio Project ].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE [Portfolio Project ].dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE [Portfolio Project ].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE [Portfolio Project ].dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE [Portfolio Project ].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

Select*
FROM [Portfolio Project ].dbo.NashvilleHousing

-- Change y and N to Yes and No in "Sold as Vacant" Field

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio Project ].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
,  CASE When SoldAsVacant = 'Y' THEN 'YES'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM [Portfolio Project ].dbo.NashvilleHousing

Update [Portfolio Project ].dbo.NashvilleHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' THEN 'YES'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END


-- Remove Duplicates , using a CTE

WITH RowNumCTE AS(
Select*,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER by 
					UniqueID
					) row_num

FROM [Portfolio Project ].dbo.NashvilleHousing 
)
-- order by ParcelID -- prestep
SELECT*
FROM RowNumCTE
WHERE row_num > 1
-- Order by Property -- prestep



-- Delete Unused Data 

Select *
FROM [Portfolio Project ].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project ].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project ].dbo.NashvilleHousing
DROP COLUMN SaleDate