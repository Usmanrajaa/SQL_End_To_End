-- ===================================================================
-- SQL PATTERN MATCHING & DATA MANIPULATION RULEBOOK
-- ===================================================================

-- LEVEL 1: CORE CLAUSES & BASIC FILTERING
-- ===================================================================

-- 1. CORE CLAUSES
-- SELECT, FROM, WHERE, ORDER BY

-- 2. FILTERING TECHNIQUES
-- =, >, <, !=, <>, BETWEEN, IN, NOT IN, AND, OR, IS NULL, IS NOT NULL

-- 3. DATA SHAPING OPERATIONS
-- LIKE, LIMIT, DISTINCT

-- ===================================================================
-- LIKE PATTERNS
-- ===================================================================

-- % (percent) - Zero or more characters
-- '_' (underscore) - Exactly one character

-- LIKE 'J%'        - Starts with J
-- LIKE '%son'      - Ends with son
-- LIKE '%son%'     - Contains son anywhere
-- LIKE '_a%'       - Second letter is a
-- LIKE '_____'     - Exactly 5 characters
-- NOT LIKE 'J%'    - Does not start with J

-- ===================================================================
-- REGEXP ANCHORS
-- ===================================================================

-- ^            - Start of string
-- $            - End of string
-- ^...$        - Exact match

-- REGEXP '^J'        - Starts with J
-- REGEXP 'son$'      - Ends with son
-- REGEXP '^John$'    - Exactly John

-- ===================================================================
-- REGEXP CHARACTER CLASSES
-- ===================================================================

-- .            - Any single character
-- [abc]        - Any character in set
-- [^abc]       - Any character NOT in set
-- [A-Z]        - Any uppercase letter
-- [a-z]        - Any lowercase letter
-- [0-9]        - Any digit

-- REGEXP '^J.n'       - J, any char, n
-- REGEXP '^[ABC]'     - Starts with A, B, or C
-- REGEXP '^[^ABC]'    - Does not start with A, B, or C
-- REGEXP '^[A-Z]'     - Starts with uppercase
-- REGEXP '^[a-z]+$'   - All lowercase
-- REGEXP '[0-9]'      - Contains a digit

-- ===================================================================
-- REGEXP QUANTIFIERS (LENGTH RULES)
-- ===================================================================

-- {n}         - Exactly n times
-- {n,m}       - Between n and m times
-- {n,}        - n or more times
-- +           - One or more times
-- *           - Zero or more times

-- REGEXP '^.{5}$'      - Exactly 5 characters
-- REGEXP '^.{3,6}$'    - 3 to 6 characters
-- REGEXP '^.{3,}$'     - Minimum 3 characters
-- REGEXP '^[A-Za-z]+$' - One or more letters
-- REGEXP '^[A-Z].*'    - Starts with uppercase

-- ===================================================================
-- REGEXP ALTERNATION (OR)
-- ===================================================================

-- | - OR/alternation

-- REGEXP 'Sales|IT'       - Contains Sales or IT
-- REGEXP 'John|Jane|Jim'  - Contains John, Jane, or Jim

-- ===================================================================
-- REGEXP SPECIAL CHARACTERS (ESCAPE RULES)
-- ===================================================================

-- \\btext\\b    - Word boundary
-- \\.           - Literal dot
-- \\\\          - Literal backslash

-- REGEXP '\\bteam\\b'    - Whole word team
-- REGEXP '\\.com$'       - Ends with .com
-- REGEXP '\\\\'          - Contains backslash

-- ===================================================================
-- NOT REGEXP
-- ===================================================================

-- NOT REGEXP '^J'    - Does not start with J

-- ===================================================================
-- CASE EXPRESSIONS
-- ===================================================================

-- CASE
--     WHEN condition1 THEN result1
--     WHEN condition2 THEN result2
--     ELSE default_result
-- END AS alias

-- ===================================================================
-- ORDER BY RULES
-- ===================================================================

-- ORDER BY column ASC      - Ascending (default)
-- ORDER BY column DESC     - Descending
-- ORDER BY col1, col2      - Multiple columns
-- ORDER BY CASE...         - Custom sort

-- ===================================================================
-- LIMIT & OFFSET RULES
-- ===================================================================

-- LIMIT n          - Return n rows
-- OFFSET n         - Skip n rows
-- LIMIT n OFFSET m - Pagination

-- ===================================================================
-- DISTINCT RULES
-- ===================================================================

-- SELECT DISTINCT col1              - Unique values in one column
-- SELECT DISTINCT col1, col2        - Unique combinations