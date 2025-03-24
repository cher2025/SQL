/************************************
可以用来返回两个字符串字段的匹配度, 使用最长匹配算法, 乎略常见特殊字符, 也可以添加自定义乎略比对的字符, 以确保噪点影响足够小.
************************************/
CREATE FUNCTION dbo.String_Compare(
    @str1 NVARCHAR(MAX),
    @str2 NVARCHAR(MAX)
)
RETURNS float
AS
BEGIN
    DECLARE @longestMatch NVARCHAR(MAX) = '';
    DECLARE @trimmedStr1 NVARCHAR(MAX) = REPLACE(@str1, ' ', '');
	set @trimmedStr1 = REPLACE(@trimmedStr1, ':', '');
	set @trimmedStr1 = REPLACE(@trimmedStr1, '.', '');
	set @trimmedStr1 = REPLACE(@trimmedStr1, ',', '');
	set @trimmedStr1 = REPLACE(@trimmedStr1, '"', '');
	set @trimmedStr1 = REPLACE(@trimmedStr1, '''', '');
    DECLARE @trimmedStr2 NVARCHAR(MAX) = REPLACE(@str2, ' ', '');
	set @trimmedStr2 = REPLACE(@trimmedStr2, ':', '');
	set @trimmedStr2 = REPLACE(@trimmedStr2, '.', '');
	set @trimmedStr2 = REPLACE(@trimmedStr2, ',', '');
	set @trimmedStr2 = REPLACE(@trimmedStr2, '"', '');
	set @trimmedStr2 = REPLACE(@trimmedStr2, '''', '');
    DECLARE @len1 INT = LEN(@trimmedStr1);
    DECLARE @len2 INT = LEN(@trimmedStr2);
    DECLARE @i INT = 1;
    DECLARE @j INT;
    DECLARE @subStr NVARCHAR(MAX);
    WHILE @i <= @len1
    BEGIN
        SET @j = @i;
        WHILE @j <= @len1
        BEGIN
            SET @subStr = SUBSTRING(@trimmedStr1, @i, @j - @i + 1);
            IF CHARINDEX(@subStr, @trimmedStr2) > 0
            BEGIN
                IF LEN(@subStr) > LEN(@longestMatch)
                BEGIN
                    SET @longestMatch = @subStr;
                END;
            END;
            SET @j = @j + 1;
        END;
        SET @i = @i + 1;
    END;
	return len(@longestMatch)*2.0/(len(@trimmedStr1)+len(@trimmedStr2))
END
