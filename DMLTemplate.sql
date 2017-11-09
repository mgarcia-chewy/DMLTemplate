-- Enabling row count, and transaction abort
SET NOCOUNT OFF;
SET XACT_ABORT ON;
--Transaction begins here
BEGIN
	-- TRY begins here:
	BEGIN TRY
		-- Check trancount:
			IF @@TRANCOUNT <> 1
				BEGIN
					RAISERROR('*** Invalid transaction count! Please re-execute transaction. ***',16,1);
				END;
		-- Transaction begins here:
		BEGIN TRANSACTION Process
			PRINT '*** Transaction started at: ' + CONVERT(VARCHAR(32), SYSDATETIME(), 126) + ' ***';
			-- Enabling query time statistics
			SET STATISTICS TIME ON;
			-- DML change goes here:



			-- Explicit COMMIT:
       COMMIT TRANSACTION Process;
	   -- Disabling query time statistics
	   SET STATISTICS TIME OFF;
       PRINT '*** Transaction completed at: ' + CONVERT(VARCHAR(32), SYSDATETIME(), 126) + ' ***';
	END TRY
	-- CATCH begins here: 
	BEGIN CATCH
		SELECT  ERROR_NUMBER() AS ErrorNumber ,
				ERROR_SEVERITY() AS ErrorSeverity ,
				ERROR_STATE() AS ErrorState ,
				ERROR_PROCEDURE() AS ErrorProcedure ,
				ERROR_LINE() AS ErrorLine ,
				ERROR_MESSAGE() AS ErrorMessage;
		PRINT '*** Error Encountered!' + CONVERT(VARCHAR(32), SYSDATETIME(), 126) + ' ***';
		PRINT 'Error Number: ' + LTRIM(STR(ERROR_NUMBER()));
		PRINT 'Error Severity: ' + LTRIM(STR(ERROR_SEVERITY()));
		PRINT 'Error State: ' + LTRIM(STR(ERROR_STATE()));
		PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), '');
		PRINT 'Error Line: ' + LTRIM(STR(ERROR_LINE()));
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		-- Explicit ROLLBACK
		IF @@TRANCOUNT > 0
			BEGIN 
				ROLLBACK TRANSACTION Process;
				PRINT '*** Transaction was rolled back! ' + CONVERT(VARCHAR(32), SYSDATETIME(), 126) + ' ***';
			END;
	-- End of TRY/CATCH
	END CATCH;
END;
GO
