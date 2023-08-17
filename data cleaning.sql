-----------------------------------------clean data in sql quries-----------------------------------------------
 select
 SaleDateConverted
 from Nashville

--standardize date formant
alter table Nashville
add saleDateConverted date 
update Nashville
set saleDateConverted = convert (date,SaleDate)

--populate property address data

select *

from Nashville
where PropertyAddress is null
 order by ParcelID

 select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
 isnull (a.propertyAddress, b.PropertyAddress)    
 from Nashville a
 join Nashville b
 on a.ParcelID  = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null 
 update a
 set propertyAddress = isnull (a.propertyAddress, b.PropertyAddress)
 from Nashville a
 join Nashville b
 on a.ParcelID  = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null 

--breaking out address into individual columns (address,city,state)

select 
substring (PropertyAddress,0 , CHARINDEX (',', propertyAddress)) as address
,SUBSTRING(propertyAddress, CHARINDEX (',', propertyAddress)+1,len(PropertyAddress)) as  Address
from Nashville

alter table nashville
add PropertySplitAddress nvarchar (255),
PropertySplitCity nvarchar (255)

update 
Nashville
set PropertySplitAddress = substring (PropertyAddress,0 , CHARINDEX (',', propertyAddress)),
PropertySplitCity = SUBSTRING(propertyAddress, CHARINDEX (',', propertyAddress)+1,len(PropertyAddress))

--split onwer address(using Parsename)
SELECT
PARSENAME (REPLACE(OwnerAddress , ',' , '.') , 3),
PARSENAME (REPLACE(OwnerAddress , ',' , '.') , 2),
PARSENAME (REPLACE(OwnerAddress , ',' , '.') , 1)
from nashville

ALTER TABLE nashville
ADD OwnerSplitAddress nvarchar (255),
OwnerSplitCity nvarchar (255),
OwnerSplitState nvarchar (255)

update Nashville
set OwnerSplitAddress =PARSENAME (REPLACE(OwnerAddress , ',' , '.') , 3),
OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress , ',' , '.') , 2),
OwnerSplitState =PARSENAME (REPLACE(OwnerAddress , ',' , '.') , 1)

--change Y and N to YES and NO in SoldAsVacant column

select
SoldAsVacant,
case
when SoldAsVacant = 'y' then 'yes'
when SoldAsVacant = 'N' then 'NO'
else SoldAsVacant
end
from Nashville

update Nashville

set SoldAsVacant =case
when SoldAsVacant = 'y' then 'yes'
when SoldAsVacant = 'N' then 'NO'
else SoldAsVacant
end

---remove Duplicates

select 
ParcelID,LandUse,PropertyAddress,SaleDate,SalePrice,LegalReference, count(*) as Duplicate_count
from Nashville
group by ParcelID,LandUse,PropertyAddress,SaleDate,SalePrice,LegalReference
having count(*) >1



alter table nashville
drop column UniqueID

select *
from Nashville






