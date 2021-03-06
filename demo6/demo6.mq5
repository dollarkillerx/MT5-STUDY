//+------------------------------------------------------------------+
//|                                                        demo6.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   // 获取账户信息
   
   
   string userName = AccountInfoString(ACCOUNT_NAME);
   printf("userName: %s \n",userName);
   
       // 账户是否运行EA交易
   if (AccountInfoInteger(ACCOUNT_TRADE_EXPERT)) {
      printf("允许EA交易\n");
   }else {
      printf("不允许EA交易\n");
   }
   
   printf(AccountInfoInteger(ACCOUNT_TRADE_EXPERT));
   
   if (AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO) {
      printf("这是模拟账户!!\n");
   }
   
   int userId = AccountInfoInteger(ACCOUNT_LOGIN);
   printf("账户ID:%d\n",userId);
   
   int maxOpenOrder = AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   printf("MaxOrder: %d \n",maxOpenOrder);
   
   int gx = AccountInfoInteger(ACCOUNT_LEVERAGE);
   printf("获取账户杠杆: %d \n",gx);
   
   printf("交易商名称:%s \n",AccountInfoString(ACCOUNT_COMPANY));
   
   printf("获取交易服务器名称: %s \n",AccountInfoString(ACCOUNT_SERVER));
   
   
   // 获取MT5 客户端信息
   printf("CPU number :%d ",TerminalInfoInteger(TERMINAL_CPU_CORES));
   if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
      printf("允许ea交易");
   }else {
      printf("不允许ea交易");
   }
   
   printf("网络连载质量 %f",TerminalInfoDouble(TERMINAL_RETRANSMISSION));
   
   printf("程序端语言: %s",TerminalInfoString(TERMINAL_LANGUAGE));
   
   printf("最后一次交易的Ping延迟: %d",TerminalInfoInteger(TERMINAL_PING_LAST));
   
   printf("公司名称:%d",TerminalInfoString(TERMINAL_COMPANY));
   
   if (MQLInfoInteger(MQL_TESTER)) {
      printf("代码在测试模式下运行!");
   }else {
      printf("代码在非非测试模式下运行!");
   }
   
   printf("软件名称: %s",MQLInfoString(MQL_PROGRAM_NAME));
   printf("软件路径: %s",MQLInfoString(MQL_PROGRAM_PATH)); 
   
   
   printf("当前窗口 货币对名称: %s",Symbol());
  
   if (Period() == PERIOD_M30) {
      printf("当前EA运行在30Min 图上");
   }else {
      printf("当前ea 运行在非30min 图上");
   }
   
   printf("当前价格精度: %d",Digits());
   printf("当前交易品种大小点: %f",Point());
   
   SymbolInfoString
  }
//+------------------------------------------------------------------+
