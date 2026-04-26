CREATE DEFINER=`root`@`localhost` PROCEDURE `MiniStatement`(PAR_AccountID INT)
BEGIN
	DECLARE Var_Name Char(30);
    DECLARE Var_Currentbalance INT;
    SELECT NOW() AS Todaya_DateTime;
    IF EXISTS (
        SELECT * FROM Accountdetails
        WHERE AccountID = Par_AccountID)
	THEN
        SELECT Par_AccountID AS AccountID;
        SELECT Name, Currentbalance INTO Var_NAme, Var_Currentbalance
            FROM Accountdetails
            WHERE AccountID = Par_AccountID;
		SELECT Var_Name AS CustomerName;
        SELECT * FROM Transactiondetails
             WHERE AccountID = Par_AccountID
             AND TIMESTAMPDIFF(MONTH, Transactiontime, NOW())<6;
		SELECT Var_Currentbalance AS Currentbalance;
	ELSE
		SELECT 'Invalid AccountID' AS Message;
	END IF;
END