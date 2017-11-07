CREATE OR REPLACE PACKAGE BODY XXCG_AR_MISC_RCPT_OUTBOUND_PKG
AS
  /* ==========================================================================================================
  * Module Type   : PL/SQL
  * Module Name   : XXCG_AR_MISC_RCPT_OUTBOUND_PKG.pkb
  * Description   : This package is used to extract AR std receipt.
  * Run Env.      : SQL*Plus
  *
  * History
  * =======
  *
  * Version Name            Date        Description of Change
  * ------- -------------  ----------- ----------------------------------------------------------------------
  * 0.1     Sagar P         07-Aug-17   Initial Version
   * =========================================================================================================*/

PROCEDURE POPULATE_MISCRCPT_POLING_TBL(p_errbuf            OUT NOCOPY VARCHAR2
                                         ,p_retcode         OUT NOCOPY VARCHAR2
								         ,p_rcpt_id         IN NUMBER
										 ,p_cust_id         IN NUMBER
								         ,p_date_from       IN DATE
								         ,p_date_to         IN DATE
								     )
IS

g_user_id      NUMBER:= fnd_global.user_id;
g_login_id     NUMBER:= fnd_global.login_id;

  l_count         NUMBER :=0;
  l_record_status VARCHAR2(10);
  l_start_date    DATE;

	--Hdr cursor
	CURSOR rcpt_hdr_cur
	IS
	SELECT 'N' record_status,
    acr.cash_receipt_id rcpt_id,
	acr.amount,
    acr.currency_code ,
	TO_CHAR(acr.Anticipated_Clearing_Date,'YYYY-MM-DD') clearing_date,
	acr.cash_receipt_id CashReceiptId,
	acr.Comments,
    TO_CHAR(acr.Deposit_Date,'YYYY-MM-DD') deposit_date,
    NULL DocumentSequenceValue,
	NULL exchange_date,
	acr.Exchange_Rate_Type ExchangeRateType,
	TO_CHAR(acrh.gl_date,'YYYY-MM-DD') gl_date,
    NULL ReceiptMethodId,
    acr.receipt_number rcpt_number,
    acr.org_id,
    --acr.receivables_trx_id receivable_trx_id,
    NULL receivable_trx_id,
    NULL PaymentTransactionExtensionId,
    acr.misc_payment_source MiscellaneousPaymentSource,
    TO_CHAR(acr.receipt_date,'YYYY-MM-DD') rcpt_date,
    NULL ReferenceId,
    NULL RemittanceBankAccountId,
    NULL TaxCode,
    NULL TaxRate,
    NULL UserCurrencyCode,
    NULL UserExchangeRateType,
    acr.USSGL_Transaction_Code USSGLTransactionCode,
    NULL VATTaxId,
    NULL TaxAmount,
    arm.name rcpt_method,
    acr.activity ReceivableActivityName,
    INITCAP(acr.reference_type) ReferenceType,
    NULL ReferenceNumber,
    cba.bank_account_name bank_acct_name,
    --cba.bank_account_num bank_acct_num
	NULL bank_acct_num		
FROM ar_cash_receipts_v acr,
     ar_cash_receipt_history_all acrh,
	 ar_receipt_methods arm,
	 ar_payment_schedules_all ps,
	 ce_bank_acct_uses_ou cbau,
	 ce_bank_accounts cba
WHERE 1=1
AND acrh.cash_receipt_id(+) = acr.cash_receipt_id 
AND acrh.org_id(+) = acr.org_id
AND acrh.first_posted_record_flag(+) = 'Y'
AND acr.Receipt_Method_Id  = arm.Receipt_Method_Id
AND ps.cash_receipt_id(+) = acr.cash_receipt_id 
AND ps.org_id(+) = acr.org_id
AND cbau.bank_acct_use_id (+) = acr.remit_bank_acct_use_id 
AND cbau.org_id (+) = acr.org_id
AND cbau.bank_account_id = cba.bank_account_id (+)
AND acr.org_id = fnd_profile.value('ORG_ID')
AND acr.type = 'MISC'
AND acr.Cash_Receipt_Id = NVL(p_rcpt_id,acr.Cash_Receipt_Id)
AND (acr.customer_id IS NULL OR acr.customer_id = NVL(p_cust_id, acr.customer_id ))
AND (acr.last_update_date) BETWEEN NVL(NVL(l_start_date,TO_DATE(p_date_from, 'YYYY/MM/DD HH24:MI:SS')), (acr.last_update_date)) AND NVL(TO_DATE(p_date_to, 'YYYY/MM/DD HH24:MI:SS'),(acr.last_update_date))
	;

		   
BEGIN

  fnd_file.put_line(fnd_file.log,'Start - XXCUST AR Misc Receipt Outbound');
  fnd_file.put_line(fnd_file.log,'Parameter List');
  fnd_file.put_line(fnd_file.log,'Receipt ID: '||p_rcpt_id);
  fnd_file.put_line(fnd_file.log,'Cust Id: '||p_cust_id);
  fnd_file.put_line(fnd_file.log,'From Date : '||p_date_from);
  fnd_file.put_line(fnd_file.log,'To Date : '||p_date_to);
  
  BEGIN
    SELECT NVL(MAX(requested_start_date),SYSDATE)
      INTO l_start_date
      FROM fnd_concurrent_requests fcr,
           fnd_concurrent_programs_tl fcp
     WHERE fcp.concurrent_program_id        = fcr.concurrent_program_id
       AND fcp.user_concurrent_program_name ='XXCUST AR Misc Receipt Outbound'
       AND fcr.phase_code                   ='C'
       AND fcr.status_code                  ='C';
  EXCEPTION
   WHEN OTHERS THEN
     l_start_date := NULL;
	 fnd_file.put_line(fnd_file.log,'l_start_date NULL');
  END;
  
  fnd_file.put_line(fnd_file.log,'l_start_date : '||TO_CHAR(l_start_date,'dd-Mon-yyyy hh24:mi:ss'));

   -- Header Loop start
    FOR rcpt_hdr_rec IN rcpt_hdr_cur
    LOOP
	 BEGIN
	   fnd_file.put_line(fnd_file.log,'---***---');
	   fnd_file.put_line(fnd_file.log,'AR Misc Rcpt Header Loop '||rcpt_hdr_rec.CashReceiptId);	

		  -- Header Insert
		   fnd_file.put_line(fnd_file.log,'insert into hdr tbl');
		  INSERT INTO xxcg_ar_misc_rcpt_outbound
		   (record_status  
			,rcpt_id 
			,amount 
			,currency_code 
			,clearing_date 
			,CashReceiptId 
			,comments 
			,deposit_date 
			,DocumentSequenceValue 
			,exchange_date 
			,ExchangeRateType 
			,gl_date 
			,ReceiptMethodId 
			,rcpt_number 
			,org_id 
			,receivable_trx_id  
			,PaymentTransactionExtensionId  
			,MiscellaneousPaymentSource  
			,rcpt_date 
			,ReferenceId 
			,RemittanceBankAccountId 
			,TaxCode 
			,TaxRate 
			,UserCurrencyCode 
			,UserExchangeRateType 
			,USSGLTransactionCode 
			,VATTaxId 
			,TaxAmount 
			,rcpt_method 
			,ReceivableActivityName 
			,ReferenceType 
			,ReferenceNumber 
			,bank_acct_name 
			,bank_acct_num 
			,CREATED_BY                	    
			,CREATION_DATE             	    
			,LAST_UPDATED_BY           	       	    
			,LAST_UPDATE_DATE
			,LAST_UPDATE_LOGIN 			
			 )
			 VALUES
			  ( rcpt_hdr_rec.record_status  
			,rcpt_hdr_rec.rcpt_id 
			,rcpt_hdr_rec.amount 
			,rcpt_hdr_rec.currency_code 
			,rcpt_hdr_rec.clearing_date 
			,rcpt_hdr_rec.CashReceiptId 
			,rcpt_hdr_rec.comments 
			,rcpt_hdr_rec.deposit_date 
			,rcpt_hdr_rec.DocumentSequenceValue 
			,rcpt_hdr_rec.exchange_date 
			,rcpt_hdr_rec.ExchangeRateType 
			,rcpt_hdr_rec.gl_date 
			,rcpt_hdr_rec.ReceiptMethodId 
			,rcpt_hdr_rec.rcpt_number 
			,rcpt_hdr_rec.org_id 
			,rcpt_hdr_rec.receivable_trx_id  
			,rcpt_hdr_rec.PaymentTransactionExtensionId  
			,rcpt_hdr_rec.MiscellaneousPaymentSource  
			,rcpt_hdr_rec.rcpt_date 
			,rcpt_hdr_rec.ReferenceId 
			,rcpt_hdr_rec.RemittanceBankAccountId 
			,rcpt_hdr_rec.TaxCode 
			,rcpt_hdr_rec.TaxRate 
			,rcpt_hdr_rec.UserCurrencyCode 
			,rcpt_hdr_rec.UserExchangeRateType 
			,rcpt_hdr_rec.USSGLTransactionCode 
			,rcpt_hdr_rec.VATTaxId 
			,rcpt_hdr_rec.TaxAmount 
			,rcpt_hdr_rec.rcpt_method 
			,rcpt_hdr_rec.ReceivableActivityName 
			,rcpt_hdr_rec.ReferenceType 
			,rcpt_hdr_rec.ReferenceNumber 
			,rcpt_hdr_rec.bank_acct_name 
			,rcpt_hdr_rec.bank_acct_num,                   
			 --**--
				NVL(g_user_id,-1), 
			    SYSDATE ,    
			    NVL(g_user_id,-1), 
			    SYSDATE,
			    NVL(g_login_id,-1)   
				);  

	   
	 EXCEPTION
	  WHEN OTHERS THEN
	   dbms_output.put_line('Hdr insert err '||SQLERRM);
	   fnd_file.put_line(fnd_file.log,'Hdr insert err '||SQLERRM);
	 END;
    END LOOP;
   
   COMMIT;
	 
EXCEPTION
WHEN OTHERS THEN
 dbms_output.put_line('proc POPULATE_MISCRCPT_POLING_TBL Err '||SQLERRM);
 fnd_file.put_line(fnd_file.log,'proc POPULATE_MISCRCPT_POLING_TBL Err '||SQLERRM);
END POPULATE_MISCRCPT_POLING_TBL;	 

END XXCG_AR_MISC_RCPT_OUTBOUND_PKG;
/
SHOW errors;