//+------------------------------------------------------------------+
//|                                                        demo7.mq5 |
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
   printf("当前货币 卖出价格: %f",SymbolInfoDouble(Symbol(),SYMBOL_BID));
   printf("当前货币 买入价格: %f",SymbolInfoDouble(Symbol(),SYMBOL_ASK));
   printf("当前货币点差: %d",SymbolInfoInteger(Symbol(),SYMBOL_SPREAD));
   printf("当前价格成交量: %d",SymbolInfoInteger(Symbol(),SYMBOL_VOLUME));
   printf("最后交易时间： %s",TimeToString(SymbolInfoInteger(Symbol(),SYMBOL_TIME)));
   
   if (SymbolInfoInteger(Symbol(),SYMBOL_SPREAD_FLOAT)) {
      printf("这个平台是浮动点差");
   }else {
      printf("这个平台是固定点差");
   }
   
   printf("停损 等级 点数: %d",SymbolInfoInteger(Symbol(),SYMBOL_TRADE_STOPS_LEVEL));
   
   printf("买入库存费: %f",SymbolInfoDouble(Symbol(),SYMBOL_SWAP_LONG));
   printf("卖出库存费: %f",SymbolInfoDouble(Symbol(),SYMBOL_SWAP_SHORT));


   // 遍历所有商品
         // SymbolsTotal(true) 获取所有的交易品数量 true 显示只是市场报价中的交易品种 (就是左边小窗显示的)  false是选择全部的品种
   for (int i=0;i<SymbolsTotal(false);i++) {
      string syname = SymbolName(i,false);
                     // 商品类型 外汇 还是 期货 还是差价合约
      if (SymbolInfoInteger(syname,SYMBOL_TRADE_CALC_MODE)==SYMBOL_CALC_MODE_FOREX) {
         printf("forex name: %s",syname);
      }
   }

   SymbolInfoTick();

  }
//+------------------------------------------------------------------+
