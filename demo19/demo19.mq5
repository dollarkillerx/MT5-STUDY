//+------------------------------------------------------------------+
//|                                                       demo19.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// 思路： 
// H4最低价 > bands 下轨  
// 均线 金叉
// kdj 金叉 


#include <transaction.mqh>
#include <kdata.mqh>
// 引入编写的mql依赖
Transction ts;
Kdata kdata;

input double openLots=0.1; // 开单手数
input int sl_inp = 2000; // 止盈点数(小点)
input int tp_inp = 2000; // 止损点数(小点)
input int devt = 100; // 滑点(小点)
input int magic=666; // majic
input int smallMA=5; // 小均线周期
input int bigMA=10; // 大均线周期
input int bands=20;// 布林带周期
input int bandsDeviation=2; // 布林带偏差
input int InpKPeriod=5;  // KDJ: K period
input int InpDPeriod=3;  // KDJ: D period
input int InpSlowing=3;  // KDJ: Slowing
// DKJ Stochastic
int OnInit()
  {
  
//--- create timer
   EventSetTimer(60);
   
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
   double smallMaM30[]; // 小周期30min MA
   kdata.MA(Symbol(),PERIOD_M30,smallMA,0,MODE_SMA,PRICE_CLOSE,smallMaM30,4);
   double bigMaM30[]; // 大周期30min MA
   kdata.MA(Symbol(),PERIOD_M30,bigMA,0,MODE_SMA,PRICE_CLOSE,bigMaM30,4);
   
   double smallMaH4[]; // 小周期4h MA
   kdata.MA(Symbol(),PERIOD_H4,smallMA,0,MODE_SMA,PRICE_CLOSE,smallMaH4,4);
   double bigMaH4[]; // 大周期4h MA
   kdata.MA(Symbol(),PERIOD_H4,bigMA,0,MODE_SMA,PRICE_CLOSE,bigMaH4,4);
   
   
     double m30bandsup[],m30bandslow[],m30bandsmid[];
     kdata.Bands(m30bandsmid,m30bandsup,m30bandslow,4,Symbol(),PERIOD_M30,bands,0,bandsDeviation,PRICE_CLOSE);
    
     double h4bandsup[],h4bandslow[],h4bandsmid[];
     kdata.Bands(h4bandsmid,h4bandsup,h4bandslow,4,Symbol(),PERIOD_H4,bands,0,bandsDeviation,PRICE_CLOSE);
     
     double m30k[],m30d[];
     kdata.Stochastic(m30k,m30d,4,Symbol(),PERIOD_M30,InpKPeriod,InpDPeriod,InpSlowing,MODE_SMA,STO_LOWHIGH);
     
     double h4k[],h4d[];
     kdata.Stochastic(h4k,h4d,4,Symbol(),PERIOD_H4,InpKPeriod,InpDPeriod,InpSlowing,MODE_SMA,STO_LOWHIGH);
     
   
   // 获取k线高开低收价
   MqlRates rateM30[];
   kdata.getRates(Symbol(),PERIOD_M30,4,rateM30);
   MqlRates rateH4[];
   kdata.getRates(Symbol(),PERIOD_H4,4,rateH4);
   
   // 1. bands 条件 H4 最低价 小于 bands 下轨
   // 2. M30 MA金叉状态
   // 3. M30 KDJ 正好金叉
   
   if (rateH4[0].low < h4bandslow[0] && smallMaM30[0] > bigMaM30[0] && m30k[0] > m30d[0] && m30k[1] < m30d[1] ) {
      ts.buyPlus(Symbol(),openLots,sl_inp,tp_inp,"cc",magic,devt);
   }else if (rateH4[0].low > h4bandsup[0] && smallMaM30[0] < bigMaM30[0] && m30k[0] < m30d[0] && m30k[1] > m30d[1]) {
      ts.sellPlus(Symbol(),openLots,sl_inp,tp_inp,"cc",magic,devt);
   }
   
   if ( m30k[0] < m30d[0] && m30k[1] > m30d[1]) {
      ts.closeAllBuyBySymbol(Symbol(),100,magic);
   }
   
   if ( m30k[0] > m30d[0] && m30k[1] < m30d[1]) {
      ts.closeAllSellBySymbol(Symbol(),100,magic);
   }
   
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
