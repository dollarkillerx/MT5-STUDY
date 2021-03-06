//+------------------------------------------------------------------+
//|                                                        demo9.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <demo9.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   string symName = SymbolName(Symbol(),true);
   Kdata kdata(symName);
   
   printf("当前货币: %s 买入价格: %f  卖出价格: %f",symName,kdata.getAsk(),kdata.getBid());
  
   // 获取高开低收价格
   double open[];  // 数据容器
   ArraySetAsSeries(open,true); // 数据倒装 最右边为0
   // 获取K线开盘数据 Symbol(),0自动适应时间周期,开始位置,获取数量,容器
   CopyOpen(Symbol(),0,0,10,open); 
   printf("当前货币0位置价格: %f",open[0]);
   
   if (kdata.getOpen(10)) {
      printf("当前货币0位置价格: %f",kdata.open[0]);
   }
   
   // 获取IMA均线
   double ma[];
   ArraySetAsSeries(ma,true);
   int ma_h; // 句柄
      // 货币,周期,平均周期,平移,平滑类型,
   ma_h = iMA(Symbol(),0,12,0,MODE_SMA,PRICE_CLOSE);// 12日均线 SMA  以收盘价计算
      // 拷贝数据 句柄,指标缓冲区数,开始位置,获取数量,容器
   CopyBuffer(ma_h,0,0,10,ma);
   IndicatorRelease(ma_h); // 释放句柄
   printf("MA 1: %f",ma[1]);
   
   if (kdata.getMA(Symbol(),10,0,12,0,MODE_SMA,PRICE_CLOSE)) {
      printf("MA 1: %f",kdata.ma[1]);
   }
   
   kdata.getADX(Symbol(),10,0,14);
   printf("ADx 1 0: %f",kdata.adx0[1]);
   printf("ADx 1 1: %f",kdata.adx1[1]);
   printf("ADx 1 2: %f",kdata.adx2[1]);
   
   
   // 调用第三方指标   货币,周期,指标名称, 指标参数...
   int point3 = iCustom(Symbol(),0,"CCI",14);
   double cci[];
   ArraySetAsSeries(cci,true);
   CopyBuffer(point3,0,0,10,cci);
   IndicatorRelease(point3);
   printf("CCI 1 :%f",cci[1]);
  }
//+------------------------------------------------------------------+
