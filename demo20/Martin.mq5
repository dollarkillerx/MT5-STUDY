//+------------------------------------------------------------------+
//|                                                       Martin.mq5 |
//|                                                     DollarKiller |
//|                                 https://github.com/dollarkillerx |
//+------------------------------------------------------------------+
#property copyright "DollarKiller"
#property link      "https://github.com/dollarkillerx"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <transaction.mqh>
#include <kdata.mqh>
#include <img.mqh>
Transction ts;
Kdata kdata;
Img img;
input int dd;//
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+


// 初始化系统
void initBand() {
   printf("Dollarkiller Martin 系统初始化完毕");
   printf(TimeToString(TimeTradeServer(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
   img.button("anni")
}