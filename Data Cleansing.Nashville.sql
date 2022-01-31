 /*

 Cleaning Data in SQL Queries

 */

 Select *
 From PortfolioProject..Nashville
 


 --------------------------------------------------------------------------------------

 -- Standardize Date Format
 -- The update function was not automatically updating, so I created a row
 -- Will have to go back and delete original SaleDate row for the correct SaleDateConverted row

 Select SaleDateConverted, Convert(Date, SaleDate)
 From PortfolioProject..Nashville
 
 Update Nashville
 Set SaleDateConverted = CONVERT(Date, SaleDate)

 Alter Table Nashville
 Add SaleDateConverted Date
----------------------------------------------------------------------------

--Populate Property Address
-- Same ParcelID is a good indication of same Property Address


Select *
From PortfolioProject..Nashville
--Where PropertyAddress is null
Order by ParcelID

Select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..Nashville a
Join PortfolioProject..Nashville b
	on a.ParcelId = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID] 
Where a.PropertyAddress is null

-- <> means not equal to
--UniqueID was completely unique ensuring no possible duplicates

Update a
Set Propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..Nashville a
Join PortfolioProject..Nashville b
	on a.ParcelId = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID] 
Where a.PropertyAddress is null

-- Just confirming the nulls were filled

Select PropertyAddress
 From PortfolioProject..Nashville
 Where PropertyAddress is null

 ----------------------------------------------------------------------------------------------------
 
 -- Breaking out Address into Individual Columns (Address, City)
 
 
 Select PropertyAddress
From PortfolioProject..Nashville
--Where PropertyAddress is null
--Order by ParcelID

Select 
Substring(Propertyaddress, 1, Charindex(',', PropertyAddress) -1 ) as Address
,Substring(Propertyaddress, Charindex(',',Propertyaddress) +1, Len(PropertyAddress)) as City
From PortfolioProject..Nashville

Alter Table Nashville
Add PropertyAddressSplit Nvarchar(255)

Update Nashville
Set PropertyAddressSplit = Substring(Propertyaddress, 1, Charindex(',', PropertyAddress) -1 )

Alter Table Nashville
Add PropertyCity Nvarchar(255)

Update Nashville
Set PropertyCity = Substring(Propertyaddress, Charindex(',',Propertyaddress) +1, Len(PropertyAddress))


-----------------------------------------------------------------------------

--Splitting OwnerAddress (Address, City, State)

Select OwnerAddress
From PortfolioProject..Nashville

 Select
 PARSENAME(Replace(OwnerAddress, ',','.'), 3) as Address
 ,PARSENAME(Replace(OwnerAddress, ',','.'), 2) as City
 ,PARSENAME(Replace(OwnerAddress, ',','.'), 1) as State
From PortfolioProject..Nashville


Alter Table Nashville
Add OwnerSplitAddress Nvarchar(255)

Update Nashville
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.'), 3)


Alter Table Nashville
Add OwnerSplitCity Nvarchar(255)

Update Nashville
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'), 2)


Alter Table Nashville
Add OwnerSplitState Nvarchar(255)

Update Nashville
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'), 1)



-----------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(soldasvacant), Count(SoldasVacant)
From PortfolioProject..Nashville
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		END
From PortfolioProject..Nashville


Update Nashville
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		END




----------------------------------------------------------------------------------------

--Remove Duplicates
-- partioned on the assumption that if all of these are the same then we can assume the data is a duplicate

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject..Nashville
)
Delete
From RowNumCTE
Where row_num > 1


--------------------------------------------------------------------------

--Delete Unused Columns

Select *
From PortfolioProject..Nashville

Alter Table PortfolioProject..Nashville
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject..Nashville
Drop Column SaleDate