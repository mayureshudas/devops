CREATE OR REPLACE PACKAGE BODY XX_CREATE_ITEM
AS

  PROCEDURE XX_CREATEITEM    (errbuf    OUT  VARCHAR2,
                             retcode   OUT  VARCHAR2 )
							 
  IS
  l_item_table EGO_Item_PUB.Item_Tbl_Type;
  l_item_num NUMBER := 0;
  x_item_table EGO_Item_PUB.Item_Tbl_Type;
  x_return_status VARCHAR2(1);
  x_msg_count NUMBER(10);
   x_msg_data VARCHAR2(1000);
  x_message_list Error_Handler.Error_Tbl_Type;
BEGIN

 SELECT XX_JENKINS_TEST_SEQ.NEXTVAL
 INTO  l_item_num 
 FROM DUAL; 
 
--Apps Initialization

FND_GLOBAL.APPS_INITIALIZE(USER_ID=>1014703,RESP_ID=>20634,RESP_APPL_ID=>401);-- Please Change

--FIRST Item definition
l_item_table(1).Transaction_Type := 'CREATE'; -- Replace this with 'UPDATE' for update transaction.
l_item_table(1).Segment1 := 'TEST-DEVOPS_'||l_item_num;
l_item_table(1).Description := 'TEST-DEVOPS_'||l_item_num;  
l_item_table(1).Organization_Code := 'V1'; --masterorg
l_item_table(1).Template_Name := '@Finished Good'; --template

fnd_file.put_line(fnd_file.output,'Calling API to Create Item');

EGO_ITEM_PUB.Process_Items(
p_api_version => 1.0
,p_init_msg_list => FND_API.g_TRUE
,p_commit => FND_API.g_TRUE
,p_Item_Tbl => l_item_table
,x_Item_Tbl => x_item_table
,x_return_status => x_return_status
,x_msg_count => x_msg_count);

fnd_file.put_line(fnd_file.output,'Sucess:'||'TEST-DEVOPS_'||l_item_num);
fnd_file.put_line(fnd_file.output,'Return Status ==>' ||x_return_status);
DBMS_OUTPUT.PUT_LINE('x_msg_count='||x_msg_count);
DBMS_OUTPUT.PUT_LINE('x_return_status='||x_return_status);
IF (x_return_status = FND_API.G_RET_STS_SUCCESS) THEN
FOR i IN 1..x_item_table.COUNT LOOP
fnd_file.put_line(fnd_file.output,'Inventory Item Id Created:'||to_char(x_item_table(i).Inventory_Item_Id));
DBMS_OUTPUT.PUT_LINE('Item ='||to_char(x_item_table(i).Inventory_Item_Id));
fnd_file.put_line(fnd_file.output,'Organization Id :'||to_char(x_item_table(i).Organization_Id));
END LOOP;
ELSE
fnd_file.put_line(fnd_file.output,'Error Messages :'||'TEST-DEVOPS_'||l_item_num);
Error_Handler.GET_MESSAGE_LIST(x_message_list=>x_message_list);
FOR i IN 1..x_message_list.COUNT LOOP
fnd_file.put_line(fnd_file.output,x_message_list(i).message_text);
END LOOP;
END IF;

EXCEPTION
WHEN OTHERS THEN
fnd_file.put_line(fnd_file.output,'Error has Occured and error is '||SUBSTR(SQLERRM,1,200));
							 
							 
END XX_CREATEITEM;
							 
END XX_CREATE_ITEM;
/
