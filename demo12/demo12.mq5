//+------------------------------------------------------------------+
//|                                                       demo12.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 18
#property indicator_plots   7
//--- plot line1
#property indicator_label1  "line1"
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  clrRed,clrMediumPurple,clrMediumTurquoise,clrDarkViolet
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2  // 粗细
//--- plot line2
#property indicator_label1  "line2"
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  clrRed,clrMediumPurple,clrMediumTurquoise,clrDarkViolet
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2  // 粗细
//--- plot his1
#property indicator_label2  "his1"
#property indicator_type2   DRAW_COLOR_HISTOGRAM
#property indicator_color2  clrRed,clrChocolate
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot his1pro
#property indicator_label3  "his1pro"
#property indicator_type3   DRAW_COLOR_HISTOGRAM2
#property indicator_color3  clrRed,clrForestGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot up
#property indicator_label4  "up"
#property indicator_type4   DRAW_COLOR_ARROW
#property indicator_color4  clrOrangeRed,clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot down
#property indicator_label5  "down"
#property indicator_type5   DRAW_COLOR_ARROW
#property indicator_color5  clrMediumSeaGreen,clrDarkGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- plot lazhu
#property indicator_label6  "lazhu"
#property indicator_type6   DRAW_COLOR_CANDLES
#property indicator_color6  clrDeepSkyBlue,clrBlue
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1


//--- indicator buffers
double         line1Buffer[];
double         line1Colors[];
double         line2Buffer[];
double         line2Colors[];
double         his1Buffer[];
double         his1Colors[];
double         his1proBuffer1[];
double         his1proBuffer2[];
double         his1proColors[];
double         upBuffer[];
double         upColors[];
double         downBuffer[];
double         downColors[];
double         lazhuBuffer1[];
double         lazhuBuffer2[];
double         lazhuBuffer3[];
double         lazhuBuffer4[];
double         lazhuColors[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

// 调用系统自带指数
int ma5_proint;
int ma10_proint;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,line1Buffer,INDICATOR_DATA);  // 数据缓冲区
   SetIndexBuffer(1,line1Colors,INDICATOR_COLOR_INDEX); // 色彩缓冲区
   SetIndexBuffer(16,line1Buffer,INDICATOR_DATA);  // 数据缓冲区
   SetIndexBuffer(17,line1Colors,INDICATOR_COLOR_INDEX); // 色彩缓冲区
   SetIndexBuffer(2,his1Buffer,INDICATOR_DATA);
   SetIndexBuffer(3,his1Colors,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(4,his1proBuffer1,INDICATOR_DATA);
   SetIndexBuffer(5,his1proBuffer2,INDICATOR_DATA);
   SetIndexBuffer(6,his1proColors,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(7,upBuffer,INDICATOR_DATA);
   SetIndexBuffer(8,upColors,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(9,downBuffer,INDICATOR_DATA);
   SetIndexBuffer(10,downColors,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(11,lazhuBuffer1,INDICATOR_DATA);
   SetIndexBuffer(12,lazhuBuffer2,INDICATOR_DATA);
   SetIndexBuffer(13,lazhuBuffer3,INDICATOR_DATA);
   SetIndexBuffer(14,lazhuBuffer4,INDICATOR_DATA);
   SetIndexBuffer(15,lazhuColors,INDICATOR_COLOR_INDEX);

//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(3,PLOT_ARROW,159);
   PlotIndexSetInteger(4,PLOT_ARROW,159);


// 调用系统自带
   ma5_proint = iMA(NULL,0,5,0,MODE_SMA,PRICE_CLOSE);
   ma10_proint = iMA(NULL,0,10,0,MODE_SMA,PRICE_CLOSE);
//---
   printf("Demo12 初始化完毕");
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
   double ma5[];
   double ma10[];
   CopyBuffer(ma5_proint,0,0,rates_total,ma5);
   CopyBuffer(ma10_proint,0,0,rates_total,ma10);
   int start = 0;
   if(prev_calculated > 0)
     {
      start = prev_calculated - 1;
     }
   for(int i = start; i<rates_total; i++)
     {
      line1Buffer[i] = ma5[i];
      // line2Buffer[i] = ma10[i];
      if(open[i] > ma5[i])
        {
         line1Colors[i] = 1; // 转换颜色
        }
     }


//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
