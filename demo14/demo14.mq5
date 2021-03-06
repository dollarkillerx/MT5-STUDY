//+------------------------------------------------------------------+
//|                                                       demo14.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot small_line
#property indicator_label1  "small_line"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot big_line
#property indicator_label2  "big_line"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrYellow
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- input parameters
input int kNum = 3000; // 默认显示K线数
input ENUM_TIMEFRAMES tf = PERIOD_H4 ; // 周期
input int      small_cycle=5;  // 小周期
input int      big_cycle=10;   // 大周期
//--- indicator buffers
double         small_lineBuffer[];
double         big_lineBuffer[];

int small_ma_point;
int big_ma_point;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   ArraySetAsSeries(small_lineBuffer,true);
   ArraySetAsSeries(big_lineBuffer,true);
//--- indicator buffers mapping
   SetIndexBuffer(0,small_lineBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,big_lineBuffer,INDICATOR_DATA);
   
   
   small_ma_point = iMA(Symbol(),tf,small_cycle,0,MODE_SMA,PRICE_CLOSE);
   big_ma_point = iMA(Symbol(),tf,big_cycle,0,MODE_SMA,PRICE_CLOSE);
   printf("系统初始化完毕");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   if (kNum > rates_total) {
      printf(rates_total);
   }
   double small_ma[];
   double big_ma[];
   datetime small_time[];
   ArraySetAsSeries(small_ma,true);
   ArraySetAsSeries(big_ma,true);
   ArraySetAsSeries(small_time,true);
   ArraySetAsSeries(time,true);
   CopyBuffer(small_ma_point,0,0,kNum,small_ma);
   CopyBuffer(big_ma_point,0,0,kNum,big_ma);
   CopyTime(Symbol(),tf,0,kNum,small_time);
   int k = 0 ;
   for (int i=0;i<kNum;i++) {
      if (time[i] < small_time[k]) {  // 如果当前小k线 在大k线下面
         k++;
      }
      small_lineBuffer[i] = small_ma[k];
      big_lineBuffer[i] = big_ma[k];
   }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
