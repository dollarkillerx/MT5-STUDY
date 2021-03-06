//+------------------------------------------------------------------+
//|                                                        demo8.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   // 订阅货币对市场深度
   if (MarketBookAdd(Symbol())) {
      printf("订阅 %s 市场深度成功",SymbolName(Symbol(),true));
   }else {
      printf("订阅失败");
   }
   // MarketBookRelease(Symbol()) 取消订阅
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
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol) // 订阅市场深度改变就执行
  {
//---
   //  获取当前市场深度
      MqlBookInfo book[];
      if (MarketBookGet(Symbol(),book)) {
         int size = ArraySize(book);
         for (int i=0;i<size;i++) {
            Print(i+":",book[i].price  
                  +"    Volume = "+book[i].volume,
                  " type = ",book[i].type);
         }
      }
   
  }
//+------------------------------------------------------------------+
