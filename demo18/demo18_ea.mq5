//+------------------------------------------------------------------+
//|                                                    demo18_ea.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <transaction.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);

   printf("系统初始化完毕");   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  printf("s1 start");
  Transction tf;
//  ulong id = tf.buyPlus(Symbol(),0.01,0,0,"ac",666,100);
////  printf("买单id: %d",id);
////  
//  ulong id2 = tf.sellPlus(Symbol(),0.01,0,0,"ac",666,100);
////  printf("卖单id: %d",id2);
//   //ulong id = tf.buyPendingPlus(3000,Symbol(),0.01,0,0,"cc",888,100);
//   //printf("pending 买单id: %d",id);
//   //id = tf.sellPendingPlus(300,Symbol(),0.01,0,0,"cc",888,100);
//   //printf("pending 卖单id: %d",id);
//   
//   int total = tf.positionGetAllTotal(Symbol());
//   printf("当前货币total: %d",total);
//   
//   total = tf.positionGetTotal(Symbol(),POSITION_TYPE_BUY,666);
//   printf("当前ea 货币buy单数量: %d",total);
//  printf("s1 end");


   //double a = 0.122;
   //printf("a: %f",tf.formatLots(Symbol(),a));
   //ulong id = tf.buyPlus(Symbol(),0.120000,0,0,"ac",666,100);
   //printf("买单id: %d",id);
   transctionOrderData data;
   ulong id = tf.positionGetRecent(Symbol(),POSITION_TYPE_BUY,0,data);
   printf("id :%d op_time: %s op: %f  tp: %f  sl: %f  lots: %f",id,TimeToString(data.openTime),data.openPrice,data.openTp,data.openSl,data.openLots);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol)
  {
//---
   
  }
//+------------------------------------------------------------------+
