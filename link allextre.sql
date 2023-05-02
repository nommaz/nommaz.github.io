SELECT
	CAR002_HesapKodu as "Acct Code",
	ISNULL(NULLIF(CAR002_Kod4,''), dbo.ToProperCase(CAR002_Unvan1)) as "Acct Name" ,
	CAR002_GrupKodu as "Acct Type",
	CAR003_Row_ID as "Op ID",
	ISNULL(CAR003_AsilEvrakTarihi, 44166) "Op Date" ,
	CAR003_IslemTipi as "Op Type",
	CAR003_EvrakSeriNo as "Op Name",
	CAR003_Aciklama as "Op Detail",
	CASE WHEN CAR003_IslemTipi IN(5, 9, 82) OR (CAR003_BA = 1) THEN
		- 1 * CAR003_Tutar
	ELSE
		CAR003_Tutar
	END AS "Op Amount" 
	
FROM
	YNS02023.CAR002 WITH (NOLOCK)
	LEFT JOIN YNS02023.CAR003 WITH (NOLOCK) ON 
	CAR002_HesapKodu = CAR003_HesapKodu
		AND(NOT CAR003_IslemTipi IN(16,25,34,44,61,62,86,87))
		AND(CAR003_Tarih >= 44166 AND CAR003_Tarih <= 72686)
		AND CAR003_IptalDurumu = 1
WHERE
		NOT CAR002_HesapKodu IN('1018', '2429')
		AND CAR002_MuhasebeKodu like '120 %'

UNION ALL
	
SELECT
	CAR002_HesapKodu,
	ISNULL(NULLIF(CAR002_Kod4,''), dbo.ToProperCase(CAR002_Unvan1)) as "Acct Name" ,
	CAR002_GrupKodu,
	CAR003_Row_ID,
	ISNULL(CAR003_AsilEvrakTarihi,44166) CAR003_AsilEvrakTarihi,
	CAR003_IslemTipi,	
	CAR003_EvrakSeriNo,
	CAR003_Aciklama,
	CASE WHEN CAR003_IslemTipi IN(5,9,82) OR (CAR003_BA = 0) THEN
		- 1 * CAR003_Tutar
	ELSE
		CAR003_Tutar
	END AS CAR003_Tutar
FROM
	YNS02023.CAR002 WITH (NOLOCK)
	INNER JOIN YNS02023.CAR003 WITH (NOLOCK) 
	ON CAR002_HesapKodu = CAR003_KarsiHesapKodu
		AND( NOT CAR003_IslemTipi IN(16,25,34,44,61,62,86,87))
		AND(CAR003_Tarih >= 44166 AND CAR003_Tarih <= 72686)
		AND CAR003_IptalDurumu = 1
WHERE
		NOT CAR002_HesapKodu IN('1018', '2429')
		AND CAR002_MuhasebeKodu like '120 %'
		
ORDER BY
	"Acct Code",
	"Op ID" DESC
	
OFFSET 0 ROWS FETCH NEXT 2000 ROWS ONLY;