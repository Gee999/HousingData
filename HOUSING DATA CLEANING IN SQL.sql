---THE DATA CLEANING PROCESS
SELECT *
FROM PortfolioProject..NashvilleHousing

--Correcting the Date Format Used

Select SaleDateConverted, CONVERT (Date, SaleDate)
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT (Date, SaleDate)


--Populating Property Address Data

SELECT *
FROM PortfolioProject..NashvilleHousing
---WHERE PropertyAddress IS NULL
ORDER BY ParcelID

---PERFORMING A SELF-JOIN 

SELECT a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a
JOIN PortfolioProject..NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> a.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Make sure to update Table as an Alias (a)

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, a.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a
JOIN PortfolioProject..NashvilleHousing AS a
	ON a.ParcelID = a.ParcelID
	AND a.[UniqueID ] <> a.[UniqueID ]
WHERE a.PropertyAddress IS NULL

---Breaking out the Property Address Column into 3 different columns (Address, City, and State)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1) As Address, 
SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, 
LEN(PropertyAddress)) AS Address
FROM PortfolioProject..NashvilleHousing

---Alter and update

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar (255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1)

---Alter and update

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar (255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1, 
LEN(PropertyAddress)) 

---SPLITING THE OWNER ADDRESS USING PARSENAME

SELECT *
FROM PortfolioProject..NashvilleHousing

---First replace the commas with a period for PARSENAME to be useful

SELECT PARSENAME (REPLACE (Owneraddress, ',', '.' ), 3),
		PARSENAME (REPLACE (Owneraddress, ',', '.' ), 2),
		PARSENAME (REPLACE (Owneraddress, ',', '.' ), 1)
FROM PortfolioProject..NashvilleHousing

---NOW TO ADD THE NEW COLUMNS AND VALUES

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar (255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE (Owneraddress, ',', '.' ), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar (255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE (Owneraddress, ',', '.' ), 2)

Alter Table NashvilleHousing
ADD OwnerSplitState Nvarchar (255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME (REPLACE (Owneraddress, ',', '.' ), 1)

---DONE---
SELECT *
FROM PortfolioProject..NashvilleHousing


SELECT DISTINCT (SoldAsVacant), COUNT (SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT (SoldAsVacant)

---Replace Y with Yes and N with No Using A CASE STATEMENT

SELECT SoldAsVacant
, CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing

---THEN UPDATE COLUMN

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing

--REMOVING DUPLICATES

WITH RowNumCTE AS(
SELECT *, 
ROW_NUMBER () OVER (
PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY
UniqueID) row_num
FROM PortfolioProject..NashvilleHousing)

SELECT *
FROM RowNumCTE
WHERE Row_num >1

--Order by PropertyAddress

SELECT *
FROM PortfolioProject..NashvilleHousing

---DELETE THE UNIMPORTANT COLUMNS

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP Column SaleDate